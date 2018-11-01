//
//  simulation.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 10/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct simulation: Decodable {
	var service: String?
	var durations: duration?
	var oneDriver: driverPrice?
	var twoPorter: driverPrice?
	var driverPorter: driverPrice?
	enum CodingKeys: String, CodingKey {
		case service
		case durations
		case driverPorter =  "driver_porter"
		case twoPorter = "two_porter"
		case oneDriver = "one_driver"
	}
	init(from decoder: Decoder) throws {
		print("going to decode from decoder showing results")
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.service = (try values.decodeIfPresent(String.self, forKey: .service))
		print("service")
		
		self.twoPorter = (try values.decodeIfPresent(driverPrice.self, forKey: .twoPorter))
		print("two porter")
		self.driverPorter = (try values.decodeIfPresent(driverPrice.self, forKey: .driverPorter))
		print("driverPorter")
		self.oneDriver = (try values.decodeIfPresent(driverPrice.self, forKey: .oneDriver))
		print("one driver")
		if let val = try? values.decode(duration.self, forKey: .durations){
				self.durations = val
		}
		//self.durations = (try values.decodeIfPresent(duration.self, forKey: .service))
		print("service")	
	}
}
