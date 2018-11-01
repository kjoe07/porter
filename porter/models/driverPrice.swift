//
//  driverPrice.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 10/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct driverPrice: Decodable {
	var price: String?
	var totalCost: Float?
	
	enum CodingKeys: String,CodingKey {
		case price
		case totalCost = "total_cost"
	}
}
