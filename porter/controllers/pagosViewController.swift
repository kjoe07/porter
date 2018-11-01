//
//  pagosViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Stripe
import JGProgressHUD
import Alamofire
class pagosViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,STPPaymentCardTextFieldDelegate,CardIOPaymentViewControllerDelegate {
	@IBOutlet weak var editButton: UIButton!
	var cardArray: [card] = []
	@IBOutlet weak var tableview: UITableView!
	@IBOutlet weak var menu: UIBarButtonItem!
	var selected: Int?
	let hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Método de Pago"
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barStyle = .black
		tableview.delegate = self
		tableview.dataSource = self
		tableview.separatorStyle = .none
		editButton.setBorder(color: darkBlue, width: 0, radius: 29)
		editButton.setTitle("Añadir Tarjeta", for: .normal)
		if revealViewController != nil {
			print("is not nil")
			menu.target = self.revealViewController()
			menu.action = #selector(SWRevealViewController.revealToggle(_:))
//			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//			self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController()!.panGestureRecognizer())
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}
		self.loadCard()
		CardIOUtilities.preload()
    }
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//let vc = segue.destination as! tarjetaViewController
		//vc.delegate = self
    }

	@IBAction func close(_ sender: Any) {
		self.dismiss(animated: true, completion: {})
		self.navigationController?.popViewController(animated: true)
	}
	@IBAction func tarjeta(_ sender: Any){
		//self.performSegue(withIdentifier: "tarjeta", sender: self)
		let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
		cardIOVC?.modalPresentationStyle = .formSheet
		present(cardIOVC!, animated: true, completion: nil)
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cardArray.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cardsTableViewCell
		cell.visaView.setBorder(color: darkBlue, width: 2.0, radius: 12)
		if cardArray[indexPath.row].brand == "Visa"{
			cell.visaImagen.image = #imageLiteral(resourceName: "Visa")
		}else if cardArray[indexPath.row].brand == "MasterCard"{
			cell.visaImagen.image = #imageLiteral(resourceName: "mastercard")
		}else{
			cell.visaImagen.image = #imageLiteral(resourceName: "americanExpress")
		}
		//cell.visaImagen.setBorder(color: darkBlue, width: 2.0, radius: 12)
		cell.visaNumber.text = ".." + cardArray[indexPath.row].last4!
		cell.visaExp.text = cardArray[indexPath.row].expMonth!.description + "/" + cardArray[indexPath.row].expYear!.description
		if cardArray[indexPath.row].id == UserDefaults.standard.value(forKey: "defaulcard") as? String{
			//cell.accessoryType = .disclosureIndicator
			cell.selectButton.setImage(#imageLiteral(resourceName: "selector-1"), for: .normal)
		}
		
		return cell
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let handler: UIContextualActionHandler = { (action: UIContextualAction, view: UIView, completionHandler: ((Bool) -> Void)) in
			self.cardArray.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			completionHandler(true)
		}
		let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Eliminar", handler: handler)
		// Add more actions here if required
		let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
		configuration.performsFirstActionWithFullSwipe = true // The default value of this property is true.
		return configuration
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		UserDefaults.standard.set(self.cardArray[indexPath.row].id!, forKey: "defaulcard")
		(tableView.cellForRow(at: indexPath) as! cardsTableViewCell).selectButton.setImage(#imageLiteral(resourceName: "selector-1"), for: .normal)
		for i in 0..<cardArray.count{
			if i != indexPath.row{
				let index = IndexPath(row: i, section: 0)
				tableView.deselectRow(at: index, animated: true)
				(tableView.cellForRow(at: index) as! cardsTableViewCell).selectButton.setImage(#imageLiteral(resourceName: "base vacia"), for: .normal)
				
			}
		}
	}
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		(tableView.cellForRow(at: indexPath) as! cardsTableViewCell).selectButton.setImage(#imageLiteral(resourceName: "base vacia"), for: .normal)
	}
	func loadCard(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		routeClient.instance.indexCard(success: {[unowned self]data in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			do{
				let response = try JSONDecoder().decode(cardList.self	, from: data)
				print("response ==")
				if response.object != nil{
					self.cardArray = response.data!
					self.tableview.reloadData()
				}
			}catch{
				self.showError(tittle: "No se pudo leer el formato de las tarjetas", error: error.localizedDescription)
			}
		}, failure: {error in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			self.showError(tittle: "No se pudo actualizar las tarjetas", error: error.localizedDescription)
		})
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
			//Send to Stripe
			hud.textLabel.text = "Generando Token de la tarjeta"
			hud.show(in: self.view)
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
				print(error!.localizedDescription)
				if let strongSelf = self{
					strongSelf.showError(tittle: "Tarjeta no Válida", error: error!.localizedDescription)
					strongSelf.hud.dismiss()
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
	func deleteCard(at index:Int){
		let params = ["card_token": cardArray[index].customer!]
		routeClient.instance.deleteCard(params: params, success: { [weak self] data in
			do{
				let decoder = try JSONDecoder().decode(createCardResponse.self, from: data)
				if decoder.error != nil{
					if let strongSelf = self{
						strongSelf.showError(tittle: "Tarjeta eliminada satisfactoriamente", error: "")
					}
				}
			}catch{
				if let strongSelf = self{
					strongSelf.showError(tittle: "Se ha producido un error al procesar su solicitud", error: error.localizedDescription)
				}
			}
		}, failure: { [weak self] error in
			if let strongSelf = self{
				strongSelf.showError(tittle: "Error al porcesar la peticion", error: error.localizedDescription)
			}
		})
	}
}
