//
//  viewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 6/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import PopupDialog
extension UIViewController{
	func showError(tittle: String,error: String){
		let title = tittle
		//let message = error
		// Create the dialog
		let popup = PopupDialog(title: title, message: error, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 250.0, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)//PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true) {
			print("Completed")
		//}
		let buttonTwo = DefaultButton(title: "Aceptar") {
			//self.label.text = "You ok'd the default dialog"
			
		}
		// Add buttons to dialog
		popup.addButtons([buttonTwo])
		// Present dialog
		self.present(popup, animated: true, completion: nil)
	}
}

