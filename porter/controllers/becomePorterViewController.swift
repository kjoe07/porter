//
//  becomePorterViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 9/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import GooglePlaces
import PopupDialog
import Alamofire
class becomePorterViewController: UIViewController,GMSAutocompleteViewControllerDelegate,datepickerDelegate, UITextFieldDelegate {
	@IBOutlet weak var nameView: UIView!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var phoneView: UIView!
	@IBOutlet weak var phone: UITextField!
	@IBOutlet weak var dateView: UIView!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var emailView: UIView!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var cityView: UIView!
	@IBOutlet weak var city: UILabel!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var check: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
		nameView.setBorder(color: darkBlue, width: 0, radius: 12)
		phoneView.setBorder(color: darkBlue, width: 0, radius: 12)
		dateView.setBorder(color: darkBlue, width: 0, radius: 12)
		emailView.setBorder(color: darkBlue, width: 0, radius: 12)
		cityView.setBorder(color: darkBlue, width: 0, radius: 12)
		sendButton.setBorder(color: darkBlue, width: 0, radius: 12)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(tapGesture)
		self.navigationController?.navigationBar.tintColor = .white
		let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.presentPicker(_:)))
		self.date.isUserInteractionEnabled = true
		self.date.addGestureRecognizer(tapGesture1)
		self.dateView.isUserInteractionEnabled = true
		self.dateView.addGestureRecognizer(tapGesture1)
		let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.presentComplete(_:)))
		self.city.isUserInteractionEnabled = true
		self.city.addGestureRecognizer(tapGesture2)
		self.cityView.isUserInteractionEnabled = true
		self.cityView.addGestureRecognizer(tapGesture2)
        city.textColor = UIColor.lightGray
        date.textColor = .lightGray
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func send(_ sender: Any) {
		if name.text != "" && phone.text != "" && phone.text!.count == 9 && email.text != "" && date.text != "" && city.text != ""{
			let params: Parameters = ["first_name": (name.text!.components(separatedBy: " ")[0]),"last_name": (name.text!.components(separatedBy: " ")[1]),"phone_number":phone.text!,"email": email.text!, "birth_date": date.text!,"city": city.text!,"has_van":(check.isOn ? "yes" : "no"),"van_type":"SMALL"]
			routeClient.instance.evaluateWorker(params: params, success: {data in
				do {
					let decoder = try JSONDecoder().decode(respuestaLogin.self, from: data)
					if decoder.success == true{
						self.showError(tittle: "Su solicitud será procesada por nuestro equipo", error: "En breves momentos nos pondremos en contacto con usted para brindarle más informacón.")
					}else{
						self.showError(tittle: "Ocurrio un error al procesar su solicitud", error: "Por intente más tarde")
					}
				}catch{
					self.showError(tittle: "Ocurrio un error al decoficar los datos", error: error.localizedDescription)
				}
			}, failure: {error in
				self.showError(tittle: "Ocurrio un error al procesar su solicitud", error: error.localizedDescription)
			})
		}
		
	}
	@IBAction func handleTap(sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		if textField == email{
			self.view.endEditing(true)
		}
	}
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		//print("Place name: \(place.name)")
		//print("Place address: \(place.formattedAddress!)")
		//print("Place attributions: \(place.attributions!)")
		city.text = place.formattedAddress
        city.textColor = .white
		dismiss(animated: true, completion: nil)
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		// TODO: handle the error.
		print("Error: ", error.localizedDescription)
	}
	
	// User canceled the operation.
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	func setDate(date: String) {
		self.date.text = date
        self.date.textColor = .white
	}
	@IBAction func presentPicker(_ sender: Any){
		let comoVC = datePickerViewController(nibName: "dailogView", bundle: nil)
		comoVC.delegate = self
		let popup = PopupDialog(viewController: comoVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
		present(popup, animated: true, completion: nil)
	}
	@IBAction func presentComplete(_ sender: Any){
		self.view.endEditing(true)
		let autocompleteController = GMSAutocompleteViewController()
		autocompleteController.delegate = self
		let filter = GMSAutocompleteFilter()
		filter.type = .city
		autocompleteController.autocompleteFilter  = filter
		present(autocompleteController, animated: true, completion: nil)
	}	
}
