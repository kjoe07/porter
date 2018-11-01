//
//  porterDetailViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 27/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Messages
import MessageUI
class porterDetailViewController: UIViewController,MFMessageComposeViewControllerDelegate {
	@IBOutlet weak var serviceTypeLabel: UILabel!
	@IBOutlet weak var serviceTypeImage: UIImageView!
	@IBOutlet weak var trayectolabel: UILabel!
	@IBOutlet weak var trayectoTimeLabel: UILabel!
	@IBOutlet weak var cargaDescargaTIme: UILabel!
	@IBOutlet weak var descargaTime: UILabel!
	@IBOutlet weak var descargaVIew: UIView!
	@IBOutlet weak var precioLabel: UILabel!
	@IBOutlet weak var aumenteRazonLabel: UILabel!
	@IBOutlet weak var timerVIew: UIView!
	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var estado: UILabel!
	@IBOutlet weak var origenLabel: UILabel!
	@IBOutlet weak var destinoLabel: UILabel!
	@IBOutlet weak var hastaLabel: UILabel!
	@IBOutlet weak var fechaLabel: UILabel!
	@IBOutlet weak var porterNameLabel: UILabel!
	@IBOutlet weak var porterPhoneNUmber: UILabel!
	@IBOutlet weak var sendSmsButton: UIButton!
	@IBOutlet weak var seeMapButton: UIButton!
	@IBOutlet weak var labelHeght: NSLayoutConstraint!
    @IBOutlet weak var cargaDescargaInfolabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var pendanteSeparator: NSLayoutConstraint!
    @IBOutlet weak var completedConstrain: NSLayoutConstraint!
    var servicio: service?
	var timer = Timer()
	var seconds = 60
    var id: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Servicio"
		if let servicio = servicio{
			setup(with: servicio)
            print("el servicio al cargar el detalle \(servicio)")
        }else{
            if let id = id{
                loadService(with: id)
                self.navigationItem.leftBarButtonItem = nil
                let revealViewController = self.revealViewController()
                revealViewController?.rearViewRevealWidth = ((UIScreen.main.bounds.width * 74.6875) / 100)
                if revealViewController != nil{
                    let button1 = UIBarButtonItem(image: UIImage(named: "ico_menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))) // action:#selector(Class.MethodName) for swift 3
                    self.navigationItem.leftBarButtonItem  = button1
                    self.navigationItem.leftBarButtonItem?.tintColor = .white
                }
            }
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
	override func viewDidDisappear(_ animated: Bool) {
		timer.invalidate()
	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goMap"{
			let vc = (segue.destination as! UINavigationController).topViewController! as! mapViewController
			//		vc.id = servicio?.id?.description
			vc.servicio = servicio
		}
    }
	

	@IBAction func sendSmsAction(_ sender: Any) {
//		if (MFMessageComposeViewController.canSendText()) {
//			let controller = MFMessageComposeViewController()
//			//controller.body = "Message Body"
//			controller.recipients = [porterPhoneNUmber.text!]
//			controller.messageComposeDelegate = self
//			self.present(controller, animated: true, completion: nil)
//		}
	}
	@IBAction func callAction(_ sender: Any) {
		if let url = URL(string: "tel://\(porterPhoneNUmber.text!)"), UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		}
	}
	@IBAction func goMap(_ sender: Any) {
		self.performSegue(withIdentifier: "goMap", sender: self)
	}
	func setup(with service: service){
        if let driver = service.driver?.id{
            loadDriver(with: driver)
        }
        cargaDescargaTIme.text = String(format: "%.2f min (Tiempo estimado)", service.timeLoadUnload!)
        if service.state == "DRAFT"{
            descargaVIew.isHidden = true
            sendSmsButton.isHidden = false
            aumenteRazonLabel.isHidden = true
            timerVIew.isHidden = true
            labelHeght.constant = 0
        }else if service.state == "APPROVED"{
            descargaVIew.isHidden = true
            sendSmsButton.isHidden = true
            aumenteRazonLabel.isHidden = true
            timerVIew.isHidden = true
            labelHeght.constant = 0
        }else if service.state == "FINISHED"{
            descargaVIew.isHidden = false
            sendSmsButton.isHidden = true
            seeMapButton.isHidden = true
            //aumenteRazonLabel.isHidden = false
            timerVIew.isHidden = true
        }else if service.state == "CHARGE"{
            descargaVIew.isHidden = false
            sendSmsButton.isHidden = true
            seeMapButton.isHidden = true
            if (service.timeLoad! + service.timeUnload!) > 10{
                aumenteRazonLabel.isHidden = false
            }else{
                labelHeght.constant = 0
            }
            timerVIew.isHidden = true
            phoneButton.isHidden = true
            cargaDescargaInfolabel.text = "Carga:"
            if let time = service.timeUnload {
                print("unload time \(time)")
                //descargaTime.text = String(format: "%.2f Min (Tiempo Real)", time)
                print("the text to label is", String(format: "%.2f min (Tiempo Real)", service.timeUnload!),"\(descargaTime.isHidden)")
                descargaTime.text = String(format: "%.2f min (Tiempo Real)", service.timeUnload!)
                descargaTime.isHidden = false
                cargaDescargaTIme.text = String(format: "%.2f min (Tiempo Real)", service.timeLoad!)
            }else{
                print("unload time not found")
            }
        }else{
            descargaVIew.isHidden = true
            sendSmsButton.isHidden = false
            seeMapButton.isHidden = false
            aumenteRazonLabel.isHidden = true
            timerVIew.isHidden = false
            labelHeght.constant = 42
        }
		switch service.typeDriverId {
		case 0:
			serviceTypeLabel.text = "Solo Conductor"
			serviceTypeImage.image = UIImage(named: "ico_driver")
		case 1:
			serviceTypeLabel.text = "Conductor / Porter"
			serviceTypeImage.image = UIImage(named: "ico_porter")
		case 2:
			serviceTypeLabel.text = "Dos porter"
			serviceTypeImage.image = UIImage(named: "ico_dosPorter")
		default:
			break
		}
		if service.type == "PER_HOURS"{
			trayectolabel.text = "Trayecto: Por horas"
			hastaLabel.text = "Numero de Horas"
			destinoLabel.text = service.totalHours!.description
		}else{
			destinoLabel.text = service.destinyAdress!
		}
		trayectoTimeLabel.text = String(format: "%.2f min (Tiempo estimado)", service.calculatedTime!) + " "
		 //.description + " min (Tiempo estimado)"
		precioLabel.text = String(format: "%.2f euros", service.price!)//service.price!.description + " euros"
		
		if service.state == "FINISHED" || service.state == "CHARGE"{
			//descargaTime.text = ""
			estado .text = "Completado"
            pendanteSeparator.isActive = false
            
		}else if service.state == "APPROVED"{
			estado.text = "Aceptado"
		}else if service.state == "DRAFT"{
			porterNameLabel.text = ""
			porterPhoneNUmber.text = ""
			if let view = view.viewWithTag(250){
				view.isHidden = true
			}
			seeMapButton.isHidden = true
			sendSmsButton.isHidden = true
            estado.text = "Pendiente"
            labelHeght.constant = 0
            timerVIew.isHidden = true
            aumenteRazonLabel.isHidden = true
            completedConstrain.isActive = false
            pendanteSeparator.constant = 10
            //completedConstrain.constant = 10
		}else{
			//TODO: - check runing time of service, update seconds and run timer
			if service.state ==  "TO_ORIGIN"{
				estado.text = "Hacia el origen"
			}else if service.state == "LOAD"{
				estado.text = "Carga"
			}else if service.state == "TO_DESTINY"{
				estado.text = "Hacia el destino"
			}else{
				estado.text = "Descargando"
			}
			let dateFormat = DateFormatter()
			dateFormat.locale = Locale(identifier: "es")
			print("is time \(String(describing: service.pickupInit))")
			dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
			if let time = service.pickupInit{
				if let time =  dateFormat.date(from: time){
					print("is time")
					let now = Date()
					seconds = Int(now.timeIntervalSince(time))
					runTimer()
				}else{					
					print("not found time")
				}
			}
		}
		sendSmsButton.setBorder(color: gray, width: 2.0, radius: 12)
		seeMapButton.setBorder(color: gray, width: 2.0, radius: 12)
		origenLabel.text = service.destinyAdress!
		fechaLabel.text = service.pickupDate! + "\n" + service.pickupTime!
		if let driver = service.driver{
			porterNameLabel.text = driver.name!
			porterPhoneNUmber.text = ""//driver.phoneToken
		}
	}
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		self.dismiss(animated: true, completion: nil)
	}
	func runTimer() {
		print("runing timer")
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
		//isTimerRunning = true
		//pauseButton.isEnabled = true
	}
	@objc func updateTimer() {
		print("timer update \(seconds)")
//		if seconds >= servicio!.calculatedTime!{//< 1 {
//			timer.invalidate()
//			//Send alert to indicate time's up.
//		} else {
			seconds += 1
			timerLabel.text = timeString(time: TimeInterval(seconds))
			//timerLabel.text = String(seconds)
			//            labelButton.setTitle(timeString(time: TimeInterval(seconds)), for: UIControlState.normal)
//		}
	}
	
	func timeString(time:TimeInterval) -> String {
		let hours = Int(time) / 3600
		let minutes = Int(time) / 60 % 60
		let seconds = Int(time) % 60
		return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
	}
	func loadDriver(with id: Int) {
		routeClient.instance.getProfile(by: id.description, success: { [weak self] data in
			do{
				let decoder = try JSONDecoder().decode(profile.self, from: data)
                if decoder.id != nil {
                    if let self = self{
                        self.porterPhoneNUmber.text = decoder.phoneNumber!
                    }
                }
			}catch{
				print(error.localizedDescription)
			}
			}, failure: { error in
				print(error.localizedDescription)
		})
	}
    func loadService(with id: Int){
        routeClient.instance.getService(by: id.description, success: { [weak self] data in
            do{
                let decoder = try JSONDecoder().decode(service.self, from: data)
                if decoder.id != nil {
                    guard let self = self else {return}
                    
                    self.setup(with: decoder)
                }
            }catch{
                
            }
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}
