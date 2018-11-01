//
//  response.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 9/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct Respuesta: Codable {
	var success: Bool?
	var code: String?
	var token: String?
	var user: profile?
	enum CodingKeys: String, CodingKey {
		case success
		case token
		case user
		case code
	}/**/
	init(from decoder: Decoder) throws {
		let value = try decoder.container(keyedBy: CodingKeys.self)
		self.success = (try value.decodeIfPresent(Bool.self, forKey: .success))
		self.code = try value.decodeIfPresent(String.self, forKey: .code)
		self.token = try value.decodeIfPresent(String.self, forKey: .token)
		do {
			self.user = try value.decodeIfPresent(profile.self, forKey: .user)
		}catch{
			print(error.localizedDescription)
		}
		
	}/**/
}
//return ['success' => true,'code' => 'wrong_credentials' 'token' => $token, 'profile' => $profile ];
//Cannot convert value of type 'profile?' to expected argument type 'profile.Type'
