//
//  menuViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 7/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI
class menuViewController: UIViewController,MFMailComposeViewControllerDelegate {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var avatar: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.nameLabel.text  = requestManager.instance.user.firstName! + " " + requestManager.instance.user.lastName!
		if let image = requestManager.instance.user.image{
			avatar.sd_setImage(with: URL(string: Router.baseURLString + image.path.replacingOccurrences(of: "images", with: "/photo")), placeholderImage: #imageLiteral(resourceName: "avatar"), options: .progressiveDownload, completed: nil)
			avatar.layer.borderWidth = 2.0
			avatar.layer.borderColor = UIColor.white.cgColor
			avatar.layer.cornerRadius = avatar.frame.width / 2
			avatar.clipsToBounds = true
		}
		reservaPorter.layer.cornerRadius = 12
		reservaPorter.clipsToBounds = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
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
	@IBAction func bePorter(_ sender: UIButton){
		
	}
	@IBOutlet weak var reservaPorter: UIButton!
	@IBAction func reservaAction(_ sender: Any) {
	}
	@IBAction func misPorterAction(_ sender: Any) {
	}
	@IBAction func profileAction(_ sender: Any) {
	}
	@IBAction func faqAction(_ sender: Any) {
//		if let url = URL(string: "https://apporter.herokuapp.com/faq-app") {
//			UIApplication.shared.open(url, options: [:])
//		}
	}
	@IBOutlet weak var contactAction: UIButton!
	@IBAction func contact(_ sender: Any) {
		let picker = MFMailComposeViewController()
		picker.mailComposeDelegate = self
		picker.setToRecipients(["support@porterapp.com"])
		picker.setSubject("Sobre App porter")
		let device = UIDevice.current.modelName
		//let device2 = self.deviceName()
		//print(device2)
		let systemVersion = UIDevice.current.systemVersion
//		let os = ProcessInfo().operatingSystemVersion
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
		//				let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
		let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "0"
//		let string = "Modelo del Dispositivo: \(device) <br> Versión de IOS: \(systemVersion) <br> Versión de la App: \(version!) <br> App build: \(build) <br> Token del usuario: \(requestManager.instance.token!)<br>"
		//picker.setMessageBody(string, isHTML: true)
		picker.setMessageBody("", isHTML: true)
		print(UIDevice.current.systemVersion)
		present(picker, animated: true, completion: nil)
	}
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: true, completion: nil)
	}
    func clearData(){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "token")
        userDefault.removeObject(forKey: "user")
        requestManager.instance.token = nil
        requestManager.instance.user = nil
    }
    func goLogin(){
        print("GOING TO REGISTER")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "registerVC")
        //loginRequest.instance.delegate = initialViewController as profileViewControlle
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.window?.rootViewController = initialViewController
        appdelegate?.window?.makeKeyAndVisible()
    }
    @IBAction func exit(_ sender: UIButton){
        let alertView = UIAlertController(title: "Cerrar sesión", message: "Estás seguro que quieres cerrar la sesión?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let action = UIAlertAction.init(title: "Aceptar", style: .default, handler: { [weak self] (data) in
            if let self = self{
                self.clearData()
                self.goLogin()
            }
        })
        alertView.addAction(cancel)
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
}
