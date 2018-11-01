//
//  userDriver.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 28/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct userDriver: Decodable {
	var id: Int?
	var email: String?
	var name: String?
	var active: Bool?
	var isAdmin: Bool?
	var isDriver: Bool?
	var isPorter: Bool?
	var phoneToken: String?
	var evaluatedWorkerId: Int?
	enum CodingKeys: String,CodingKey {
		case id
		case email
		case name
		case active
		case isAdmin = "is_admin"
		case isDriver = "is_driver"
		case isPorter = "is_porter"
		case phoneToken = "phone_token"
		case evaluatedWorkerId = "evaluated_worker_id"
	}
}
/*
"id": 49,
"email": "cpscjvlobrr@example.com",
"name": "Bria",
"active": true,
"is_admin": false,
: true,
: true,
"phone_token": "lbzioumghkv",
"evaluated_worker_id": 64,
"created_at": "2018-10-11 00:00:00",
"updated_at": "2018-09-28 14:01:00"
*/
