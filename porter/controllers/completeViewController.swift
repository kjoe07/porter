//
//  completeViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 19/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class completeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		completeButton.setBorder(color: darkBlue, width: 0.0, radius: 12)
		//self.title = "Método de Pago"
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barStyle = .black
        // Do any additional setup after loading the view.
		self.navigationController?.navigationBar.isHidden = true
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
	
	@IBOutlet weak var completeButton: UIButton!
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	@IBAction func closeAction(_ sender: Any) {
//		self.dismiss(animated: false, completion: {
		//self.dismiss(animated: false, completion: {})
			//self.navigationController!.popToRootViewController(animated: true)
		performSegue(withIdentifier: "goHome", sender: self)
//		})
//		let navigationController = self.presentingViewController as? UINavigationController
//
//		self.dismiss(animated: true) {
//			let _ = navigationController?.popToRootViewController(animated: true)
//		}
	}
	
}
