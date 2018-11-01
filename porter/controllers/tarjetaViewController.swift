//
//  tarjetaViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import JGProgressHUD
protocol tarjetaDelegate {
	func updateCard()
}
class tarjetaViewController: UIViewController,STPPaymentCardTextFieldDelegate,CardIOPaymentViewControllerDelegate,UITextFieldDelegate {
	@IBOutlet weak var nameView: UIView!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var cardNumber: UITextField!
	@IBOutlet weak var expDate: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var scanButton: UIButton!
	var delegate: tarjetaDelegate?
	var create = true
	var tarjeta: card?
	private var previousTextFieldContent: String?
	private var previousSelection: UITextRange?
	let hud = JGProgressHUD(style: .dark)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Añadir método de pago"
		self.navigationController?.navigationBar.tintColor = .white
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		if tarjeta != nil{
			self.name.text = requestManager.instance.user.firstName! + " " + requestManager.instance.user.lastName!
			//self.cardNumber.text = tarjeta.number?.description
			//self.expDate.text = tarjeta.exp!
			//self.title = "Editar método de pago"
		}
		nameView.setBorder(color: darkBlue, width: 2.0, radius: 12)
		cardView.setBorder(color: darkBlue, width: 2.0, radius: 12)
		saveButton.setBorder(color: darkBlue, width: 0, radius: 25)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(tapGesture)
		CardIOUtilities.preload()//CardIOUtilities.preload()
		scanButton.setBorder(color: darkBlue, width: 0.0, radius: 12)
		expDate.delegate = self
		cardNumber.delegate = self
		cardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func handleTap(sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func saveAction(_ sender: Any) {
		let card = STPCardParams()
		
		card.number = cardNumber.text!
		card.expMonth = UInt(expDate.text!.components(separatedBy: "/")[0])! //as! UInt
		card.expYear = UInt(expDate.text!.components(separatedBy: "/")[1])! //as! UInt
		//card.
		self.getStripeToken(card: card)
	}
	func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
		paymentViewController?.dismiss(animated: true, completion: nil)
	}
	
	func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
		if let info = cardInfo {
			let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
			print(str)
			//dismiss scanning controller
			paymentViewController?.dismiss(animated: true, completion: nil)			
			//create Stripe card
			let card: STPCardParams = STPCardParams()
			card.number = info.cardNumber
			card.expMonth = info.expiryMonth
			card.expYear = info.expiryYear
			card.cvc = info.cvv
			self.cardNumber.text = info.cardNumber
			self.expDate.text = info.expiryMonth.description + "/" + info.expiryYear.description
			//Send to Stripe
			hud.textLabel.text = "Generando Token de la tarjeta"
			hud.show(in: self.view)
			self.saveButton.isEnabled = false
			self.saveButton.isHidden = true
			self.getStripeToken(card: card)
		}
	}
	
	//Callback when card is scanned correctly

	func getStripeToken(card:STPCardParams) {
		// get stripe token for current card
		STPAPIClient.shared().createToken(withCard: card) { [weak self]token, error in
			if let token = token {
				print(token)
				//SVProgressHUD.showSuccessWithStatus("Stripe token successfully received: \(token)")
				if let strongself = self{
					strongself.hud.textLabel.text = "Guardando informacion de la tarjeta en el servidor"
					strongself.postStripeToken(token: token)
				}
				
			} else {
				//print(error!.localizedDescription)
				if let strongSelf = self{
					strongSelf.showError(tittle: "Tarjeta no Válida", error: error!.localizedDescription)
					strongSelf.cardNumber.text = ""
					strongSelf.expDate.text = ""
					strongSelf.saveButton.isHidden = false
					strongSelf.saveButton.isEnabled = true
				}
				
				//SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
			}
		}
	}
	func postStripeToken(token: STPToken) {
		//Set up these params as your backend require
		//let params: [String: NSObject] = ["stripeToken": token.tokenId, "amount": 10]
		let params: Parameters = ["token": token]
		routeClient.instance.createCardToken(params: params, success: {[weak self] data in
			do {
				let value = try JSONDecoder().decode(createCardResponse.self, from: data)
				if value.object != nil{
					if let strongSelf = self{
						strongSelf.hud.dismiss()
						strongSelf.showError(tittle: "Tarjeta guardada correctamente", error: "")
					}
					UserDefaults.standard.setValue(value.data?.id, forKey: "default_card_id")					
				}
			}catch{
				if let strongSelf = self{
					strongSelf.showError(tittle: "Se produjo un error al guardar su tarjeta", error: error.localizedDescription)
				}
			}
		}, failure: {error in
			self.showError(tittle: "Se produjo un error al comunicarse con el servidor", error: error.localizedDescription)
		})
		//TODO: Send params to your backend to process payment
	}
	
	@IBAction func scanAction(_ sender: Any) {
		let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
		cardIOVC?.modalPresentationStyle = .formSheet
		present(cardIOVC!, animated: true, completion: nil)
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == expDate{
			if textField.text?.count == 1{
				if Int(textField.text!)! > 1{
					textField.text = ""
				}
			}
			if textField.text?.count == 2{
				if Int(textField.text!)! > 12{
					textField.text = String((textField.text?.dropLast())!)
				}
				textField.text = textField.text! + "/"
			}
		}else{
			previousTextFieldContent = textField.text;
			previousSelection = textField.selectedTextRange;
		}
		
		return true
	}
	@objc func reformatAsCardNumber(textField: UITextField) {
		var targetCursorPosition = 0
		if let startPosition = textField.selectedTextRange?.start {
			targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
		}
		
		var cardNumberWithoutSpaces = ""
		if let text = textField.text {
			cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
		}
		
		if cardNumberWithoutSpaces.count > 19 {
			textField.text = previousTextFieldContent
			textField.selectedTextRange = previousSelection
			return
		}
		
		let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
		textField.text = cardNumberWithSpaces
		
		if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
			textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
		}
	}
	func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
		var digitsOnlyString = ""
		let originalCursorPosition = cursorPosition
		
		for i in Swift.stride(from: 0, to: string.count, by: 1) {
			let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
			if characterToAdd >= "0" && characterToAdd <= "9" {
				digitsOnlyString.append(characterToAdd)
			}
			else if i < originalCursorPosition {
				cursorPosition -= 1
			}
		}
		
		return digitsOnlyString
	}
	
	func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
		// Mapping of card prefix to pattern is taken from
		// https://baymard.com/checkout-usability/credit-card-patterns
		
		// UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
		let is456 = string.hasPrefix("1")
		
		// These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
		// as 4-6-5-4 to err on the side of always letting the user type more digits.
		let is465 = [
			// Amex
			"34", "37",
			// Diners Club
			"300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
			].contains { string.hasPrefix($0) }
		
		// In all other cases, assume 4-4-4-4-3.
		// This won't always be correct; for instance, Maestro has 4-4-5 cards according
		// to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
		// know what prefixes identify particular formats.
		let is4444 = !(is456 || is465)
		
		var stringWithAddedSpaces = ""
		let cursorPositionInSpacelessString = cursorPosition
		
		for i in 0..<string.count {
			let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
			let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
			let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
			
			if needs465Spacing || needs456Spacing || needs4444Spacing {
				stringWithAddedSpaces.append(" ")
				
				if i < cursorPositionInSpacelessString {
					cursorPosition += 1
				}
			}
			
			let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
			stringWithAddedSpaces.append(characterToAdd)
		}
		
		return stringWithAddedSpaces
	}
}
