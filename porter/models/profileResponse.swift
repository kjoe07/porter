//
//  profileResponse.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 16/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct profileResponse: Codable {
	var success: Bool?
	var data: profile?
	var error: loginError?
	var code: String?
}
