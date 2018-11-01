//
//  requestManager.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 11/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
class requestManager{
	static let instance = requestManager()
	var token: String!
	var phoneToken: String!
	var user: profile!
	var active: service?
	func loadUserData() {
		let defaults = UserDefaults.standard
		if let token = defaults.string(forKey: "token"){
			print("value read from token \(token)")
			requestManager.instance.token = token
		}
		if requestManager.instance.user == nil {
			requestManager.instance.user = profile()
		}
		let decoder = JSONDecoder()
		if let user = UserDefaults.standard.data(forKey: "user"){
			print("data for user \(user)")
			do{
				let question = try decoder.decode(profile.self, from: user)
				//print("birthDate from decoder \(question.birthDate)")
				//print("location \(question.currentLocation)")
				//print("name from decoder \(question.firstName)")
				if question.id != nil {
					print("the user data \(question)")
					requestManager.instance.user = question

				}
			}catch{
				print(error.localizedDescription)
				//print("el valor de birthDate in \(requestManager.instance.user.birthDate)")
			}
		}
	}
	func setToken(){
        if let token = requestManager.instance.token{
            print("saving token n userdefaul value = \(String(describing: token))")
            let userDefaults = UserDefaults.standard
            userDefaults.set(token, forKey: "token")
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(requestManager.instance.user) {
                print("the value encoded \(encoded)")
                UserDefaults.standard.set(encoded, forKey: "user")
                if let json = String(data: encoded, encoding: .utf8) {
                    print("reading value in userDefault \(json)")
                }
            }else{
                print("hubo un fallo al guardar los datos en UserDefault")
            }
        }
		
	}
}
