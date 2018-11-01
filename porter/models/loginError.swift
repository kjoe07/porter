//
//  loginError.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 14/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct loginError: Codable{
	var email: String?
	var password: String?
	var currentPassword: String?
	var lastName: String?
	var firstName: String?
	var gender: String?
	var birthDate: String?
	
	enum CodingKeys: String, CodingKey{
		case email
		case password
		case currentPassword = "current_password"
		case lastName = "first_name"
		case firstName =  "last_name"
		case gender
		case birthDate =  "birth_date"
		
	}
}
