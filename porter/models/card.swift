//
//  card.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
struct card: Decodable {
	var id: String?//": "card_1D86fjBQSeRx3feU6vhvRzp4",
	var object: String?// "card",
	var addressCity: String?// null,
	var addressCountry: String?// null,
	var addressLine1: String? // null,
	var addressLine1Check: String?// null,
	var addressLine2: String?// null,
	var addressState: String? // null,
	var addressZip: String?// null,
	var addressZipCheck: String?// null,
	var brand: String?
	var country: String?//"US",
	var customer: String?// "cus_DZFAOzEnWnM5h9",
	var cvcCheck: String?//"pass",
	var dynamicLast4: String?// null,
	var expMonth: Int?// 12,
	var expYear: Int?// 2021,
	var fingerprint: String? // "5FYGKVj8LP3UnHHq",
	var funding: String?// "credit",
	var last4: String? // "4242",
	var metadata: [String]? //,
	var name: String?//null,
	var tokenizationMethod: String?//null
	enum CodingKeys: String,CodingKey {
		case id
		case object
		case addressCity = "address_city"
		case addressCountry = "address_country"
		case addressLine1 = "address_line1"
		case addressLine1Check = "address_line1_check"
		case addressLine2 = "address_line2"
		case addressState = "address_state"
		case addressZip = "address_zip"
		case addressZipCheck = "address_zip_check"
		case brand
		case country
		case customer
		case cvcCheck = "cvc_check"
		case dynamicLast4 = "dynamic_last4"
		case expMonth = "exp_month"
		case expYear = "exp_year"
		case fingerprint
		case funding
		case last4
		case metadata
		case name
		case tokenizationMethod = "tokenization_method"
	}
//	init(from decoder: Decoder) throws {
//		print("going to decode from decoder showing results")
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		self.id = (try values.decodeIfPresent(String.self, forKey: .id))
//		print("id value \(self.id)")
//		self.object = (try values.decodeIfPresent(String.self, forKey: .object))
//		print("object")
//		self.addressCity = (try values.decodeIfPresent(String.self, forKey: .addressCity))
//		print("address city")
//		self.addressCountry = (try values.decodeIfPresent(String.self, forKey: .addressCountry))
//		print("address country")
//		self.addressLine1 = (try values.decodeIfPresent(String.self, forKey: .addressLine1))
//		print("address Line1")
//		self.addressLine1Check = (try values.decodeIfPresent(String.self, forKey: .addressLine1Check))
//		print("addressLine1Check")
//		self.addressLine2 = (try values.decodeIfPresent(String.self, forKey: .addressLine2))
//		print("address Line2")
//		self.addressState = (try values.decodeIfPresent(String.self, forKey: .addressState))
//		print("address State")
//		self.addressZip = (try values.decodeIfPresent(String.self, forKey: .addressZip))
//		print("address Zip")
//		self.addressZipCheck = (try values.decodeIfPresent(String.self, forKey: .addressZipCheck))
//		print("address Zip check")
//		self.brand = (try values.decodeIfPresent(String.self, forKey: .brand))
//		print("address Line1")
//		self.brand = (try values.decodeIfPresent(String.self, forKey: .brand))
//		print("brand")
//		self.country = (try values.decodeIfPresent(String.self, forKey: .country))
//		print("country")
//		self.customer = (try values.decodeIfPresent(String.self, forKey: .customer))
//		print("address Line1")
//		self.image = (try values.decodeIfPresent(imageModel.self, forKey: .image))
//		self.userId = (try values.decodeIfPresent(Int.self, forKey: .userId))
//		print("userID")
//		self.imageId = (try values.decodeIfPresent(Int.self, forKey: .imageId))
//		print("imgenId")
//		self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
//		print("phone numebr")
//		self.email = try values.decodeIfPresent(String.self, forKey: .email)
//	}
	
}
