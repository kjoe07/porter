//
//  simulacionViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 9/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class simulacionViewController: UIViewController {
	@IBOutlet weak var precio: UILabel!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var yelloNote: UIView!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var timeLabel: UILabel!
	var simulacion: simulation?
	var servicio: Int?
	var price: Float?
    override func viewDidLoad() {
        super.viewDidLoad()
		closeButton.setBorder(color: darkBlue, width: 0, radius: 21)
		let formatter = NumberFormatter()
		formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
		formatter.numberStyle = .currency
		slider.minimumValue = 0.0
		if servicio == 1 {
			price = (simulacion!.oneDriver!.price! as NSString).floatValue
			if let formattedTipAmount = formatter.string(from: simulacion!.oneDriver!.totalCost! as NSNumber) {
				self.precio.text = formattedTipAmount
			}
		}else if servicio == 2{
			price = (simulacion!.driverPorter!.price! as NSString).floatValue
			//self.precio.text = !.description
			if let formattedTipAmount = formatter.string(from: simulacion!.driverPorter!.totalCost! as NSNumber) {
				self.precio.text = formattedTipAmount
			}
		}else{
			price = (simulacion!.twoPorter!.price! as NSString).floatValue
			//self.precio.text = .description
			if let formattedTipAmount = formatter.string(from: simulacion!.twoPorter!.totalCost! as NSNumber) {
				self.precio.text = formattedTipAmount
			}
		}
		
		if simulacion!.service == "PER_HOURS"{
			slider.maximumValue = 8
			slider.value = Float(Int((simulacion?.durations!.timeInHours!)!)!)
			slider.minimumValue = 0
			self.timeLabel.text = simulacion!.durations!.timeInHours!.description + ( Int(simulacion!.durations!.timeInHours!)! > 1 ? " horas" : " hora")
			//slider.setThumbImage(#imageLiteral(resourceName: "circulo"), for: .normal)
		}else{
			timeLabel.text = simulacion!.durations!.text
		}
		slider.setThumbImage(#imageLiteral(resourceName: "circulo"), for: .normal)
        self.navigationController?.navigationBar.tintColor = .white
		self.title = "Simulación"
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
	@IBAction func closeButtonAction(_ sender: Any) {
		//dismiss(animated: true, completion: nil)
		self.navigationController?.popViewController(animated: true)
	}
	@IBAction func valueChanged(_ sender: UISlider){
		sender.value = roundf(sender.value)
		let formatter = NumberFormatter()
		formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
		formatter.numberStyle = .currency
		if let formattedTipAmount = formatter.string(from: sender.value * price! as NSNumber) {
			self.precio.text = formattedTipAmount
		}
		//self.precio.text = (sender.value * price!).description
//		let trackRect = sender.trackRect(forBounds: sender.frame)
//		let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
		//self.timeLabel.center = CGPoint(x: thumbRect.midX, y: sender.frame.minY - 10)
		if simulacion!.service == "PER_HOURS"{
			self.timeLabel.text = String(format: "%.0f h", sender.value) //+ " h" // ( (Double(simulacion!.durations!.timeInHours!)!) > 1.0 ? " horas" : " hora")
		}else{
			self.timeLabel.text = String(format: "%.0f m", sender.value)// + " m" //( (Double(simulacion!.durations!.timeInHours!)!) > 1.0 ? " m" : " Minuto")
		}
		
	}
	
}
