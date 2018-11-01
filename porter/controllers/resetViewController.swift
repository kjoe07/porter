//
//  resetViewController.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 21/8/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import PopupDialog
class resetViewController: UIViewController {
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var acceptButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	override func viewDidLayoutSubviews() {
		email.setBottomBorder()
		cancelButton.addTopBorderWithColor(color: .black, width: 1.0)
		cancelButton.addRightBorderWithColor(color: .black, width: 1.0)
		acceptButton.addTopBorderWithColor(color: .black, width: 1.0)
	}
	@IBAction func cancelAction(_ sender: UIButton){
		dismiss(animated: true, completion: nil)
	}
	@IBAction func saveAction(_ sender: UIButton){
		//TODO: - add request to reset password
		if email.text != "" && email.isValidEmail(){
			let params = ["email": email.text!]
			routeClient.instance.resetpassword(params: params, success: {data in
				if let result = try? JSONDecoder().decode(Respuesta.self, from: data){
					if result.success == true{
						let title = "Por favor revice su email"
						let message = "Se le ha enviado un email con la nueva contraseña"
						let popup = PopupDialog(title: title, message: message)
						// This button will not the dismiss the dialog
//						let buttonTwo = DefaultButton(title: "Aceptar", dismissOnTap: true) {
//							print("What a beauty!")
//						}
						self.present(popup, animated: true, completion: nil)
						self.dismiss(animated: false, completion: {
							self.dismiss(animated: true, completion: nil)
						})
					}
				}
			}, failure: { error in
				let title = "Dirección de email incorrecta"
				let message = "El email no se ha encontrado en la base de datos, por favor rectifique"
				let popup = PopupDialog(title: title, message: message)
//				let buttonTwo = DefaultButton(title: "Aceptar", dismissOnTap: true) {
//					print("What a beauty!")
//				}
				self.present(popup, animated: true, completion: nil)
				self.dismiss(animated: false, completion: {
					//self.dismiss(animated: true, completion: nil)
				})
			})
		}else{
			let title = "Dirección de email incorrecta"
			let message = "la direccion proporcionada no tiene el formato correcto, rectifique"
			let popup = PopupDialog(title: title, message: message)
//			let buttonTwo = DefaultButton(title: "Aceptar", dismissOnTap: true) {
//				print("What a beauty!")
//			}
			self.present(popup, animated: true, completion: nil)
			self.dismiss(animated: false, completion: {
				//self.dismiss(animated: true, completion: nil)
			})
		}
	}
}
