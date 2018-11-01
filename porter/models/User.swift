/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User : Codable {
	let id : Int?
	let email : String?
	let name : String?
	let active : Bool?
	let is_admin : Bool?
	let is_driver : Bool?
	let is_porter : Bool?
	let phone_token : String?
	let evaluated_worker_id : String?
	let created_at : String?
	let updated_at : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case email = "email"
		case name = "name"
		case active = "active"
		case is_admin = "is_admin"
		case is_driver = "is_driver"
		case is_porter = "is_porter"
		case phone_token = "phone_token"
		case evaluated_worker_id = "evaluated_worker_id"
		case created_at = "created_at"
		case updated_at = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		print("id")
		email = try values.decodeIfPresent(String.self, forKey: .email)
		print("email")
		name = try values.decodeIfPresent(String.self, forKey: .name)
		print("name")
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		print("active")
		is_admin = try values.decodeIfPresent(Bool.self, forKey: .is_admin)
		print("is admin")
		is_driver = try values.decodeIfPresent(Bool.self, forKey: .is_driver)
		print("is driver")
		is_porter = try values.decodeIfPresent(Bool.self, forKey: .is_porter)
		print("is porter")
		phone_token = try values.decodeIfPresent(String.self, forKey: .phone_token)
		print("phone token")
		if let id = try? values.decode(Int.self, forKey: .evaluated_worker_id){
			evaluated_worker_id = id.description
		}else{
			evaluated_worker_id = try values.decodeIfPresent(String.self, forKey: .evaluated_worker_id)
		}
		
		print("id evaluated")
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		print("created")
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		print("updated")
	}

}
