//
//  contantes.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 9/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
import Firebase
struct K {
	struct ProductionServer {
		static let baseURL =  "http://www.freecashrewards.co/roomatch/api"//"http://192.168.1.251/api"//
	}
	
	struct APIParameterKey {
		static let password = "password"
		static let email = "email"
		static let provider = "facebook"
		static let token = "token"
	}
}

enum HTTPHeaderField: String {
	case authentication = "Authorization"
	case contentType = "Content-Type"
	case acceptType = "Accept"
	case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
	case json = "application/json"
}
struct Constants
{
	struct refs
	{
//		static let databaseRoot = Database.database(url: "https://porterclient-fd440.firebaseio.com").reference()//database().//reference()
//		static let databaselocation = databaseRoot.child("locations")
//		//static let databaseUser = databaseRoot.child("users")
		static let databaseRoot = Database.database(url: "https://porterclient-fd440.firebaseio.com").reference()//database().//reference()
		static let databaselocation = databaseRoot.child("locations")
		static let databaseUser = databaseRoot.child("users")
		static let databaseChats = databaseRoot.child("chats")
	}
}
