//
//  duration.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 10/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct duration: Decodable {
	var text: String?
	var timeInSeconds: Int?
	var timeInHours: String?
	enum CodingKeys: String, CodingKey {
		case text
		case timeInSeconds = "time_in_seconds"
		case timeInHours = "time_in_hours"
	}
	init(from decoder: Decoder) throws {
		print("going to decode from decoder showing results duration")
		let values = try decoder.container(keyedBy: CodingKeys.self)
		if let hours = try? values.decode(String.self, forKey: .timeInHours){
			self.timeInHours = hours
				print("time in hours")
		}else if let hours = try? values.decode(Double.self, forKey: .timeInHours){
			self.timeInHours = hours.description
			print("time in hours")
		}
		self.text = try values.decodeIfPresent(String.self, forKey: .text)//{
		self.timeInSeconds = try values.decodeIfPresent(Int.self, forKey: .timeInSeconds)
	}
}
