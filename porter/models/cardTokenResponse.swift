//
//  cardTokenResponse.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct cardTokenResponse {
	var success: Bool?
	var code: String?
	var error: loginError?
	var data: cardToken?
}
