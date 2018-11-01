//
//  portersViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class portersViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var menu: UIBarButtonItem!
	var services = [service]()
	lazy private var backgroundViewWhenDataIsEmpty: UIView = { return UINib(nibName: "emtyPorters", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView }()
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		self.title = "Mis Portes"
		self.navigationController?.navigationBar.tintColor = .white
		loadData()
		//self.navigationItem.rightBarButtonItem?.
        // Do any additional setup after loading the view.
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
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! porterDetailViewController
		let index = tableView.indexPathForSelectedRow
		vc.servicio = self.services[index!.row]
    }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if services.count > 0 {
			tableView.backgroundView?.removeFromSuperview()
			tableView.backgroundColor = UIColor.white
			//tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
			return services.count
		}else{
			showBackgroundIfEmpty()
		}
		return 0
		//return services.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! portersTableViewCell
		cell.border.layer.borderColor = darkBlue.cgColor
		cell.border.layer.borderWidth = 2.0
		cell.border.layer.cornerRadius = 12
		cell.origen.text = services[indexPath.row].pickupAdress!
		if let destino = services[indexPath.row].destinyAdress{
			cell.destino.text = destino
		}
		cell.fecha.text = services[indexPath.row].pickupDate! + "\n" + services[indexPath.row].pickupTime!
		switch  services[indexPath.row].typeDriverId {
		case 1:
			cell.tipo.text = "Solo Conductor"
			cell.ico.image = #imageLiteral(resourceName: "ico_driver")
			cell.ico.contentMode = .center
		case 2:
			cell.tipo.text = "Conductor / Porter"
			cell.ico.image = #imageLiteral(resourceName: "ico_porter")
		case 3:
			cell.tipo.text = "Dos porter"
			cell.ico.image = #imageLiteral(resourceName: "ico_dosPorter")
		default:
			break
		}
		let formatted = String(format: "%.2f Euros", services[indexPath.row].price!)
		cell.precio.text = formatted
		switch services[indexPath.row].state {
		case "APPROVED":
			cell.status.text = "Aceptado"
		case "TO_ORIGIN":
			cell.status.text = "Hacia el origen"
		case "LOAD":
			cell.status.text = "Cargando"
		case "TO_DESTINY":
			cell.status.text = "Hacia el destino"
		case "UNLOAD":
			cell.status.text = "Descargando"
		case "FINISHED","CHARGE":
			cell.status.text = "Completado"
		default:
			cell.status.text = "En espera"
		}
		if services[indexPath.row].type == "PER_HOURS"{
			cell.tipoServicio.text = "Por Horas"
			if let horas = services[indexPath.row].totalHours{
				cell.destino.text = horas.description + " Horas"
			}else{
				cell.destino.text = "No disponible"
			}
		}else{
			
		}		
		//cell.status.text =
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "showDetails", sender: self)
	}
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //self.numbers.remove(at: indexPath.row)
            self.services.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.deleteService(with: self.services[indexPath.row].id!.description)
        }
    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteHandler: (UITableViewRowAction, IndexPath) -> Void = { _, indexPath in
//            //self.numbers.remove(at: indexPath.row)
//            self.services.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            self.deleteService(with: self.services[indexPath.row].id!.description)
//        }
//        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Eliminar", handler: deleteHandler)
//        // Add more actions here if required
//        return [deleteAction]
//    }
	func loadData(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		routeClient.instance.getAllServicesByUser(success: {[unowned self] data in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			do{
				let decoder = try JSONDecoder().decode(getAllServicesByUser.self, from: data)
				if decoder.success!{
					self.services = decoder.data!
					self.tableView.reloadData()
				}
			}catch{
				print(error.localizedDescription)
			}
		}, failure: { error in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			self.showError(tittle: "Error en la conexión, revise su conexion a internet", error: error.localizedDescription)
		})
	}
	func showBackgroundIfEmpty() {
		if tableView.backgroundView != nil {
			tableView.backgroundView?.removeFromSuperview()
		}
		tableView.backgroundView = backgroundViewWhenDataIsEmpty
	}
    func deleteService(with id: String){
        routeClient.instance.deleteService(id: id, success: { [weak self] data in
            do{
                let decoder = try JSONDecoder().decode(profile.self, from: data)
                if decoder.id != nil {
                    print("borrado correcto")
                }
            }catch{
                print(error.localizedDescription)
            }
            }, failure: {error in
                print(error.localizedDescription)
        })
    }

}
