//
//  driverType.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 19/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct driverType : Codable {
	let id : Int?
	let name : String?
	let description : String?
	let created_at : String?
	let updated_at : String?
	
	enum CodingKeys: String, CodingKey {
		
		case id = "id"
		case name = "name"
		case description = "description"
		case created_at = "created_at"
		case updated_at = "updated_at"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
	}
	
}
