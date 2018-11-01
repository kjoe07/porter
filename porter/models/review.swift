//
//  review.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 4/10/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct review : Codable {
	let comment : String?
	let rapidity : String?
	let sympathy : String?
	let cleaning : String?
	let service_id : String?
	let updated_at : String?
	let created_at : String?
	let id : Int?
	
	enum CodingKeys: String, CodingKey {
		
		case comment = "comment"
		case rapidity = "rapidity"
		case sympathy = "sympathy"
		case cleaning = "cleaning"
		case service_id = "service_id"
		case updated_at = "updated_at"
		case created_at = "created_at"
		case id = "id"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		comment = try values.decodeIfPresent(String.self, forKey: .comment)
		rapidity = try values.decodeIfPresent(String.self, forKey: .rapidity)
		sympathy = try values.decodeIfPresent(String.self, forKey: .sympathy)
		cleaning = try values.decodeIfPresent(String.self, forKey: .cleaning)
		service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
	}
	
}
