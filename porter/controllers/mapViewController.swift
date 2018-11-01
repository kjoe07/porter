//
//  mapViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 28/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import SwiftyJSON
class mapViewController: UIViewController,GMSMapViewDelegate {
	@IBOutlet weak var mapview: GMSMapView!
	var id: String?
	var currentLocationMarker: GMSMarker?
	var servicio: service?
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barStyle = .black
//		Auth.auth().signInAnonymously() { (user, error) in
//			print("the auth result \(user,error)")
//			if let aUser = user {
//				print("the values of \(aUser)")
//				//self.user = aUser.
//			}
//		}
		
//		let filePath = Bundle.main.path(forResource: "GoogleService", ofType: "plist")
//		guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
//			else { assert(false, "Couldn't load config file") }
//		//FirebaseApp.configure(options: fileopts)
		let secondaryOptions = FirebaseOptions(googleAppID: "1:720317912525:ios:38bd44ad53042c89", gcmSenderID: "720317912525")
		secondaryOptions.bundleID = "com.porterClient.app"
		secondaryOptions.apiKey = "AIzaSyCSls1gH4I-qVmeFLsfPN2WgXrxvwwuWFQ"
		secondaryOptions.clientID = "720317912525-0069ak8koqhbtkul9e2hu5kbvkkvrhpe.apps.googleusercontent.com"
		secondaryOptions.databaseURL = "https://porterclient-fd440.firebaseio.com"
		secondaryOptions.storageBucket = "myproject.appspot.com"
		
		if FirebaseApp.app(name: "secondary") == nil {
			FirebaseApp.configure(name: "secondary", options: secondaryOptions)
		}
		
		// Retrieve a previous created named app.
		guard let secondary = FirebaseApp.app(name: "secondary")
			else { return }//assert(false, "Could not retrieve secondary app")  }
		
		// Retrieve a Real Time Database client configured against a specific app.
		let secondaryDb = Database.database(app: secondary)
		mapview.isMyLocationEnabled = false
		mapview.delegate = self
		do {
			// Set the map style by passing the URL of the local file.
			if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
				mapview.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
			} else {
				NSLog("Unable to find style.json")
			}
		} catch {
			NSLog("One or more of the map styles failed to load. \(error)")
		}
		let query = secondaryDb.reference().child("locations").child(id!).queryOrderedByValue()
		//let query = Constants.refs.databaselocation.child(id!).queryOrderedByValue()//.queryLimited(toLast: 10)
		_ = query.observe(.childAdded, with: { [weak self] snapshot in
			print("entering into firebase db")
//			do{
//				let decoder = try JSONDecoder().decode(locationResponse.self, from: snapshot.value as! Data)
//				if decoder.idmudanza != nil {
//					if let self = self{
//						self.addCurrentLocationMarker(latiude: decoder.idmudanza!.latitude!, longitude: decoder.idmudanza!.longitude!)
//						let camera = GMSCameraPosition.camera(withLatitude: decoder.idmudanza!.latitude!, longitude: decoder.idmudanza!.longitude!, zoom: 14)//camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 14)
//						self.mapview.camera = camera
//					}
//				}
//			}catch{
//				print(error.localizedDescription)
//			}
			let json = JSON(snapshot.value!)
			print("the value of json \([json])")
			//print("the json Value \(json)")
			if let self = self{
				self.addCurrentLocationMarker(latiude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue)
				let camera = GMSCameraPosition.camera(withLatitude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue, zoom: 14)//camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 14)
				self.mapview.camera = camera
			}
			_ = query.observe(.childChanged, with: { [weak self] snapshot in
				let json1 = JSON(snapshot.value!)
				print("the value of json \([json1])")
				//print("the json Value \(json)")
				if json1["latitude"].doubleValue != json["latitude"].doubleValue || json1["longitude"].doubleValue != json["longitude"].doubleValue{
					if let self = self{
						self.addCurrentLocationMarker(latiude: json1["latitude"].doubleValue, longitude: json1["longitude"].doubleValue)
						let camera = GMSCameraPosition.camera(withLatitude: json1["latitude"].doubleValue, longitude: json1["longitude"].doubleValue, zoom: 14)//camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 14)
						self.mapview.camera = camera
					}
				}
			})
		})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	func addCurrentLocationMarker(latiude: CLLocationDegrees, longitude: CLLocationDegrees) {
		currentLocationMarker?.map = nil
		currentLocationMarker = nil
		let location = CLLocationCoordinate2D(latitude: latiude , longitude: longitude)
		//if let location = locationManager.location {
			currentLocationMarker = GMSMarker(position: location)//GMSMarker(position: location.coordinate)
			currentLocationMarker?.icon = #imageLiteral(resourceName: "Geolocalización")
			currentLocationMarker?.map = mapview
			//currentLocationMarker?.rotation = locationManager.location?.course ?? 0
	
	}
	
}
