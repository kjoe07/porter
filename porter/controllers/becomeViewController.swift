//
//  becomeViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 9/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class becomeViewController: UIViewController {
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
		sendButton.setBorder(color: .white, width: 0.0, radius: 12)
        // Do any additional setup after loading the view.
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
//		if revealViewController != nil {
//			print("is not nil")
//			menu.target = self.revealViewController()
//			menu.action = #selector(SWRevealViewController.revealToggle(_:))
//			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//			self.navigationController?.navigationBar.addGestureRecognizer(revealViewController()!.panGestureRecognizer())
//		}
		if revealViewController != nil {
			print("is not nil")
			menu.target = self.revealViewController()
			menu.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}
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
	@IBAction func close(_ sender: Any){
		self.dismiss(animated: true, completion: {})
		self.navigationController?.popViewController(animated: true)
		
	}

}
