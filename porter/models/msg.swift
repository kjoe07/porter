//
//  msg.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 23/8/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
import SwiftyJSON
struct msg{
	var body: String
	var senderName: String?
	var senderId:String?
	var recipientId:String?
	var id:String?
	var date: String?
	var delivered: Bool?
	var sent: Bool?
	var attachment: Int
	var selected: Bool?
	var imageURL: String?
	var imagenID: String?
	var imagen: UIImage?
	var read: String?
	init(from: JSON){
		self.body = from["text"].stringValue
		self.senderName = from["send"].stringValue
		self.senderId = from["sendId"].stringValue
		self.recipientId = from["recipeId"].stringValue
		self.id = from["id"].stringValue
		self.date = from["date"].stringValue
		self.attachment = from["attachmentType"].intValue
		self.imageURL = from["attachment"]["url"].stringValue
		self.imagenID = from["attachment"]["id"].stringValue
		self.read = from["read"].stringValue
	}
	init(body: String, senderName: String, senderId: String, recipientId: String, id: String) {
		self.body = body
		self.senderName = senderName
		self.recipientId = recipientId
		self.senderId = senderId
		self.attachment = 6
		self.date = Date().millisecondsSince1970.description
		self.id = id
	}
	init(image: UIImage, senderId: String, senderName: String, recipientId: String, id: String){
		self.imagen = image
		self.senderName = senderName
		self.senderId = senderId
		self.recipientId = recipientId
		attachment = 2
		body = ""
		self.date = Date().millisecondsSince1970.description
		self.id = id
	}
}
extension msg: Comparable{
	static func ==(lhs: msg, rhs: msg) -> Bool {
		return lhs.date == rhs.date
	}
	static func < (lhs:msg, rhs:msg) -> Bool{
		return Int(lhs.date!)! < Int(rhs.date!)!
	}
}
