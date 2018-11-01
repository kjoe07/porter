//
//  viewExtension.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
extension UIView{
	func setBorder(color: UIColor,width: CGFloat,radius: CGFloat){
		self.layer.cornerRadius = radius
		self.layer.borderWidth = width
		self.layer.borderColor = color.cgColor
	}
}

