//
//  defaultCardresponse.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct defaultCardResponse:Decodable {
	var success: Bool?
	var code: String?
	var data: defaultCard?
}
struct defaultCard: Decodable {
	var id: String?
	var defaultSource: String?
	enum CodingKeys: String, CodingKey {
		case id
		case defaultSource = "default_source"
	}
}
