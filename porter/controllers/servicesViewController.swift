//
//  servicesViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 14/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Alamofire
import EasyTipView
import JGProgressHUD
class servicesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,EasyTipViewDelegate {
	@IBOutlet weak var phonelabe: UILabel!
	@IBOutlet weak var serviceImge: UIImageView!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var typelabel: UILabel!
	@IBOutlet weak var originLabel: UILabel!
	@IBOutlet weak var destinyLabel: UILabel!
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var normalButton: UIButton!
	@IBOutlet weak var hoursPicker: UIPickerView!
	@IBOutlet weak var expressButton: UIButton!
	@IBOutlet weak var imageWidth: NSLayoutConstraint!
	@IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var destinoLabel: UILabel!
    var servicio: service?
	var simulacion: simulation?
	var type: Int?
	var params: Parameters?
	var hours = [String]()
	var dateArray = [Date]()
	var isExpress = 0
	var pickHour = ""
	var pickDate = ""
	let hourArray = ["entre 12AM y 1AM","entre 1AM y 2AM","entre 2AM y 3AM","entre 3AM y 4AM","entre 4AM y 5AM","entre 5AM y 6AM","entre 6AM y 7AM","entre 7AM y 8AM","entre 8AM y 9AM"," entre 9AM y 10AM"," entre 10AM y 11AM","entre 11AM y 12PM","entre 12PM y 1PM","entre 1PM y 2PM","entre 2PM y 3PM","entre 3PM y 4PM","entre 4PM y 5PM","entre 5PM y 6PM","entre 6PM y 7PM","entre 7PM y 8PM","entre 8PM y 9PM","entre 9PM y 10PM","entre 10PM y 11PM","entre 11PM y 12PM"]
	var paymentArray: [card] = []
	var matrix = [[String]]()
	let formater = DateFormatter()
	var preferences = EasyTipView.Preferences()
    var id: Int?
    let hud = JGProgressHUD(style: .dark)
	override func viewDidLoad() {
        super.viewDidLoad()
        if id == nil {
            setup()
        }else{
            self.navigationItem.leftBarButtonItem = nil
            loadService(with: id!.description)
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
	override func viewDidAppear(_ animated: Bool) {
		let tipView = EasyTipView(text: "Para servicios para una hora y día definido tenemos descuento", preferences: preferences)
		tipView.tag = 100
		tipView.show(forView: self.normalButton, withinSuperview: self.view)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
			tipView.dismiss()
		}
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func easyTipViewDidDismiss(_ tipView : EasyTipView){
		
	}
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		//return hours.count
//		//if pickerView == picker{
//			return 30
//		}else{
//			let i = picker.selectedRow(inComponent: 0)
//			return matrix[i].count
//		}
		if component == 0{
			return 30
		}else{
			let i = picker.selectedRow(inComponent: 0)
			return matrix[i].count
		}
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == 0{
			if row == 0 && Calendar.current.dateComponents([.hour], from: Date()).hour! < 17{
				return "Hoy"
            }else if row == 0 && Calendar.current.dateComponents([.hour], from: Date()).hour! > 17{
                return "Mañana"
            }else if row == 1 && Calendar.current.dateComponents([.hour], from: Date()).hour! < 17{
				return "Mañana"
			}else{
				let dateFormat = DateFormatter()
				dateFormat.dateFormat = "EEE d MMM"
				dateFormat.locale = Locale(identifier: "es")
				return dateFormat.string(from: dateArray[row])
			}
		}else{
			//pickerView.
			if (pickerView.selectedRow(inComponent: 0) == 0 || pickerView.selectedRow(inComponent: 0) == -1 ) && row == 0{
                formater.dateFormat == "yyyy-MM-dd"
                let firsdate = formater.string(from: dateArray[0])
                let today = formater.string(from: Date())
                if today == firsdate {
                    return "Dentro de 2 horas"
                }else{
                    let i = picker.selectedRow(inComponent: 0)
                    return matrix[i][row]
                }
			}else{
				let i = picker.selectedRow(inComponent: 0)
				return matrix[i][row]
			}
			
//			if row == 0{
//				let time = Date()
//				let hour = Calendar.current.dateComponents([.hour], from: time)
//				print("the hour value \(hour.hour)")
//				return hourArray[hour.hour! + 2]
//			}else{
//				return hourArray[row]
//			}
			
		}
	}
//	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if component == 0{
			let dateFormat = DateFormatter()
			dateFormat.dateFormat = "yyyy-MM-dd"
            hud.textLabel.text = "Cargando horas disponibles"
            hud.show(in: self.view)
            hud.interactionType = .blockAllTouches
			loadHours(for: dateFormat.string(from: dateArray[row]))
//			self.pickDate = dateFormat.string(from: dateArray[row])
//			self.picker.reloadComponent(1)
		}else{
			let i = picker.selectedRow(inComponent: 0)
            if matrix[i].count > 0{
                self.pickHour = matrix[i][row]
            }
			//hourArray[row]
		}
	}
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		if component == 0{
			return 50
		}else{
			return 37.5
		}
	}
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		if component == 0{
			return UIScreen.main.bounds.width / 3
		}else{
			return UIScreen.main.bounds.width - UIScreen.main.bounds.width / 3
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! paymentViewController
		vc.paymentArray = self.paymentArray
		vc.params = self.params
		vc.simulacion = self.simulacion
    }

	
	@IBAction func expressAction(_ sender: UIButton) {
		if let view = view.viewWithTag(100){
			view.removeFromSuperview()
		}
		let tipView = EasyTipView(text: "Si necesitas que un porter vaya inmediatamente a hacer el porte usa este servicio", preferences: preferences)
		tipView.tag = 200
		tipView.show(forView: self.expressButton, withinSuperview: self.view)
		//EasyTipView.show(forView: self.normalButton,withinSuperview: self.view, text: "PSi necesitas que un porter vaya inmediatamente a hacer el porte usa este servicio", preferences: preferences, delegate: self)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
			tipView.dismiss()
		}
		isExpress = 1
		expressButton.setTitleColor(.white, for: .normal)
		expressButton.backgroundColor = darkBlue
		expressButton.setBorder(color: darkBlue, width: 0.0, radius: 12)
		normalButton.setTitleColor(darkBlue, for: .normal)
		normalButton.backgroundColor = .white
		normalButton.setBorder(color: gray, width: 2.0, radius: 12.0)
		self.picker.isHidden = true
		//self.hoursPicker.isHidden = true
	}	
	@IBAction func normalAction(_ sender: UIButton) {
		if let view = view.viewWithTag(200){
			view.removeFromSuperview()
		}
		let tipView = EasyTipView(text: "Para servicios para una hora y día definido tenemos descuento", preferences: preferences)
		tipView.tag = 100
		tipView.show(forView: self.normalButton, withinSuperview: self.view)
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
			tipView.dismiss()
		}
		isExpress = 0
		expressButton.setTitleColor(darkBlue, for: .normal)
		expressButton.backgroundColor = .white
		expressButton.setBorder(color: gray, width: 2.0, radius: 12.0)
		normalButton.setTitleColor(.white, for: .normal)
		normalButton.backgroundColor = darkBlue
		normalButton.setBorder(color: darkBlue, width: 0, radius: 12)
		self.picker.isHidden = false
		//self.hoursPicker.isHidden = false
	}
	@IBAction func pickerChanged(_ sender: UIDatePicker) {
		if sender == datePicker{
			let value = sender.date
			//hoursPicker.date = Calendar.current.date(byAdding: .hour, value: 1, to: value)!
			let initHour = Calendar.current.dateComponents([.hour], from: value)
			let endHour = Calendar.current.dateComponents([.hour], from: Calendar.current.date(byAdding: .hour, value: 1, to: value)!)
			self.pickHour =  initHour.hour!.description + " - " + endHour.hour!.description//.description + " - " + ().description
		}
		//UIApplication.shared.isNetworkActivityIndicatorVisible = true
//		let date = (sender as! UIDatePicker).date
//		let calendar = Calendar.current
//		let time=calendar.dateComponents([.year,.month,.day], from: date)
//		let params = ["year": time.year!,"month": time.month!,"day":time.day!]
//		routeClient.instance.avaibleHours(params: params, success: { [weak self] data in
//			do{
//				let decoder = try JSONDecoder().decode(timeResponse.self, from: data)
//				if let strongSelf = self{
//					strongSelf.hours = decoder.data!
//					strongSelf.hoursPicker.reloadAllComponents()
//				}
//			}catch{
//				print(error.localizedDescription)
//			}
//		}, failure: {error in
//				print(error.localizedDescription)
//		})
	}
	@IBAction func continueAction(_ sender: UIButton){
		//if pickHour != "" {
			//let format = DateFormat(rawValue: "yyyyMMdd")
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			//format.dateFormat = "yyyy-MM-dd"
			self.params!["is_express"] = self.isExpress
			//self.params!["pickup_date"] =  dateFormatter.string(from: picker.date )//picker.date.string(dateFormat: format!)
		if self.isExpress == 0{
			let i = picker.selectedRow(inComponent: 0)
			let j = picker.selectedRow(inComponent: 1)
			print("the selected date is \(dateFormatter.string(from: self.dateArray[i]))")
			self.params!["pickup_date"] =  dateFormatter.string(from: self.dateArray[i]) //self.pickDate
			if i == 0 {
				let hour = Calendar.current.dateComponents([.hour], from: Date())
				let hora = hour.hour! + 2
				self.params!["pickup_time"] = "\(hora + j):00:00"
			}else{
				if j > 9{
					self.params!["pickup_time"] = "\(j):00:00"
				}else{
					self.params!["pickup_time"] = "0\(j):00:00"
				}
				
				
			}
			//self.params!["pickup_time"] =  self.matrix[i][j]//self.pickHour//pickHour
			
		}else{
			self.params!["pickup_date"] = dateFormatter.string(from: Date())
			dateFormatter.dateFormat = "hh:mm:ss"
			self.params!["pickup_time"] = dateFormatter.string(from: Date())
		}
			self.performSegue(withIdentifier: "payment", sender: self)
	}
	func loadCard(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		routeClient.instance.indexCard(success: {[unowned self]data in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			do{
				let response = try JSONDecoder().decode(cardList.self	, from: data)
				print("response ==) ")
				if response.object != nil{
					self.paymentArray = response.data!
					//self.picker.reloadAllComponents()
				}
			}catch{
				self.showError(tittle: "No se pudo leer el formato de las tarjetas", error: error.localizedDescription)
			}
			}, failure: {error in
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				self.showError(tittle: "No se pudo actualizar las tarjetas", error: error.localizedDescription)
		})
	}
	func loadHours(for day: String){
		let params = ["date": day,"service_type":self.type!.description]
        hud.textLabel.text = "Cargando Horas disponibles"
        hud.show(in: self.view)
		routeClient.instance.avaibleHours(params: params, success: {[weak self] data in
			do{
				let value = try JSONDecoder().decode([String].self, from: data)
				if value.count > 0{
					if let self = self{
                        print("the day \(day) and the actual day is \(Calendar.current.dateComponents([.day], from: Date()).day!.description) y la hora es \(Calendar.current.dateComponents([.hour], from: Date()).hour!.description)")
                        var today = day.components(separatedBy: "-")
                        print("hoy \(today[2])")
                        if today[2] == Calendar.current.dateComponents([.day], from: Date()).day!.description{
                            print("is today")
                            if let index = value.firstIndex(where: {
                                $0 == Calendar.current.dateComponents([.hour], from: Date()).hour!.description + ":00"
                            }){
                                self.matrix[self.picker.selectedRow(inComponent: 0)] = Array(value[(index + 2)..<value.endIndex])
                                self.hud.dismiss()
                                self.picker.reloadComponent(1)
                            }else{
                                print("the hour is not found")
                            }
                        }else{
                            self.matrix[self.picker.selectedRow(inComponent: 0)] = value
                            self.picker.reloadComponent(1)
                            self.hud.dismiss()
                        }
					}
				}
			}catch{
				
			}
			}, failure: { error in
                self.hud.textLabel.text = "Error en al cargar datos intente mas tarde"
                self.hud.dismiss(afterDelay: 3.0, animated: true)
				print(error.localizedDescription)
		})
	}
    func setup(){
        formater.dateFormat = "yyyy-MM-dd"
        
        loadCard()
        switch type! {
        case 1:
            serviceImge.image = #imageLiteral(resourceName: "ico_driver")
            priceLabel.text = String(format: "%.2f euros", simulacion!.oneDriver!.totalCost!) //!.description + " euros"
            typelabel.text = "Solo conductor"
            imageWidth.constant = 18
        case 2:
            serviceImge.image = #imageLiteral(resourceName: "ico_porter")
            priceLabel.text = simulacion!.driverPorter!.totalCost!.description + " euros"
            typelabel.text = "Conductor / Porter"
            imageWidth.constant = 35
        case 3:
            serviceImge.image = #imageLiteral(resourceName: "ico_dosPorter")
            priceLabel.text = simulacion!.twoPorter!.totalCost!.description + " euros"
            typelabel.text = "Dos Porters"
            imageWidth.constant = 50
        default:
            break;
        }
        continueButton.setBorder(color: darkBlue, width: 0.0, radius: 12)
        expressButton.setBorder(color: gray, width: 2.0, radius: 12)
        normalButton.setBorder(color: darkBlue, width: 0.0, radius: 12)
        originLabel.text = params!["pickup_address"] as? String
        if (params!["type"] as? String) == "PER_HOURS"{
            destinyLabel.text = "Horas: " + (params!["hours"] as? Int)!.description
        }else{
            destinyLabel.text = "Destino: " + (params!["destination_address"] as! String)
        }
        phonelabe.text = requestManager.instance.user.phoneNumber!
        //picker.minimumDate = Date()
        for i in 0...30{
            if Calendar.current.dateComponents([.hour], from: Date()).hour! < 17 {
                dateArray.append(Calendar.current.date(byAdding: .day, value: i, to: Date())!)
            }else{
                dateArray.append(Calendar.current.date(byAdding: .day, value: i, to: Date().addingTimeInterval(86400))!)
            }
            matrix.append([])
            //
            //            if i == 0{
            //                let timeHour = Calendar.current.dateComponents([.hour], from: Date())
            //                var strings = [String]()
            //                strings.append("Dentro de 2 horas")
            //                for j in timeHour.hour! + 3...23{
            //                    strings.append(hourArray[j])
            //                }
            //                matrix.append(strings)
            //            }
            //            matrix.append(hourArray)
        }
        formater.dateFormat = "yyyy-MM-dd"
        print("la fecha a buscar es \( formater.string(from: dateArray[0]))")
        loadHours(for: formater.string(from: dateArray[0]))
//        if let hour = Calendar.current.dateComponents([.hour], from: Date()).hour {
//            print("hora es \(hour)")
//            if hour > 17{
//                let date = Date().addingTimeInterval(86400)
//                loadHours(for: formater.string(from: date))
//            }else{
//                print("is not order")
//                loadHours(for: formater.string(from: Date()))
//            }
//        }
        self.title = "Seleccione Día y Hora"
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = darkBlue//UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 2
        preferences.animating.dismissDuration = 1.5
        EasyTipView.globalPreferences = preferences
        if servicio?.type == "PER_HOURS"{
            destinoLabel.isHidden = true
            destinyLabel.isHidden = true
        }
    }
    func loadService(with id: String){
        hud.textLabel.text = "Cargando información"
        hud.show(in: self.view)
        hud.interactionType = .blockAllTouches
        routeClient.instance.getService(by: id.description, success: { [weak self] data in
            do{
                let decoder = try JSONDecoder().decode(service.self, from: data)
                if decoder.id != nil {
                    guard let self = self else {return}
                    self.hud.dismiss()
                    self.servicio = decoder
                    self.setup()
                }
            }catch{
                print(error.localizedDescription)
                self?.hud.dismiss()
            }
            }, failure: { [weak self]error in
                print(error.localizedDescription)
                self?.hud.dismiss()
        })
    }
}
