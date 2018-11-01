//
//  service.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 10/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct service: Decodable {
	var id: Int?
	var pickupAdress: String?
	var type: String?
	var destinyAdress: String?
	//var user: profile?
	var totalHours: Int?
	var calculatedTime: Double?
	var description: String?
	var pickupDate: String?
	var pickupTime:String?
	var pickupInit: String?
	var isExpress: Int?
	var state: String?
	var userSolicitId: Int?
	var userporterId: Int?
	var typeDriverId: Int?
	var price: Double?
	var cardToken: String?
	var timeLoadUnload: Int?
	var userSolicit: profile?
	var drivertype: driverType?
	var driver: userDriver?
    var timeUnload: Double?
    var timeLoad: Double?
	enum CodingKeys: String, CodingKey {
		case id
		case pickupAdress = "pickup_address"
		case destinyAdress = "destiny_address"
		//case user = "user_solicit"
		case totalHours = "total_hours"
		case calculatedTime = "calculated_time"
		case description
		case pickupDate = "pickup_date"
		case pickupTime = "pickup_time"
		case pickupInit = "time_init"
		case isExpress = "is_express"
		case state
		case userSolicitId = "user_solicit_id"
		case userporterId = "user_porter_id"
		case typeDriverId = "driver_type_id"
		case price
		case cardToken = "card_token"
		case timeLoadUnload = "time_load_unload"
		case userSolicit = "user_solicit"
		case drivertype = "driver_type"
		case type
		case driver = "user_driver"
        case timeUnload = "time_unload"
        case timeLoad = "time_load"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.id = (try values.decodeIfPresent(Int.self, forKey: .id))
		print("id value")
		self.pickupAdress = (try values.decodeIfPresent(String.self, forKey: .pickupAdress))
		print("pickupAdress")
		self.destinyAdress = (try values.decodeIfPresent(String.self, forKey: .destinyAdress))
		print("destinyAdress")
		self.userSolicit = try values.decodeIfPresent(profile.self, forKey: .userSolicit)
		print("profile")
		if let totalHours = try? values.decode(String.self, forKey: .totalHours){
			self.totalHours = Int(totalHours)
			print("totalHours String")
		}else{
			self.totalHours = try values.decodeIfPresent(Int.self, forKey: .totalHours)
			print("totalHours Int")
		}
		//self.totalHours = try values.decodeIfPresent(Int.self, forKey: .totalHours)
		print("total hours")
		if let totalHours = try? values.decode(String.self, forKey: .calculatedTime){
			self.calculatedTime = Double(totalHours)
			print("calculatedTime String")
		}else{
			self.calculatedTime = try values.decodeIfPresent(Double.self, forKey: .calculatedTime)
			print("calculatedTime Int")
		}
		// = try values.decodeIfPresent(Int.self, forKey: .calculatedTime)
		print("hours")
		self.description = try values.decodeIfPresent(String.self, forKey: .description)
		print("description")
		self.pickupDate = try values.decodeIfPresent(String.self, forKey: .pickupDate)
		print("pickupDate")
		self.pickupTime = try values.decodeIfPresent(String.self, forKey: .pickupTime)
		print("pickupTime")
		self.pickupInit = try values.decodeIfPresent(String.self, forKey: .pickupInit)
		print("pickupInit \(String(describing: pickupInit))")
		if let isExpress = try? values.decode(String.self, forKey: .isExpress){
			self.isExpress = Int(isExpress)
			print("is express string")
		}else if let isExpress = try? values.decode(Int.self, forKey: .isExpress){
			self.isExpress = isExpress
			print("is express int")
		}else if let isExpress = try? values.decode(Bool.self, forKey: .isExpress){
			isExpress == true ? (self.isExpress = 1) : (self.isExpress = 0)
			print("is express Bool")
		}
//		self.isExpress = try values.decodeIfPresent(Int.self, forKey: .isExpress)
//		print("isexpres")
		self.state = try values.decodeIfPresent(String.self, forKey: .state)
		print("state")
		self.userporterId = try values.decodeIfPresent(Int.self, forKey: .userporterId)
		print("userportertID")
		self.userSolicitId = try values.decodeIfPresent(Int.self, forKey: .userSolicitId)
		print("userSolicitId")
		if let driverType = try? values.decode(String.self, forKey: .typeDriverId){
			self.typeDriverId = Int(driverType)
			print("typeDriverID")
		}else{
			self.typeDriverId = try values.decodeIfPresent(Int.self, forKey: .typeDriverId)
			print("typeDriverID")
		}		
		self.price = try values.decodeIfPresent(Double.self, forKey: .price)
		print("price")
		self.cardToken = try values.decodeIfPresent(String.self, forKey: .cardToken)
		print("card_token")
		self.timeLoadUnload = (try values.decodeIfPresent(Int.self, forKey: .timeLoadUnload))
		print("time to load and unload")
		self.drivertype = (try values.decodeIfPresent(driverType.self, forKey: .drivertype))
		print("driverType")
//		if let date = try values.decodeIfPresent(String.self, forKey: .birthDate){
//			self.birthDate = date //Date(fromString: mydate, format: .custom("yyyy-MM-dd"))
//			print("after conversion \(self.birthDate)")
//		}else{
//			self.birthDate = nil
//		}
		self.type = try values.decodeIfPresent(String.self, forKey: .type)
		print("type")
		
		//self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
		//print("phone numebr")
		self.driver = try values.decodeIfPresent(userDriver.self, forKey: .driver)
        if let time = try? values.decode(Double.self, forKey: .timeUnload){
            self.timeUnload = time
            print("unload time double \(time)")
        }else if let time = try? values.decode(String.self, forKey: .timeUnload){
            self.timeUnload = Double(time)
            print("unload time string")
        }else{
            print("not decode")
        }
        if let time = try? values.decode(Double.self, forKey: .timeLoad){
            self.timeLoad = time
            print("load time double \(time)")
        }else if let time = try? values.decode(String.self, forKey: .timeLoad){
            self.timeLoad = Double(time)
            print("load time string")
        }else{
            print("not decode")
        }
	}
}
