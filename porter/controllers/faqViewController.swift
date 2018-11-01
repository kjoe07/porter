//
//  faqViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 27/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import WebKit
class faqViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
	@IBOutlet weak var menu: UIBarButtonItem!
	var webView: WKWebView!
	
	override func loadView() {
		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.uiDelegate = self
		
		view = webView
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "F.A.Q"
		let myURL = URL(string:"https://apporter.herokuapp.com/faq-app")
		let myRequest = URLRequest(url: myURL!)
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		webView.load(myRequest)
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barStyle = .black
		webView.navigationDelegate = self
		if revealViewController != nil {
			print("is not nil")
			menu.target = self.revealViewController()
			menu.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}
	}

	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
		print("finished")
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//	override var preferredStatusBarStyle: UIStatusBarStyle {
//		return .lightContent
//	}
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//		let nav = self.navigationController?.navigationBar
//		nav?.barStyle = UIBarStyle.black
//		nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//		self.navigationController?.navigationBar.shadowImage = UIImage()
//		self.navigationController?.navigationBar.isTranslucent = true
//	}
}
