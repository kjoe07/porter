//
//  distanceResponse.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct distance: Decodable {
	var destinationAddress: [String]?
	var originAddress: [String]?
	var row: [String: [elemento]]?
}

struct  elements: Decodable {
	
}
struct distanceDistance:Decodable{
	var text: String?
	var value: Int?
}
struct  elemento:Decodable {
	var distance: distanceDistance?
	var duration: distanceDistance?
}
