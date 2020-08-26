//
//  paymentViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 17/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Alamofire
import Stripe
import JGProgressHUD
class paymentViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,STPPaymentCardTextFieldDelegate,CardIOPaymentViewControllerDelegate {

	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var label: UILabel!
    @IBOutlet weak var addButton: UIButton!
	var paymentArray: [card] = []
	var params: Parameters?
	var simulacion: simulation?
	var selectedCard: String?
	let hud = JGProgressHUD(style: .dark)
	@IBOutlet weak var carImagen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
		//loadCard()
		self.title = "Seleccione Método de Pago"
		self.picker.delegate = self
		self.picker.dataSource = self
		self.continueButton.setBorder(color: darkBlue, width: 0.0, radius: 12.0)
        // Do any additional setup after loading the view.
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override func viewDidAppear(_ animated: Bool) {
//		let imagenCard = UIImageView(frame: CGRect(x: label.frame.minX, y: label.frame.maxY + 20, width: label.frame.width, height: 30))//UIImageView(image: UIImage(named: "cards"))
//		imagenCard.center.x = label.center.x
//		//imagenCard.frame.origin.y = label.frame.maxY + 50
//		self.view.addSubview(imagenCard)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if paymentArray.count == 0{
            return 0
        }else{
            return 2
        }
       // return 1
    }
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if paymentArray.count == 0{
             self.picker.isHidden = true
            return 0
        }else{
             self.picker.isHidden = false
            return paymentArray.count
        }
       // return paymentArray.count
	}
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if paymentArray.count == 0{
            return "Añadir tarjeta"
        }else{
            if component == 0{
                return paymentArray[row].brand
            }else{
                //return paymentArray[row].last4
                let string = "XXXX XXXX XXXX " + paymentArray[row].last4!
                let string2 = "\(paymentArray[row].expMonth!.description) / \(paymentArray[row].expYear!.description) "
                return  string + "\n" + string2
            }
        }
    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        //selectedCard = paymentArray[row].fingerprint
//        if paymentArray.count == 0{
//            let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
//            cardIOVC?.modalPresentationStyle = .formSheet
//            present(cardIOVC!, animated: true, completion: nil)
//        }else{
//            selectedCard = paymentArray[row].id!
//        }
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 0 {
            if paymentArray[row].brand == "Visa"{
                let imagen = UIImageView(image: UIImage(named: "visa1"))
                return imagen
            }else if paymentArray[row].brand == "mastercard1"{
                let imagen = UIImageView(image: UIImage(named: "mastercard1"))
                return imagen
            }else{
                let imagen = UIImageView(image: UIImage(named: "americanExpress1"))
                return imagen
            }
        }else{
            var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                pickerLabel?.textAlignment = .left
            }
            let string = "XXXX XXXX XXXX " + paymentArray[row].last4!
            let string2 = "\(paymentArray[row].expMonth!.description) / \(paymentArray[row].expYear!.description) "
            pickerLabel?.text =  string + "\n" + string2
            pickerLabel?.textColor = UIColor.black
            pickerLabel?.lineBreakMode = .byWordWrapping
            pickerLabel?.numberOfLines = 0

            return pickerLabel!
        }
//        let ccview = Ccview(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20 , height: 70))
//        ccview.cardNumber.text = "XXXX XXXX XXXX " + paymentArray[row].last4!
//        ccview.expDate.text = "\(paymentArray[row].expMonth!.description) / \(paymentArray[row].expYear!.description) "
//        if paymentArray[row].brand == "Visa"{
//                ccview.imagen = UIImageView(image: UIImage(named: "visa1"))
//
//            }else if paymentArray[row].brand == "mastercard1"{
//                ccview.imagen = UIImageView(image: UIImage(named: "mastercard1"))
//
//            }else{
//               ccview.imagen = UIImageView(image: UIImage(named: "americanExpress1"))
//            }
//            return ccview
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
       return 70
    }
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return UIScreen.main.bounds.width
//    }
	@IBAction func continueAction(_ sender: Any) {
		if paymentArray.count > 0 {
			if (params!["type"] as! String) == "PER_HOURS"{
				if params!["hours"] != nil {
					let hours = params!["hours"] as! Int
					params?.removeValue(forKey: "hours")
					params!["total_hours"] = hours
				}
			}else{
				if params!["calculated_time"] == nil{
					params!["calculated_time"] = simulacion!.durations!.timeInHours!
				}
				if params!["destination_address"] != nil{
					params!["destiny_address"] = params!["destination_address"]
					//params!["destination_address"] = nil
					params!.removeValue(forKey: "destination_address")
				}
			}
             hud.textLabel.text = "Guardando datos en el servidor"
            hud.detailTextLabel.text = "Espere un momento por favor"
            hud.show(in: self.view)
			self.params!["card_token"] = paymentArray[picker.selectedRow(inComponent: 1)].id!//= self.paymentArray
			//params[]
			routeClient.instance.setServices(params: self.params!, success: {[weak self] data in
				do{
					let decoder = try JSONDecoder().decode(serviceResponse.self, from: data)
					if decoder.success == true{
						if let self = self{
                            self.hud.dismiss()
							self.performSegue(withIdentifier: "finish", sender: self)
						}
					}
				}catch{
					print("error en la respuesta")
					print(error.localizedDescription)
                    self?.hud.dismiss()
				}
			}, failure: {[weak self] error in
				if let self = self{
                    self.hud.dismiss()
					self.showError(tittle: "No se pudo procesar su petición en estos momentos", error: "por favor intente más tarde")                    
				}
			})
		}else{
			showError(tittle: "Por favor ingrese una tarjeta", error: "")
		}		
	}
	func loadCard(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		routeClient.instance.indexCard(success: {[unowned self] data in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			do{
				let response = try JSONDecoder().decode(cardList.self	, from: data)
				print("response ==) ")
				if response.object != nil{
					self.paymentArray = response.data!
					self.picker.reloadAllComponents()
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
			self.continueButton.isUserInteractionEnabled = false
			hud.textLabel.text = "Generando Token de la tarjeta"
			hud.show(in: self.view)
			self.getStripeToken(card: card)
		}
	}
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
				print(error?.localizedDescription)
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
						strongSelf.continueButton.isUserInteractionEnabled = true
						strongSelf.loadCard()
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
	}
    @IBAction func add(_ sender: UIButton){
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
}
