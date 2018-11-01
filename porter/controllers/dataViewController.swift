//
//  dataViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 6/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Gallery
import Alamofire
import JGProgressHUD
class dataViewController: UIViewController,GalleryControllerDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var lastname: UITextField!
	@IBOutlet weak var phone: UITextField!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var nameView: UIView!
	@IBOutlet weak var lastnameView: UIView!
	@IBOutlet weak var phoneView:UIView!
	@IBOutlet weak var botonConstrain: NSLayoutConstraint! //topConstraint
	@IBOutlet weak var topConstraint: NSLayoutConstraint! //3
	@IBOutlet weak var ico: UIImageView!
	var gallery: GalleryController!
	var imageChanged = false
    let hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
		nameView.layer.cornerRadius = 13
		lastnameView.layer.cornerRadius = 13
		phoneView.layer.cornerRadius = 13
		nameView.clipsToBounds = true
		lastnameView.clipsToBounds = true
		phoneView.clipsToBounds = true
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		Config.tabsToShow = [.imageTab, .cameraTab]
		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		view.addGestureRecognizer(gesture)
		self.nextButton.setBorder(color: darkBlue, width: 0, radius: 12)
		let pickGesture = UITapGestureRecognizer(target: self, action: #selector(self.pickPhot(_:)))
		self.ico.addGestureRecognizer(pickGesture)
		ico.isUserInteractionEnabled = true
		name.delegate = self
		lastname.delegate = self
		phone.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.black
		nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	@IBAction func pickPhot(_ sender: UIButton) {
		gallery = GalleryController()
		gallery.delegate = self
		present(gallery, animated: true, completion: nil)
	}
	@IBAction func aceptAction(_ sender: UIButton) {
		if name.text != "" && lastname.text != "" && phone.text != "" && phone.text!.count == 9{
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
			let params = ["first_name": name.text!,"last_name": lastname.text!,"phone_number": phone.text!]
            hud.textLabel.text = "Guardando datos en el servidor."
            hud.detailTextLabel.text = "Espere un momento por favor."
            hud.show(in: self.view)
			routeClient.instance.setProfile(params: params, success: {[weak self] data in
				do {
					let response = try JSONDecoder().decode(profileResponse.self, from: data)
					print("==) ", response.success as Any)
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
					if response.success!{
						//self.performSegue(withIdentifier: "goProfile3", sender: self)
						requestManager.instance.user = response.data
						requestManager.instance.setToken()
                        
						if self!.imageChanged{
							self?.makeImageUpload()
						}else{
                            self?.hud.dismiss()
							self?.performSegue(withIdentifier: "goHome", sender: self)
						}
					}
				}catch let error as NSError{
					print(error)
				}
			}, failure: {[weak self]error in
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				if let self = self{
					self.showError(tittle: "Error al actulizar los Datos", error: error.localizedDescription)
				}
			})
		}else{
			var messaje = ""
			if name.text == ""{
				nameView.backgroundColor = .red
				messaje += "El campo nombre no puede estar vacio."
			}
			if lastname.text == ""{
				lastnameView.backgroundColor = .red
				messaje += " El Campo apellidos no puede estar vacio."
			}
			if phone.text == ""{
				phoneView.backgroundColor = .red
				messaje += " El Campo telefono no puede estar vacio."
			}else if phone.text!.count != 9{
				phoneView.backgroundColor = .red
				messaje += " El Campo telefono no es correcto."
			}
			self.showError(tittle: "Por favor no deje campos en blanco", error: messaje)
		}
	}
	@objc func keyboardWasShown(notification: NSNotification) {
		let info = notification.userInfo!
		let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		UIView.animate(withDuration: 0.1, animations: { () -> Void in
			if keyboardFrame.intersects(self.lastname.frame){
				self.botonConstrain.constant = -keyboardFrame.size.height + 64//+ 20
				self.topConstraint.constant  = -keyboardFrame.size.height
			}else if keyboardFrame.intersects(self.phone.frame){
				self.botonConstrain.constant = -keyboardFrame.size.height + 64//+ 20
				self.topConstraint.constant  = -keyboardFrame.size.height
			}
		})
	}
	@objc func keyboardWasHidden(notification: NSNotification) {
		//let info = notification.userInfo!
		UIView.animate(withDuration: 0.1, animations: { () -> Void in
			self.botonConstrain.constant = 0
			self.topConstraint.constant = 70//+= keyboardFrame.size.height
		})
	}
	func galleryControllerDidCancel(_ controller: GalleryController) {
		controller.dismiss(animated: true, completion: nil)
		gallery = nil
	}
	
	func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
		controller.dismiss(animated: true, completion: nil)
		gallery = nil
	}
	func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
		controller.dismiss(animated: true, completion: nil)
		Image.resolve(images: images, completion: { [weak self] resolvedImages in
			if let image = resolvedImages.first{
				print("there is an image in didselect")
				if let self = self{
					self.ico.image = image
					self.imageChanged = true
					self.ico.layer.cornerRadius = (self.ico.frame.width) / 2
					self.ico.layer.borderColor = UIColor.white.cgColor
					self.ico.layer.borderWidth = 2.0
					self.ico.clipsToBounds = true
				}
			}else{
				print("no image")
			}
		})
		gallery = nil
	}
	
	func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
		Image.resolve(images: images, completion: { [weak self] resolvedImages in
			if let image = resolvedImages.first{
				print("there is an image")
				self?.ico.image = image
			}else{
				print("no image")
			}			
		})
	}
	func makeImageUpload(){
        self.hud.textLabel.text = "Guardando Imagen de perfil"
		//.isHidden = true
//		progressView.progress = 0.0
//		progressView.isHidden = false
//		activityIndicatorView.startAnimating()
		upload(image: ico.image!,
			   progressCompletion: { percent in
				//self.progressView.setProgress(percent, animated: true)
			},
			   completion: { [weak self] tags in
//				self.progressView.isHidden = true
//				self.activityIndicatorView.stopAnimating()
//				self.goProfile()
				if let self = self{
                    self.hud.dismiss()
					self.performSegue(withIdentifier: "goHome", sender: self)
				}
				
		})
	}
	func upload(image: UIImage,
				progressCompletion: @escaping (_ percent: Float) -> Void,
				completion: @escaping (_ tags: [String]?) -> Void) {
		// 1
		guard let imageData = UIImageJPEGRepresentation(ico.image!, 0.5) else {
			print("Could not get JPEG representation of UIImage")
			return
		}
		let headers = ["Authorization": "Bearer \(requestManager.instance.token!)"]
		print("the headers Value \(headers)")
		// 2
		Alamofire.upload(multipartFormData: { multipartFormData in
			multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
		},to: Router.baseURLString+"/profile/updatePhoto", headers: headers, encodingCompletion: { encodingResult in
			
			switch encodingResult {
			case .success(let upload, _, _):
				upload.uploadProgress { progress in
					progressCompletion(Float(progress.fractionCompleted))
				}
				upload.validate()
				upload.responseJSON { response in
					print("the upload response is \(response)")
					guard response.result.isSuccess/*,
						let value = response.result.value*/ else {
							print("Error while uploading file: \(String(describing: response.result.error))")
							completion(nil)
							return
					}
					print("response to upload \(String(describing: response.data))")
					do {
						let data = try JSONDecoder().decode(profileResponse.self, from: response.data!)
						print("==) ", data.success as Any)
						if data.success!{
							print(data)
							//self.performSegue(withIdentifier: "goProfile3", sender: self)
							requestManager.instance.user = data.data
							requestManager.instance.setToken()
							//self.makeImageUpload()
						}
					}catch let error as NSError{
						print(error)
					}
					// 2
					//let firstFileID = JSON(value)["data"]["image"]["id"].stringValue
					//print("Content uploaded with ID: \(firstFileID)")
					//3
					completion( nil)
				}
			case .failure(let encodingError):
				print(encodingError)
			}
			
		})
		
	}
	@objc func handleTap(_ sender: Any){
		view.endEditing(true)
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == name{
			name.resignFirstResponder()
			lastname.becomeFirstResponder()
			if textField.text != ""{
				nameView.backgroundColor = textFieldBlue
			}
		}else if textField == lastname{
			lastname.resignFirstResponder()
			phone.becomeFirstResponder()
			if textField.text != ""{
				lastnameView.backgroundColor = textFieldBlue
			}
		}else{
			phone.resignFirstResponder()
			view.endEditing(true)
			if textField.text != ""{
				phoneView.backgroundColor = textFieldBlue
			}
		}
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField == name{
			if textField.text!.count < 2{
				nameView.backgroundColor = .red
			}else{
				nameView.backgroundColor = textFieldBlue
			}
		}else if textField == lastname{
			if textField.text!.count < 2{
				lastnameView.backgroundColor = .red
			}else{
				lastnameView.backgroundColor = textFieldBlue
			}
		}else{
			if textField.text!.count < 8{
				phoneView.backgroundColor = .red
			}else{
				phoneView.backgroundColor = textFieldBlue
			}
		}
		return true
	}
}
