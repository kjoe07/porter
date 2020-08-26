//
//  registerViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 6/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import ImageSlideshow
import PopupDialog
import FacebookLogin
import Fabric
import Crashlytics
import JGProgressHUD
class registerViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var terminos: UILabel!
	@IBOutlet weak var forgotButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var mainButton: UIButton!
	@IBOutlet weak var passwordText: UITextField!
	@IBOutlet weak var indicator: NSLayoutConstraint!
	@IBOutlet weak var emailtext: UITextField!
	@IBOutlet weak var facebookButton: UIButton!
	@IBOutlet weak var tutorial: ImageSlideshow!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var omitir: UIButton!
	@IBOutlet weak var aceptarBUtton: UIButton!
	@IBOutlet weak var emailView:UIView!
	@IBOutlet weak var passwordView: UIView!
     let hud = JGProgressHUD(style: .dark)
	override func viewDidLoad() {
        super.viewDidLoad()
//		if UserDefaults.standard.integer(forKey: "tuto") < 2{
//			//backButton.isHidden = true
//			//nextButton.isHidden = false
////			let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
////			tutorial.addGestureRecognizer(gesture)
//			tutorial.backgroundColor = .clear
//			tutorial.pageIndicatorPosition = PageIndicatorPosition.init(horizontal: .center, vertical: .customBottom(padding: 120.0))
//			tutorial.contentScaleMode = UIViewContentMode.scaleAspectFit
//			tutorial.activityIndicator = DefaultActivityIndicator()
//			self.omitir.layer.borderWidth = 1.0
//			self.omitir.layer.borderColor = UIColor.white.cgColor
//			self.omitir.layer.cornerRadius = 5.0
//			self.omitir.clipsToBounds = true
//			self.omitir.isHidden = true
//			self.aceptarBUtton.layer.cornerRadius = 15
//			self.aceptarBUtton.clipsToBounds = true
//			tutorial.setImageInputs([
//				ImageSource(image: #imageLiteral(resourceName: "slide1")),
//				ImageSource(image: #imageLiteral(resourceName: "slide2")),
//				ImageSource(image: #imageLiteral(resourceName: "slide3"))
//				])
//			tutorial.currentPageChanged = { page in
//				switch page{
//				case 0:
//					self.backButton.isHidden = true
//					self.omitir.isHidden = false
//					self.aceptarBUtton.isHidden = true
//					self.nextButton.isHidden = false
//				case 1:
//					self.omitir.isHidden = false
//					self.backButton.isHidden = false
//					self.aceptarBUtton.isHidden = true
//					self.nextButton.isHidden = false
//				case 2:
//					self.omitir.isHidden = true
//					self.nextButton.isHidden = true
//					self.aceptarBUtton.isHidden = false
//				default:
//					break
//				}
//			}
//
//			tutorial.circular = false
//			UIView.animate(withDuration: 0.5, animations: {
//				self.tutorial.isHidden = false
//				self.tutorial.alpha = 1.0
//			})
//		}else{
//			self.tutorial.isHidden = true
//		}
		self.mainButton.layer.cornerRadius = 13
		self.mainButton.clipsToBounds = true
		facebookButton.layer.cornerRadius = 13
		facebookButton.clipsToBounds = true
		emailView.layer.cornerRadius = 13
		passwordView.layer.cornerRadius = 13
		emailView.clipsToBounds = true
		passwordView.clipsToBounds = true
		emailtext.delegate = self
		passwordText.delegate = self
//		let formattedString = NSMutableAttributedString()
//		formattedString.normal("Al entrar aceptas ").bold("Términos y Condiciones de Uso")
//		terminos.text = ""
//		terminos.attributedText = formattedString
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
		self.navigationController?.navigationBar.isTranslucent = true/**/
		
		//self.navigationController?.setNavigationBarHidden(true, animated: animated)
		//		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	@IBAction func facebookLogin(_ sender: Any) {
		let loginManager = LoginManager()
		loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self, completion: { [weak self] (loginResult) in
			switch loginResult {
			case .failed(let error):
				print(error)
			case .cancelled:
				print("User cancelled login.")
			case .success(_ , _, let accessToken): //let grantedPermissions,let declinedPermissions
				if accessToken.authenticationToken != ""{
					let params = ["provider": "facebook","token": accessToken.authenticationToken ]
                    if let self = self {
                        self.hud.textLabel.text = "Registrando usuario con datos de Facebook"
                        self.hud.detailTextLabel.text = "Espere un momento por favor."
                        self.hud.show(in: self.view)
                    }
					routeClient.instance.login(provider: params, success: { data in
						do {
							let response = try JSONDecoder().decode(respuestaLogin.self, from: data)
							print("==) ", response.profile as Any, response.token as Any)
							if let self = self {
								if let token = response.token{
									requestManager.instance.token = token
									if let user = response.profile{
										print("setting the user to singleton")
										requestManager.instance.user = user
										requestManager.instance.setToken()
									}else{
										print("error en el user")
									}
									//self.setToken()
									if requestManager.instance.user.phoneNumber == nil {
                                        self.hud.dismiss()
										self.performSegue(withIdentifier: "goData", sender: self)
									}else{
                                        self.hud.dismiss()
										self.performSegue(withIdentifier: "loginSegue", sender: self)
									}
								}else{
                                    self.hud.dismiss()
									self.showError(tittle: "Error en la Autetificacion", error: response.error.debugDescription + response.code!)
								}
							}
						}catch let error as NSError{
							print(error)
                            guard let self = self else {return}
                            self.hud.dismiss()
						}
					}, failure: {error in
                        guard let self = self else {return}
                        self.hud.dismiss()
					})
				}
			}
		})
	}
	@IBAction func forgotAction(_ sender: UIButton) {
		self.view.endEditing(true)
		let comoVC = resetViewController(nibName: "reset", bundle: nil)
		let popup = PopupDialog(viewController: comoVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
		present(popup, animated: true, completion: nil)
	}
	
	@IBAction func registerAction(_ sender: Any) {
		changeTab(temp: true)
	}
	@IBAction func mainAction(_ sender: UIButton) {
		if emailtext.isValidEmail() && passwordText.text!.count >= 6 {
			let params = ["email" : emailtext.text!,"password" : passwordText.text!]
			if !accountButton.isHidden{
                hud.textLabel.text = "Verificando usuario y contraseña."
                hud.detailTextLabel.text = "Espere un momento por favor."
                hud.show(in: self.view)
				routeClient.instance.login(params: params, success: {[weak self] data in
					do {
						let response = try JSONDecoder().decode(respuestaLogin.self, from: data)
						print("==) ", response.profile as Any, response.token as Any)
						if let token = response.token{
							requestManager.instance.token = token
							if let user = response.profile{
								requestManager.instance.user = user
								requestManager.instance.setToken()
								if let self = self {
                                    self.hud.dismiss()
									if requestManager.instance.user.iscomplete(){
										self.performSegue(withIdentifier: "loginSegue", sender: self)
									}else{
										self.performSegue(withIdentifier: "goData", sender: self)
									}
								}
								print("profile = \(user)")
							}else{
								print("error en el user")
							}							
						}else{
							if let self = self{
                                self.hud.dismiss()
								self.emailtext.layer.shake(duration: 0.7)
								self.passwordText.layer.shake(duration: 0.7)
								Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) {_ in
									self.showError(tittle: "Error en la Autetificacion", error: "Credenciales invalidas")
								}
							}
						}
					}catch let error as NSError{
						print(error)
					}
				}, failure: { error in
					print(error)
				})
			}else{
				print("is register")
                hud.textLabel.text = "Registrando usuario"
                hud.detailTextLabel.text = "Espere un momento por favor."
                hud.show(in: self.view)
				routeClient.instance.register(params: params, success: { [weak self] data in
					do {
						let response = try JSONDecoder().decode(respuestaLogin.self, from: data)
						print("==) ", response.profile?.id as Any, response.token as Any)
						if let token = response.token{
							print("token value \(token)")
							print("profile value after request \(String(describing: response.profile))")
							requestManager.instance.token = token
							requestManager.instance.user = response.profile
							print("profile value after asing to singleton \(requestManager.instance.user.debugDescription)")
							requestManager.instance.setToken()
							if let self = self{
                                self.hud.dismiss()
								self.performSegue(withIdentifier: "goData", sender: self)
							}
							
						}else{
							if let self = self{
                                self.hud.dismiss()
								self.emailtext.layer.shake(duration: 0.7)
								self.passwordText.layer.shake(duration: 0.7)
								Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) {_ in
									self.showError(tittle: "Error al crear el usuario:", error: "El usuario ya existe, si olvidó su contraseña haga clic en olvidé mi contraseña.")
								}
							}
						}
					}catch let error as NSError{
						print(error)
					}
				}, failure: { error in
					print(error)
				})
			}
		}else{
			//Crashlytics.sharedInstance().crash()
			self.showError(tittle: "No se puede dejar campos vacíos", error: "por favor introduzca una dirección de correo y una contraseña")
		}
	}
	@IBAction func goRegister(_ sender: UIButton){
		changeTab(temp: true)
	}
	@IBAction func goLogin(_ sender: UIButton){
		changeTab(temp: false)
	}
	func changeTab(temp: Bool){
		if !temp{
			mainButton.setTitle("Acceder", for: .normal)
			facebookButton.isHidden = false
			forgotButton.isHidden = false
			accountButton.isHidden = false
			terminos.isHidden = true
			indicator.constant = 0
			self.view.endEditing(true)
		}else{
			mainButton.setTitle("Siguiente", for: .normal)
			facebookButton.isHidden = true
			forgotButton.isHidden = true
			accountButton.isHidden = true
			indicator.constant = UIScreen.main.bounds.width / 2
			terminos.isHidden = false
			self.view.endEditing(true)
		}
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == emailtext{
			emailtext.resignFirstResponder()
			passwordText.becomeFirstResponder()
		}else{
			passwordText.resignFirstResponder()
			if passwordText.text == ""{
				passwordView.backgroundColor = UIColor(red: 17/255, green: 62/255, blue: 127/255, alpha: 1.0)
			}
		}
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField ==  passwordText{
			if textField.text!.count < 6 && accountButton.isHidden == true{
				//passwordText.layer.borderColor = UIColor.red.cgColor
				//passwordText.layer.borderWidth = 2.0
				passwordView.backgroundColor = .red
			}else{
				passwordView.backgroundColor = UIColor(red: 17/255, green: 62/255, blue: 127/255, alpha: 1.0)
				//				textField.backgroundColor = .white
				//passwordText.layer.borderWidth = 0.0
			}
			if textField.text == ""{
				passwordView.backgroundColor = UIColor(red: 17/255, green: 62/255, blue: 127/255, alpha: 1.0)
			}
		}
		return true
	}
	@objc func handleTap(){
		print("la pagina actual es \(tutorial.currentPage)")
		if tutorial.currentPage == 2{
			
		}
	}
	@IBAction func back(sender: Any){
		change(value: tutorial.currentPage - 1)
	}
	@IBAction func next(sender: Any){
		change(value: tutorial.currentPage + 1)
	}
	func change(value: Int){
		tutorial.setCurrentPage(value, animated: true)
	}
	@IBAction func aceptAction(_ sender: UIButton){
		showResgister()
	}
	@IBAction func omitirAction(){
		showResgister()
	}
	func showResgister(){
		UIView.animate(withDuration: 0.5, animations: {
			self.tutorial.alpha = 0
			self.tutorial.isHidden = true
			UserDefaults.standard.set(2, forKey: "tuto")
			self.nextButton.isHidden = true
			self.backButton.isHidden = true
			self.aceptarBUtton.isHidden = true
			self.omitir.isHidden = true
		})
	}
}
