//
//  AtributtedStringExtension.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 6/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
extension NSMutableAttributedString {
	@discardableResult func bold(_ text: String) -> NSMutableAttributedString {
		let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "system", size: 12)!]
		let boldString = NSMutableAttributedString(string:text, attributes: attrs)
		append(boldString)
		return self
	}
	@discardableResult func normal(_ text: String) -> NSMutableAttributedString {
		let normal = NSAttributedString(string: text)
		append(normal)
		
		return self
	}
}
