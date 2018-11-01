//
//  pricesViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 10/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Alamofire
class pricesViewController: UIViewController {
	@IBOutlet weak var onlyDriverPrice: UILabel!
	@IBOutlet weak var porterPrice: UILabel!
	@IBOutlet weak var dualPorterPrice: UILabel!
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var driverView: UIView!
	@IBOutlet weak var dualporterView: UIView!
	@IBOutlet weak var porterView: UIView!
	@IBOutlet weak var time1: UILabel!
	@IBOutlet weak var time2: UILabel!
	@IBOutlet weak var time3: UILabel!
	//var servicio: service?
	@IBOutlet var time: [UILabel]!
	var simulacion: simulation?
	var type = 1
	var params: Parameters?
    override func viewDidLoad() {
        super.viewDidLoad()
		onlyDriverPrice.text = String(format: "%.2f euros", simulacion!.oneDriver!.totalCost!)//.price! + " Euros"
		porterPrice.text = String(format: "%.2f euros", simulacion!.driverPorter!.totalCost!) //+ " Euros"
		dualPorterPrice.text = String(format: "%.2f euros", simulacion!.twoPorter!.totalCost!)//+ " Euros"
		continueButton.setBorder(color: darkBlue, width: 0, radius: 12)
		self.navigationController?.navigationBar.tintColor = .white
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
		if simulacion!.service == "PER_HOURS"{
			time1.text = simulacion!.durations!.timeInHours!.description + "'"
			time2.text = simulacion!.durations!.timeInHours!.description + "'"
			time3.text = simulacion!.durations!.timeInHours!.description + "'"
		}else{
			time1.text = simulacion!.durations!.text!.description
			time2.text = simulacion!.durations!.text!.description
			time3.text = simulacion!.durations!.text!.description
		}
		self.title = "Precios"
		params!["driver_type_id"] = 1
        driverView.setBorder(color: darkBlue, width: 1.0, radius: 12.0)
        porterView.setBorder(color: darkBlue, width: 1.0, radius: 12.0)
        dualporterView.setBorder(color: darkBlue, width: 1.0, radius: 12.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "showSimulation"{
			let vc = segue.destination as! simulacionViewController
			vc.servicio = type
			vc.simulacion = self.simulacion
		}else{
			let vc = segue.destination as! servicesViewController
			vc.type = type
			vc.simulacion = self.simulacion
			vc.params = self.params
		}
		
    }
	
	@IBAction func driverSelected(_ sender: Any) {
		if porterswitch.isOn{
			type = 1
			dualporterswitch.setOn(!driverswitch.isOn, animated: true)
			porterswitch.setOn(!driverswitch.isOn, animated: true)
			params!["driver_type_id"] = 1
		}else{
			driverswitch.setOn(true, animated: true)
		}
	}
	@IBOutlet weak var porterswitch: UISwitch!
	@IBOutlet weak var dualporterswitch: UISwitch!
	@IBOutlet weak var driverswitch: UISwitch!
	@IBAction func porterSelected(_ sender: UISwitch) {
		if sender.isOn{
			type = 2
			dualporterswitch.setOn(!sender.isOn, animated: true)
			driverswitch.setOn(!sender.isOn, animated: true)
			params!["driver_type_id"] = 2
		}else{
			sender.setOn(true, animated: true)
		}
	}
	@IBAction func dualPortedSelected(_ sender: Any) {
		if dualporterswitch.isOn{
			type = 3
			porterswitch.setOn(!dualporterswitch.isOn, animated: true)
			driverswitch.setOn(!dualporterswitch.isOn, animated: true)
			params!["driver_type_id"] = 3
		}else{
			dualporterswitch.setOn(true, animated: true)
		}		
	}
	@IBAction func showSimulation(_ sender: Any){
		if driverswitch.isOn || porterswitch.isOn || dualporterswitch.isOn{
			performSegue(withIdentifier: "showSimulation", sender: self)
		}
	}
	@IBAction func goServiceType(){
		self.performSegue(withIdentifier: "date", sender: self)
	}
}
