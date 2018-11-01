//
//  AppDelegate.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 6/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Crashlytics
import Fabric
import FBSDKLoginKit
import Stripe
import Firebase
import FirebaseMessaging
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		GMSServices.provideAPIKey("AIzaSyB8vE2GYUF_6cpybn--GwoSZcERnmNBNto")
		GMSPlacesClient.provideAPIKey("AIzaSyB8vE2GYUF_6cpybn--GwoSZcERnmNBNto")
		Fabric.sharedSDK().debug = true
	  	STPPaymentConfiguration.shared().publishableKey = "pk_test_QKfTabwjFcsIu2bJdeEZ2IdU"
		FBSDKApplicationDelegate.sharedInstance().application(application,didFinishLaunchingWithOptions: launchOptions)
		FirebaseApp.configure()
		//FirebaseApp.configure(name: <#T##String#>, options: <#T##FirebaseOptions#>)
		requestManager.instance.loadUserData()
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		UNUserNotificationCenter.current().delegate = self
		Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
		//let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//		UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
		UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound], completionHandler: { _,_ in
			
			//application.registerForRemoteNotifications()
		})
		application.registerForRemoteNotifications()
//		if let token = requestManager.instance.token{
//			routeClient.instance.updateToken(params: ["phone_token": token], success:{ data in
//				do{
//					UIApplication.shared.isNetworkActivityIndicatorVisible = false
//					let decoder = try JSONDecoder().decode(profileResponse.self, from: data)
//					if decoder.error != nil{
//						requestManager.instance.token = nil
//						requestManager.instance.user = nil
//						UserDefaults.standard.set(nil, forKey: "token")
//						UserDefaults.standard.removeObject(forKey: "user")
//						UserDefaults.standard.removeObject(forKey: "default")
//						UserDefaults.standard.removeObject(forKey: "token")
//						print("GOING TO RegisterVC error renovando token")
//						let storyboard = UIStoryboard(name: "Main", bundle: nil)
//						let initialViewController = storyboard.instantiateViewController(withIdentifier: "registerVC")
//						self.window?.rootViewController = initialViewController
//						self.window?.makeKeyAndVisible()
//					}else{
//						print("is founnd the token ")
//					}
//				}catch{
//					print(error.localizedDescription)
//					do {
//						let decoder = try JSONDecoder().decode(errorResponse.self, from: data)
//						if decoder.error != nil{
//							requestManager.instance.token = nil
//							requestManager.instance.user = nil
//							UserDefaults.standard.set(nil, forKey: "token")
//							UserDefaults.standard.removeObject(forKey: "user")
//							UserDefaults.standard.removeObject(forKey: "default")
//							UserDefaults.standard.removeObject(forKey: "token")
//							print("GOING TO slider")
//							let storyboard = UIStoryboard(name: "Main", bundle: nil)
//							let initialViewController = storyboard.instantiateViewController(withIdentifier: "slider")
//							self.window?.rootViewController = initialViewController
//							self.window?.makeKeyAndVisible()
//						}
//					}catch{
//						print(error.localizedDescription)
//					}
//				}
//			}, failure: {error in
//				UIApplication.shared.isNetworkActivityIndicatorVisible = false
//				print(error.localizedDescription)
//			})
//
//		}
		
		if requestManager.instance.token != nil {
			Crashlytics.sharedInstance().setUserIdentifier(requestManager.instance.user.id!.description)
			print("the user value \(requestManager.instance.user.debugDescription)")
			if !requestManager.instance.user.iscomplete() {
				print("GOING TO TABBARVC")
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let initialViewController = storyboard.instantiateViewController(withIdentifier: "dataVC")
				self.window?.rootViewController = initialViewController
				self.window?.makeKeyAndVisible()
			}else{
				print("GOING TO REGISTER")
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
				//loginRequest.instance.delegate = initialViewController as profileViewController
				self.window?.rootViewController = initialViewController
				self.window?.makeKeyAndVisible()
			}
		}
		//UIApplication.shared.statusBarStyle = .lightContent
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
		requestManager.instance.setToken()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		requestManager.instance.setToken()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
		requestManager.instance.setToken()
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		requestManager.instance.setToken()
	}
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//		return SDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
		//return SDKApplicationDelegate.shared.application(_:open:options:)
		return true
	}
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
		
		return true
	}
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let token = Messaging.messaging().fcmToken
       // requestManager.instance.phoneToken = token
        if requestManager.instance.token != nil && token != requestManager.instance.phoneToken{
            routeClient.instance.updateToken(params: ["phone_token": token], success:{ data in
                do{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let decoder = try JSONDecoder().decode(profileResponse.self, from: data)
                    if decoder.error != nil{
                        requestManager.instance.phoneToken = token
                    }else{
                        print("is founnd the token ")
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }, failure: {error in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(error.localizedDescription)
            })
        }else{
            requestManager.instance.phoneToken = token
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("messagin fucntion printing")
        print(remoteMessage.appData)
    
        
    }
	func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		
		// With swizzling disabled you must let Messaging know about the message, for Analytics
		// Messaging.messaging().appDidReceiveMessage(userInfo)
		// Print message ID.
		
//        let aps = userInfo["aps"] as! [String: AnyObject]
//        let custom  = aps["alert"]! as? NSDictionary
//        let title = custom!["title"] as! String
//        let message = custom!["message"] as! String
//        let id = custom!["service_id"] as! Int
//        let state = custom!["state"] as! String
//        switch state{
//        case "draft":
//        //TODO: Fix change time:
//            print("change time")
//        case "FINISHED":
//            break
//        default:
//            if let vc = getVisibleViewController(nil) as? porterDetailViewController{
//                if vc.isKind(of: porterDetailViewController.self){
//                    vc.timer.invalidate()
//                    vc.timerLabel.text = "00:00:00"
//                }
//            }
//        }
        let serviceId = userInfo["service_id"] as! String
        //let title = userInfo["message"] as! String
        let status = userInfo["state"] as! String
		print("will present")
		if let messageID = userInfo["gcmMessageIDKey"] {
			print("Message ID: \(messageID)")
		}
		// Print full message.
		print(userInfo)
		// Change this to your preferred presentation option
		completionHandler([])
        let centralNotificaciones = UNUserNotificationCenter.current()
        let contenido = UNMutableNotificationContent()
        let aps = userInfo["aps"] as! [String: AnyObject]
        let custom  = aps["alert"]! as? NSDictionary

        if let title = userInfo["title"] as? String {
             contenido.title = title
        }else{
             contenido.title = custom!["title"] as! String
        }
        if let message = userInfo["message"] as? String{
             contenido.body = message
        }else{
            contenido.body = custom!["body"] as! String
        }
       
        //contenido.subtitle = "se ha guardado el contacto en la etecsa"
        //contenido.body = "por favor abra la app y consulte el historial para hacer la búsqueda en la BD"
        contenido.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let peticion = UNNotificationRequest.init(identifier: "DemoNotificacion", content: contenido, trigger: trigger)
        centralNotificaciones.add(peticion) { (error) in
            if error == nil {
                print("Se agrego correctamente")
            }else{
               self.processPush(userInfo: userInfo)
            }
        }
	}
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
//        if requestManager.instance.token != nil && token != requestManager.instance.phoneToken{
//            routeClient.instance.updateToken(params: ["phone_token": token], success:{ data in
//                do{
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    let decoder = try JSONDecoder().decode(profileResponse.self, from: data)
//                    if decoder.error != nil{
//                        requestManager.instance.phoneToken = deviceToken.description
//                    }else{
//                        print("is founnd the token ")
//                    }
//                }catch{
//                    print(error.localizedDescription)
//                }
//            }, failure: {error in
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                print(error.localizedDescription)
//            })
//        }else{
//            requestManager.instance.phoneToken = deviceToken.description
//        }
        Messaging.messaging().apnsToken = deviceToken
    }
	func userNotificationCenter(_ center: UNUserNotificationCenter,	didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
//        let aps = userInfo["aps"] as! [String: AnyObject]
//        let custom  = aps["alert"]! as? NSDictionary
//        let title = custom!["title"] as! String
//        let message = custom!["message"] as! String
//        let id = custom!["service_id"] as! Int
//        let state = custom!["state"] as! String
//        switch state{
//        case "FINISHED":
//            UserDefaults.standard.set(aps, forKey: "aps")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "evaluate")
//            self.window?.rootViewController = initialViewController
//            //(self.window?.rootViewController as? UITabBarController)?.selectedIndex = index
//            self.window?.makeKeyAndVisible()
//        default:
//            break
//            //if let vc =
//        }
		// Print message ID.
		print("did Recive remote")
		if let messageID = userInfo["gcmMessageIDKey"] {
			print("Message ID: \(messageID)")
		}
		// Print full message.
		print(userInfo)
		completionHandler()
        processPush(userInfo: userInfo)

	}
    func processPush(userInfo: [AnyHashable : Any] ){
        UIApplication.shared.applicationIconBadgeNumber = 0
        let serviceId = userInfo["service_id"] as! Int
        //let title = userInfo["message"] as! String
        let status = userInfo["state"] as! String
        if status != "charged"  &&  status != "DRAFT"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC = storyboard.instantiateViewController(withIdentifier: "menuVC")
            let chatVC = storyboard.instantiateViewController(withIdentifier: "chatNC") //as! newChatViewController
            ((chatVC as! UINavigationController).topViewController as! porterDetailViewController).id = serviceId //id = id
            let mainRWVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            mainRWVC.setRear(menuVC, animated: true)
            mainRWVC.setFront(chatVC, animated: true)
            self.window?.rootViewController = mainRWVC
            self.window?.makeKeyAndVisible()
        }else if status == "DRAFT"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "detailNC")
            ((initialViewController as! UINavigationController).topViewController as! servicesViewController)
            self.window?.rootViewController = initialViewController
            //(self.window?.rootViewController as? UITabBarController)?.selectedIndex = index
            self.window?.makeKeyAndVisible()
        }else {
            UserDefaults.standard.set(serviceId, forKey: "aps")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "evaluate")
            self.window?.rootViewController = initialViewController
            //(self.window?.rootViewController as? UITabBarController)?.selectedIndex = index
            self.window?.makeKeyAndVisible()
        }
    }

}
