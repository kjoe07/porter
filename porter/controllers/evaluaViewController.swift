//
//  evaluaViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 9/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Alamofire
class evaluaViewController: UIViewController {
	@IBOutlet weak var descriptionText: UITextView!
	@IBOutlet weak var sendButton: UIButton!
	var rapidity: Int!
	var sympathy: Int!
	var cleaning: Int!
	var id: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
		descriptionText.setBorder(color: UIColor(white: 0, alpha: 0.18), width: 2, radius: 12)
		sendButton.setBorder(color: darkBlue, width: 0, radius: 21)
		rapidity = 0
		sympathy = 0
		cleaning = 0
		descriptionText.autocapitalizationType = .sentences
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
	@IBAction func rapidez(_ sender: UISlider) {
		rapidity = Int(sender.value)
	}
	@IBAction func simpatia(_ sender: UISlider) {
		sympathy = Int(sender.value)
	}
	@IBAction func limpieza(_ sender: UISlider) {
		cleaning = Int(sender.value)
	}
	@IBAction func sendAction(_ sender: Any) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let params: Parameters = ["comment": descriptionText.text,"rapidity":rapidity,"sympathy":sympathy,"cleaning":cleaning,"service_id":id]
		routeClient.instance.evaluateWorker(params: params, success: { [weak self] data in
			
			do{
				let decoder = try JSONDecoder().decode(reviewResponse.self, from: data)
				if decoder.success!{
					UserDefaults.standard.removeObject(forKey: "finalized")
					self?.performSegue(withIdentifier: "goHome", sender: self)
				}
			}catch{
				print(error.localizedDescription)
			}
			}, failure: { error in
				print(error.localizedDescription)
		})
	}
	
	
}
