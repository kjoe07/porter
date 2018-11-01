//
//  image.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 17/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct  imageModel:Codable {
	var createdAt: String //= "2018-07-17 12:53:37";
	var ext: String// = jpeg;
	var id: Int //= 6;
	var path: String // = "images/jFG7KqlMc1GvIGxIdeYvWzcS9eZjF8mSv41ek0nH.jpeg";
	var updatedAt: String // = "2018-07-17 12:53:37";
	enum CodingKeys: String, CodingKey{
		case createdAt = "created_at"
		case ext
		case id
		case path
		case updatedAt = "updated_at"
	}
}
