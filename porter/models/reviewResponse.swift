//
//  reviewResponse.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 4/10/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct reviewResponse : Codable {
	let success : Bool?
	let data : review?
	
	enum CodingKeys: String, CodingKey {
		
		case success = "success"
		case data = "data"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		data = try values.decodeIfPresent(review.self, forKey: .data)
	}
	
}
