//
//  getCards.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct cardList: Decodable {
	var success: Bool?
	var code: String?
	var data: [card]?
	var object: String?
	var hasMore: Bool?
	var url: String?
	enum CodingKeys: String,CodingKey {
		case success
		case code
		case data
		case object
		case hasMore = "has_more"
		case url
	}
	init(from decoder: Decoder) throws {
		print("going to decode from decoder showing results")
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.success = (try values.decodeIfPresent(Bool.self, forKey: .success))
		print("id value")
		self.code = (try values.decodeIfPresent(String.self, forKey: .code))
		print("name value")
		
		self.object = (try values.decodeIfPresent(String.self, forKey: .object))
		print("object")
		self.hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore)
		print("has more")
		self.url = try values.decodeIfPresent(String.self, forKey: .url)
		print("url")
		self.data = (try values.decodeIfPresent([card].self, forKey: .data))
		print("data")
	}
}
