//
//  changePasswordViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Alamofire
class changePasswordViewController: UIViewController {

	@IBOutlet weak var old: UITextField!
	@IBOutlet weak var new: UITextField!
	@IBOutlet weak var confirm: UITextField!
	@IBOutlet weak var save: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		old.setBorder(color: darkBlue, width: 2.0, radius: 12.0)
		new.setBorder(color: darkBlue, width: 2.0, radius: 12.0)
		confirm.setBorder(color: darkBlue, width: 2.0, radius: 12.0)
		save.layer.cornerRadius = 21
		self.title = "Cambio de contraseña"
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
	
	@IBAction func handleTap(sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
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
	@IBAction func saveAction(_ sender: Any) {
		if confirm.text == new.text && confirm.text!.count > 6{
			let params = ["current_password": old.text!,"password": new.text!,"password_confirmation": confirm.text!]
			self.changePass(params: params)
		}else if confirm.text != new.text{
			showError(tittle: "las Contraseñas no coincidentes", error: "Por favor rectifique")
		}else{
			showError(tittle: "La nueva contraseña no cumple los requisitos", error: "la contraseña especificada debe tener al menos 6 carácteres")
		}
	}
	func changePass(params: Parameters){
		routeClient.instance.changePassword(params: params, success: {[weak self] data in
			do{
				let response = try JSONDecoder().decode(respuestaLogin.self, from: data)
				print("response ==) ", response.success)
				if response.success{
					if let self = self{
						self.showError(tittle: "Contraseña Cambiada Correctamente", error: "")
						self.old.text = ""
						self.confirm.text = ""
						self.new.text = ""
					}
				}
			}catch{
				print(error.localizedDescription)
			}
		}, failure: {error in
			print("errorn en la peticion \(error.localizedDescription)")
		})
	}
	
	
}
