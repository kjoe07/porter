/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Data1 : Codable {
	let service : String?
	let durations : Durations?
	let one_driver : One_driver?
	let driver_porter : Driver_porter?
	let two_porter : Two_porter?

	enum CodingKeys: String, CodingKey {

		case service = "service"
		case durations = "durations"
		case one_driver = "one_driver"
		case driver_porter = "driver_porter"
		case two_porter = "two_porter"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		service = try values.decodeIfPresent(String.self, forKey: .service)
		durations = try values.decodeIfPresent(Durations.self, forKey: .durations)
		one_driver = try values.decodeIfPresent(One_driver.self, forKey: .one_driver)
		driver_porter = try values.decodeIfPresent(Driver_porter.self, forKey: .driver_porter)
		two_porter = try values.decodeIfPresent(Two_porter.self, forKey: .two_porter)
	}

}
