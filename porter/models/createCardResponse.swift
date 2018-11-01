//
//  createCardResponse.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct createCardResponse: Decodable {
	var success: Bool?
	var code: String?
	var error: loginError?
	var data: card?
	var object: String?
	var name: String?
	var tokenization_method: String?
}
