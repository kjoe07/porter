//
//  authServices.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 14/8/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
import Firebase
class AuthService {
	static let instance = AuthService()
	func login(){
		Auth.auth().signInAnonymously { (user, error) in
			if let error = error {
				print("Sign in failed:", error.localizedDescription)
				
			} else {
				print ("Signed in with uid:", user!.user.uid)
			}
		}
	}
}
