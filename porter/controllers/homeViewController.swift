//
//  homeViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 6/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SideMenu
import Alamofire
import SwiftyJSON
import JGProgressHUD
class homeViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource,GMSAutocompleteViewControllerDelegate,UIGestureRecognizerDelegate {
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var continuar: UIButton!
	@IBOutlet weak var selectView: UIView!
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var servicioHoras: UIView!
	@IBOutlet weak var servicioOrigen: UIView!
	@IBOutlet weak var punto2View: UIView!
	@IBOutlet weak var punto2Text: UITextField!
	@IBOutlet weak var horasView: UIView!
	@IBOutlet weak var horasButton: UIButton!
	@IBOutlet weak var punto1View: UIView!
	@IBOutlet weak var punto1Text: UITextField!
	@IBOutlet weak var separator: UIView!
	@IBOutlet weak var menu: UIBarButtonItem!
	
	var arrayCoordinates : [CLLocationCoordinate2D] = []
	var longPressRecognizer = UILongPressGestureRecognizer()
	var locationManager = CLLocationManager()
	var currentLocationMarker: GMSMarker?
	var mapBearing: Double = 0
	var pickOption = [1,2,3,4,5,6,7,8]
	var punto1 = true
	var servicio: service!
	var simulacion: simulation!
	var params: Parameters!
    var punto1Cordinate: CLLocationCoordinate2D?
    var punto2Cordinate: CLLocationCoordinate2D?
    let hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
		configure()
		self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Logo")) //set a image as title in navi
		mapView.delegate = self
		do {
			// Set the map style by passing the URL of the local file.
			if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
				mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
			} else {
				NSLog("Unable to find style.json")
			}
		} catch {
			NSLog("One or more of the map styles failed to load. \(error)")
		}
		self.locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		mapView.isMyLocationEnabled = false
		SideMenuManager.default.menuFadeStatusBar = false
		SideMenuManager.default.menuPresentMode = .menuSlideIn
		SideMenuManager.default.menuPushStyle = .popWhenPossible
		SideMenuManager.default.menuAllowPushOfSameClassTwice = false
		continuar.layer.cornerRadius = 21
		continuar.clipsToBounds = true
		selectView.layer.cornerRadius = 12
		selectView.clipsToBounds = true
		servicioHoras.layer.cornerRadius = 12
		servicioOrigen.layer.cornerRadius = 12
		punto1View.layer.cornerRadius = 12
		horasView.layer.cornerRadius = 12
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
		let revealViewController = self.revealViewController()
        revealViewController?.rearViewRevealWidth = ((UIScreen.main.bounds.width * 74.6875) / 100)
		if revealViewController != nil {
			print("is not nil")
			menu.target = self.revealViewController()
			menu.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}else{
			print("nothing happen")
		}
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
		self.navigationController?.navigationBar.addGestureRecognizer(revealViewController!.panGestureRecognizer())
		//let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
		//longPressRecognizer = UILongPressGestureRecognizer(target: self,action:#selector(self.longPress))
		//longPressRecognizer.minimumPressDuration = 0.5
		//longPressRecognizer.delegate = self
//		mapView.addGestureRecognizer(revealViewController!.panGestureRecognizer())
//		mapView.settings.scrollGestures = false
//		mapView.settings.zoomGestures = false
		loadActive()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.continuar.isSelected = false
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "prices"{
			let vc = segue.destination as! pricesViewController
			//vc.servicio = self.servicio
			print("the simulation is \(self.simulacion.debugDescription)")
			vc.simulacion = self.simulacion
			vc.params = self.params
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if CLLocationManager.locationServicesEnabled() {
			startMonitoringLocation()
			addCurrentLocationMarker()
		}
	}
	
	func startMonitoringLocation() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
			locationManager.activityType = CLActivityType.automotiveNavigation
			locationManager.distanceFilter = 1
			locationManager.headingFilter = 1
			locationManager.requestWhenInUseAuthorization()
			locationManager.startMonitoringSignificantLocationChanges()
			locationManager.startUpdatingLocation()
		}
	}
	
	func stopMonitoringLocation() {
		locationManager.stopMonitoringSignificantLocationChanges()
		locationManager.stopUpdatingLocation()
	}
	
	func addCurrentLocationMarker() {
		currentLocationMarker?.map = nil
		currentLocationMarker = nil
		if let location = locationManager.location {
			currentLocationMarker = GMSMarker(position: location.coordinate)
			currentLocationMarker?.icon = #imageLiteral(resourceName: "Geolocalización")
			currentLocationMarker?.map = mapView
			currentLocationMarker?.rotation = locationManager.location?.course ?? 0
		}
	}
	
	func zoomToCoordinates(_ coordinates: CLLocationCoordinate2D) {
		let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 14)
		mapView.camera = camera
	}
	
	//MARK:- Location Manager Delegate
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("location manager erroe -> \(error.localizedDescription)")
	}
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			break
		case .restricted:
			break
		case .denied:
			stopMonitoringLocation()
			break
		default:
			addCurrentLocationMarker()
			startMonitoringLocation()
			break
		}
	}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location update")
		if let lastLocation = locations.last {
			currentLocationMarker?.position = lastLocation.coordinate
			currentLocationMarker?.rotation = lastLocation.course
			self.zoomToCoordinates(lastLocation.coordinate)
			self.stopMonitoringLocation()
        }else{
            self.stopMonitoringLocation()
        }
	}
	func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	func textFieldDidBeginEditing(_ textField: UITextField) {
        self.stopMonitoringLocation()
        locationManager.delegate = nil
		if textField == punto1Text{
			punto1 = true
		}else{
			punto1 = false
		}
		self.servicioOrigen.isHidden = true
		self.servicioHoras.isHidden = true
		let autocompleteController = GMSAutocompleteViewController()
		autocompleteController.delegate = self
		let filter = GMSAutocompleteFilter()
		filter.country = "es"
		//filter.
		//filter.type = .region
		//filter.type = .address
		autocompleteController.autocompleteFilter = filter
		present(autocompleteController, animated: true, completion: nil)
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		self.view.endEditing(true)
//		print(coordinate.latitude)
//		if arrayCoordinates.count < 2{
//			let newMarker = GMSMarker(position: coordinate)//GMSMarker(position: ) //mapView.projection.coordinate(for: sender.location(in: mapView))
//			print("the position is \(newMarker.position)")
//			self.arrayCoordinates.append(newMarker.position)
//			print("contando el Array \(arrayCoordinates.count)")
//			newMarker.map = mapView
//			let geoCoder = CLGeocoder()
//			let location = CLLocation(latitude: newMarker.position.latitude, longitude: newMarker.position.longitude)
//			geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] placeMark, error in
//				guard let placemark = placeMark?.first, error == nil else { return }
//				DispatchQueue.main.async {
//					//  update UI here
//					print("address1:", placemark.thoroughfare ?? "")
//					print("address2:", placemark.subThoroughfare ?? "")
//					print("city:",     placemark.locality ?? "")
//					print("state:",    placemark.administrativeArea ?? "")
//					print("zip code:", placemark.postalCode ?? "")
//					print("country:",  placemark.country ?? "")
//					if let self = self{
//						if self.arrayCoordinates.count < 2 {
//							self.punto1Text.text = placemark.thoroughfare! + "," + placemark.locality! + "," + placemark.country!
//						}else{
//							self.punto2Text.text = placemark.thoroughfare! + "," + placemark.locality! + "," + placemark.country!
//							let origin = "\(self.arrayCoordinates[0].latitude), \(self.arrayCoordinates[0].longitude)"
//							let destiny = "\(self.arrayCoordinates[1].latitude),\(self.arrayCoordinates[1].longitude)"
//							self.drawPath(origin: origin, destination: destiny)							
//						}
//					}
//				}
//			})
//		}
	}
	@IBAction func continuarAction(_ sender: Any) {		
		if punto1Text.text != "" && (punto2Text.text != "" || horasButton.titleLabel?.text != "Número de Horas"){
			if punto1Text.text != punto2Text.text{
                hud.textLabel.text = "Simulando Servicio"
                hud.show(in: self.view)
                hud.interactionType = .blockAllTouches
				var params: Parameters!
				if punto2View.isHidden {
					params = ["pickup_address": punto1Text.text!, "type":"PER_HOURS","hours":horasButton.tag]
				}else{
					params = ["pickup_address": punto1Text.text!, "type":"ORIGIN_DESTINY","destination_address":punto2Text.text!]
				}
					self.params = params
				//continuar.isSelected = true
				//continuar.isUserInteractionEnabled = false
				UIApplication.shared.isNetworkActivityIndicatorVisible = true
				routeClient.instance.simulate(params: params, success: {[weak self] data in
                    if let self = self {
                        self.hud.textLabel.text = "Procesando respuesta"
                        let start = Date()
                        do{
                            let decoder = try JSONDecoder().decode(simulationResponse.self, from: data)
                            print(start.timeIntervalSinceNow.description)
                            if decoder.success != nil && decoder.success!{
                                self.simulacion = decoder.data
                                print("the data is \(self.simulacion.debugDescription)")
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                //self.continuar.isUserInteractionEnabled = true
                                self.hud.dismiss()
                                self.performSegue(withIdentifier: "prices", sender: self)
                            }else if decoder.code != nil {
                                self.showError(tittle: "El destino excede la distancia máxima", error: "Escoja nuevo destino por favor.")
                            }
                        }catch{
                            print("error in decode \(error.localizedDescription)")
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.hud.dismiss()
                            //self.continuar.isUserInteractionEnabled = true
                            self.showError(tittle: "Error al leer los datos de la peticion", error: error.localizedDescription)
                        }
                    }
				}, failure: {[weak self] error in
					if let self = self{
						self.continuar.isSelected = false
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
						//self.continuar.isUserInteractionEnabled = true
                        self.hud.dismiss()
						self.showError(tittle: "Error en la peticion", error: error.localizedDescription)
					}
				})
			}else{
				self.showError(tittle: "El puntos de origen y destino no pueden ser iguales", error: "")
				punto2Text.text = ""
			}
		}else{
			if punto2Text.isHidden{
				if punto1Text.text == ""{
					self.showError(tittle: "Por favor ingrese una direccion de origen", error: "")
				}else if horasButton.titleLabel?.text == "Número de Horas"{
					self.showError(tittle: "Escoja el número de horas ", error: "que desea contratar el servicio")
				}
			}else{
				if punto1Text.text == ""{
					self.showError(tittle: "Por favor ingrese una direccion de origen", error: "")
				}else if punto2Text.text == ""{
					self.showError(tittle: "Por favor ingrese una direccion de Destino", error: "")
				}
			}
		}
	}
	@IBAction func selectAction(_ sender: Any) {
		if servicioOrigen.isHidden{
			servicioOrigen.isHidden = false
			servicioHoras.isHidden = false
			//TODO: - add black layer with 0.3 alpha
			if horasView.isHidden == false{
				//horasButton.backgroundColor = UIColor(white: 0, alpha: 0.3)
			}else{
				
			}
		}else{
			servicioOrigen.isHidden = true
			servicioHoras.isHidden = true
		}
	}
	@IBAction func selectHorasAction(_ sender: Any) { //action for pick the number of hours this should show the picker
		print("picker")
		let pickerView = UIPickerView(frame: CGRect(x: UIScreen.main.bounds.width - (15 + 96) , y: horasView.frame.maxY + 2, width: 96, height: horasView.frame.height * 2))
		pickerView.delegate = self
		pickerView.dataSource = self
		pickerView.tag = 20
		pickerView.backgroundColor = UIColor(white: 1, alpha: 1)
		pickerView.layer.cornerRadius = 12
		pickerView.clipsToBounds = true
		pickerView.showsSelectionIndicator = true
		//pickerView.rowSize(forComponent: 30)
		view.addSubview(pickerView)
		view.bringSubview(toFront: pickerView)
		self.servicioOrigen.isHidden = true
		self.servicioHoras.isHidden = true
	}	
	@IBAction func origenAction(_ sender: Any) {
		selectButton.setTitle("Origen y Destino", for: .normal)
		horasView.isHidden = true
		punto2View.isHidden = false
		separator.isHidden = false
		punto1View.layer.cornerRadius = 12
		punto2View.layer.cornerRadius = 12
		servicioOrigen.isHidden = true
		servicioHoras.isHidden = true
		punto1View.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		punto2View.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
		if let view = view.viewWithTag(20){
			view.removeFromSuperview()
		}
		
	}
	@IBAction func horasAction(_ sender: Any) {
		selectButton.setTitle("Servicio por horas", for: .normal)
		horasView.isHidden = false
		punto2View.isHidden = true
		punto1View.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
		//punto1View.layer.cornerRadius = 12
		//punto1View.clipsToBounds = true
		servicioOrigen.isHidden = true
		servicioHoras.isHidden = true
		separator.isHidden = true
		
	}
	//MARK: - picker
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickOption.count
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickOption[row].description + ( row == 0 ? " hora" : " horas")
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		horasButton.setTitle(pickOption[row].description + ( row == 0 ? " hora" : " horas"), for: .normal)
		horasButton.tag  = row + 1
		pickerView.removeFromSuperview()
	}
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 30
	}
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//		print("Place name: \(place.name)")
//		print("Place address: \(place.formattedAddress)")
//		print("Place attributions: \(place.attributions)")
        self.stopMonitoringLocation()
		if punto1{
			print("is text1")
			punto1Text.text = place.formattedAddress
            punto1Cordinate =  place.coordinate//place.viewport?.southWest
            let newMarker = GMSMarker(position: punto1Cordinate!)
            newMarker.icon = UIImage(named: "desde")
            newMarker.map = self.mapView
            self.mapView.animate(toLocation: punto1Cordinate!)
            self.mapView.camera = GMSCameraPosition.camera(withTarget: punto1Cordinate!, zoom: 14.0)
            //self.zoomToCoordinates(punto1Cordinate!)
            if punto2Cordinate != nil{
                self.drawPath(origin: "\(punto1Cordinate!.latitude),\(punto1Cordinate!.longitude)", destination: "\(punto2Cordinate!.latitude),\(punto2Cordinate!.longitude)")
                let mapsBound = GMSCoordinateBounds(coordinate: punto1Cordinate!, coordinate: punto2Cordinate!)
                //self.mapView.camera(for: mapsBound, insets: <#T##UIEdgeInsets#>)
                // self.mapView.cameraTargetBounds = mapsBound
                self.mapView.animate(with: GMSCameraUpdate.fit(mapsBound, withPadding: 120.0))
            }
		}else{
			print("is text2")
			punto2Text.text = place.formattedAddress
            punto2Cordinate = place.coordinate//viewport?.southWest
            let newMarker = GMSMarker(position: punto2Cordinate!)
            newMarker.icon = UIImage(named: "hasta")
            newMarker.map = self.mapView
            if punto1Cordinate != nil {
                self.drawPath(origin: "\(punto1Cordinate!.latitude),\(punto1Cordinate!.longitude)", destination: "\(punto2Cordinate!.latitude),\(punto2Cordinate!.longitude)")
                let mapsBound = GMSCoordinateBounds(coordinate: punto1Cordinate!, coordinate: punto2Cordinate!)
                //self.mapView.camera(for: mapsBound, insets: <#T##UIEdgeInsets#>)
               // self.mapView.cameraTargetBounds = mapsBound
               // self.mapView.animate(with: GMSCameraUpdate.fit(mapsBound, withPadding: 120.0))
                //self.mapView.camera = GMSCameraPosition.
                self.mapView.animate(with: GMSCameraUpdate.fit(mapsBound))
                
            }
            
		}
		dismiss(animated: true, completion: nil)
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		// TODO: handle the error.
		print("Error: ", error.localizedDescription)
	}
	
	// User canceled the operation.
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	@IBAction func unwindToVC1(segue:UIStoryboardSegue) {
		self.punto1Text.text = ""
        self.punto2Text.text = ""
        self.servicioHoras.isHidden = true
        self.servicioOrigen.isHidden = true
        horasView.isHidden = true
        selectButton.setTitle("Origen y Destino", for: .normal)
        self.mapView.clear()
	}
	@IBAction func longPress(_ sender: UITapGestureRecognizer) {
		debugPrint("You tapped at YES")
		if arrayCoordinates.count < 2{
			let newMarker = GMSMarker(position: mapView.projection.coordinate(for: sender.location(in: mapView)))
			print("the position is \(newMarker.position)")
			self.arrayCoordinates.append(newMarker.position)
			print("contando el Array \(arrayCoordinates.count)")
			newMarker.map = mapView
			let geoCoder = CLGeocoder()
			let location = CLLocation(latitude: newMarker.position.latitude, longitude: newMarker.position.longitude)
			geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] placeMark, error in
				guard let placemark = placeMark?.first, error == nil else { return }
				DispatchQueue.main.async {
					//  update UI here
					print("address1:", placemark.thoroughfare ?? "")
					print("address2:", placemark.subThoroughfare ?? "")
					print("city:",     placemark.locality ?? "")
					print("state:",    placemark.administrativeArea ?? "")
					print("zip code:", placemark.postalCode ?? "")
					print("country:",  placemark.country ?? "")
					if let self = self{
						if self.arrayCoordinates.count < 2 {
							self.punto1Text.text = placemark.thoroughfare! + "," + placemark.locality! + "," + placemark.country!
						}else{
							self.punto2Text.text = placemark.thoroughfare! + "," + placemark.locality! + "," + placemark.country!
						}
					}
				}
			})
		}
	}
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
	{
		return true
	}
	func configure(){
		selectButton.setTitle("Origen y Destino", for: .normal)
		horasView.isHidden = true
		punto2View.isHidden = false
		separator.isHidden = false
		punto1View.layer.cornerRadius = 12
		punto2View.layer.cornerRadius = 12
		servicioOrigen.isHidden = true
		servicioHoras.isHidden = true
		punto1View.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		punto2View.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
		if let view = view.viewWithTag(20){
			view.removeFromSuperview()
		}
	}
	func drawPath (origin: String, destination: String) {
        /* set the parameters needed */
        let prefTravel = "driving" /* options are driving, walking, bicycling */
        let gmapKey = "AIzaSyAlt-GdJBgD1sf23jN665koBq04JOfCRX4"
        /* Make the url */
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(prefTravel)&key=" + gmapKey)

        /* Fire the request */
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        Alamofire.request(url!).responseJSON{(responseData) -> Void in
            print("the response data values is \(responseData.result.value) \(responseData.data)")
            if((responseData.result.value) != nil) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                /* read the result value */
                let swiftyJsonVar = JSON(responseData.result.value!)
                /* only get the routes object */
                if let resData = swiftyJsonVar["routes"].arrayObject {
                    let routes = resData as! [[String: AnyObject]]
                    /* loop the routes */
                    var bounds = GMSCoordinateBounds()
                    if routes.count > 0 {
                        for rts in routes {
                            /* get the point */
                            let overViewPolyLine = rts["overview_polyline"]?["points"]
                            let path = GMSMutablePath(fromEncodedPath: overViewPolyLine as! String)
                            /* set up poly line */
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 2
                            polyline.strokeColor = darkBlue
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            //bounds = bounds.includingCoordinate(_path.coordinate(at: ))
                            polyline.map = self.mapView
                        }
                    }
                }
            }else{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("error al calcular ruta")
                print("response data  error is \(responseData.error?.localizedDescription)")
            }
        }
	}
	func loadActive(){
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		routeClient.instance.getActive(success: { /*[weak self]*/ data in
			do{
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				let decoder = try JSONDecoder().decode(service.self, from: data)
				print("the active is \(decoder)")
				if decoder.id != nil {
//					if let self = self{
						print("self is found so the view must show")
						//self.serviceView.isHidden = false
					requestManager.instance.active = decoder
//						if let state = decoder.state{
//							let i = self.serviceStateRaw.lastIndex(where: {
//								$0 == state
//							})
//							self.serviceState.text = self.serviceStateState[i!]
//							self.actionButton.setTitle(self.serviceStateString[i!+1], for: .normal)
//						}
//					}
				}else{
					print("error en el activo")
				}
			}catch{
				print(error.localizedDescription)
			}
			}, failure: { error in
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				print(error.localizedDescription)
		})
	}
}
