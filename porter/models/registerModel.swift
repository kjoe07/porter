//
//  registerModel.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 14/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct respuestaLogin: Codable {
	var success: Bool
	var code: String?
	var token: String?
	var error: loginError?
	var profile: profile?
	enum CodingKeys: String, CodingKey {
		case success
		case token
		case profile
		case code
		case error
	}/**/
}
