//
//  datePickerViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 9/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class datePickerViewController: UIViewController {
	@IBOutlet weak var cancelButton:UIButton!
	@IBOutlet weak var setButton: UIButton!
	@IBOutlet weak var picker: UIDatePicker!
	var date: String!
	var delegate: datepickerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
		picker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
		picker.date = Date()
		picker.maximumDate = Date()
		setDateString(date: Date())
		//setButton.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .touchUpInside)
		//setButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
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
	@IBAction func handleDatePicker(sender: UIDatePicker) {
		setDateString(date: sender.date)
		//textfieldjobdate.text = dateFormatter.string(from: sender.date)
	}
	@objc func setDate(){
		delegate.setDate(date: date)
	}
	@IBAction func setAction(_ sender: Any) {
		if date != nil {
			print("delagdo \(delegate.debugDescription)")
			delegate.setDate(date: date!)
			//dismissDelagete.dismiss(animated: true)
			dismiss(animated: true, completion: nil)
		}
	}
	@IBAction func cancelAction(_ sender: Any){
		dismiss(animated: true, completion: nil)//dismissDelagete.dismiss(animated: true)
	}
	func setDateString(date: Date){
		print("set date value as picker changed")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-YYYY"
		//delegate.setDate(date: dateFormatter.string(from: sender.date))
		self.date = dateFormatter.string(from: date)
		//delegate.setDate(date: self.date)
		print("date value \(date)")
	}

}
