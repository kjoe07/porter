//
//  usuario.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 9/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
//import SwiftyJSON
struct profile: Codable{
	var id: Int?
	var firstName: String?
	var lastName: String?
	var phoneNumber: String?
	var userId: Int?
	var imageId: Int?
	var birthDate: String?
	var image: imageModel?
	var email: String?
	var user: User?
	enum CodingKeys: String, CodingKey {
		case id
		case firstName = "first_name"
		case lastName =  "last_name"
		case birthDate = "birth_date"
		case imageId = "image_id"
		case userId = "user_id"
		case phoneNumber = "phone_number"
		case image
		case email
		case user
	}
	init(){
	}

	init(from decoder: Decoder) throws {
		print("going to decode from decoder showing results")
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.id = (try values.decodeIfPresent(Int.self, forKey: .id))
		print("id value)")
		self.firstName = (try values.decodeIfPresent(String.self, forKey: .firstName))
		print("name value)")
		self.lastName = (try values.decodeIfPresent(String.self, forKey: .lastName))
		print("lasname value")
		if let date = try values.decodeIfPresent(String.self, forKey: .birthDate){
			self.birthDate = date //Date(fromString: mydate, format: .custom("yyyy-MM-dd"))
			print("after conversion)")
		}else{
			self.birthDate = nil
		}
		self.image = (try values.decodeIfPresent(imageModel.self, forKey: .image))
		self.userId = (try values.decodeIfPresent(Int.self, forKey: .userId))
		print("userID")
		self.imageId = (try values.decodeIfPresent(Int.self, forKey: .imageId))
		print("imgenId")
		self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
		print("phone numebr")
		self.email = try values.decodeIfPresent(String.self, forKey: .email)
		print("email")
		self.user = try values.decodeIfPresent(User.self, forKey: .user)
		print("the user")
	}
	func iscomplete() -> Bool{
		if (id != nil && lastName != nil && firstName != nil   && userId != nil && phoneNumber != nil){
			return true
		}else{
			return false
		}
	}
	
}


