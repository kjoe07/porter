//
//  perfilViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Gallery
import Alamofire
class perfilViewController: UIViewController,GalleryControllerDelegate {
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var lastname: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var phone: UITextField!
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var passwordButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var menu: UIBarButtonItem!
	var gallery: GalleryController!
	var imageChanged = false
	override func viewDidLoad() {
        super.viewDidLoad()
		loadProfile()
		avatar.layer.cornerRadius = 41
		name.text = requestManager.instance.user.firstName!
		lastname.text = requestManager.instance.user.lastName!
		if let email = requestManager.instance.user.email{
			self.email.text = email
		}
		//email.text = requestManager.instance.
		phone.text = requestManager.instance.user.phoneNumber!
		self.navigationController?.navigationBar.tintColor = .white
		saveButton.layer.cornerRadius = 21
		saveButton.clipsToBounds = true
		name.layer.borderColor = darkBlue.cgColor
		name.layer.borderWidth = 2.0
		lastname.layer.borderColor = darkBlue.cgColor
		lastname.layer.borderWidth = 2.0
		email.layer.borderColor = darkBlue.cgColor
		email.layer.borderWidth = 2.0
		phone.layer.borderColor = darkBlue.cgColor
		phone.layer.borderWidth = 2.0
		name.layer.cornerRadius = 12
		lastname.layer.cornerRadius = 12
		email.layer.cornerRadius = 12
		phone.layer.cornerRadius = 12
		passwordButton.layer.cornerRadius = 12
		passwordButton.layer.borderWidth = 2.0
		passwordButton.layer.borderColor = darkBlue.cgColor
        if let image = requestManager.instance.user.image{
            avatar.sd_setImage(with: URL(string: Router.baseURLString + image.path.replacingOccurrences(of: "images", with: "/photo")), placeholderImage: #imageLiteral(resourceName: "avatar"), options: .progressiveDownload, completed: nil)
            avatar.layer.borderWidth = 2.0
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.layer.cornerRadius = avatar.frame.width / 2
            avatar.clipsToBounds = true
        }else{
			//self.editButton.backgroundColor = darkBlue
		}
		Config.tabsToShow = [.imageTab, .cameraTab]
        // Do any additional setup after loading the view.
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(tapGesture)
		if revealViewController != nil {
			print("is not nil")
			menu.target = self.revealViewController()
			menu.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
			//self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
			//self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

	}
	
	@IBAction func handleTap(sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
	@IBAction func saveActin(_ sender: Any) {
		if name.text != "" && lastname.text != "" && phone.text != ""{
			let params = ["first_name": name.text!,"last_name": lastname.text!,"phone_number": phone.text!]
			routeClient.instance.setProfile(params: params, success: {[weak self]data in
				do {
					let response = try JSONDecoder().decode(profileResponse.self, from: data)
					print("==) ", response.success as Any)
					if response.success!{
						//self.performSegue(withIdentifier: "goProfile3", sender: self)
						requestManager.instance.user = response.data
						if let self = self{
							if self.imageChanged{
								self.makeImageUpload()
							}else{
								//self.performSegue(withIdentifier: "goHome", sender: self)
                                self.showError(tittle: "Datos actualizados correctamente", error: "")
							}
						}						
					}
				}catch let error as NSError{
					print(error)
				}
				}, failure: {[weak self]error in
					self?.showError(tittle: "Error al actualizar los Datos", error: error.localizedDescription)
			})
		}else{
			//self.goProfile()
		}
	}
	@IBAction func editAction(_ sender: Any) {
		gallery = GalleryController()
		gallery.delegate = self
		present(gallery, animated: true, completion: nil)
	}
	@IBAction func close(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: {})
		self.navigationController?.popViewController(animated: true)
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
                guard let self = self else {return}
				self.avatar.image = image
				self.imageChanged = true
				self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
				self.avatar.layer.borderColor = UIColor.white.cgColor
				self.avatar.layer.borderWidth = 2.0
				self.avatar.clipsToBounds = true
                self.avatar.contentMode = .scaleAspectFill
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
				self?.avatar.image = image
			}else{
				print("no image")
			}
		})
	}
	func makeImageUpload(){
		upload(image: avatar.image!,
			   progressCompletion: { percent in
		},
			   completion: { [unowned self] tags in
				//self.performSegue(withIdentifier: "goHome", sender: self)
                self.showError(tittle: "Hemos recibido sus datos", error: "Los datos del perfil han sido actulizados correctamente")
				
		})
	}
	func upload(image: UIImage,
				progressCompletion: @escaping (_ percent: Float) -> Void,
				completion: @escaping (_ tags: [String]?) -> Void) {
		// 1
		guard let imageData = UIImageJPEGRepresentation(avatar.image!, 0.5) else {
			print("Could not get JPEG representation of UIImage")
			return
		}
		let headers = ["Authorization": "Bearer \(requestManager.instance.token!)"]
		print("the headers Value \(headers)")
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
						let value = response.result.value*/else {
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
					completion( nil)
				}
			case .failure(let encodingError):
				print(encodingError)
			}
		})
	}
	
	func loadProfile(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		routeClient.instance.getProfile(success: { [weak self] data in
			do{
				let decoder = try JSONDecoder().decode(profile.self, from: data)
				if let number = decoder.user?.email{
					print("the email \(number)")
					if let self = self{
						self.email.text = number
					}
				}else{
					print("the email is not")
				}
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}catch{
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				print(error.localizedDescription)
			}
			}, failure: { error in
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				print(error.localizedDescription)
		})
	}
	
}
