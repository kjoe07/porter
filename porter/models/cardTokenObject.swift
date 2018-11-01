//
//  cardTokenObject.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct cardToken:Decodable {
	var id: String?
	var object: String?
	var card: card?
	var client_ip: String?
	var created: Int?
	var livemode: Bool?
	var type: String?
	var used: Bool?
}
