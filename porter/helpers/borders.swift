//
//  borders.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 17/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//
import  UIKit
extension UIView {
	
	// Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
	
	enum ViewSide {
		case Left, Right, Top, Bottom
	}
	
	func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
		
		let border = CALayer()
		border.backgroundColor = color
		
		switch side {
		case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
		case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
		case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
		case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
		}
		
		layer.addSublayer(border)
	}
	func addTopBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
		self.layer.addSublayer(border)
	}
	
	func addRightBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
		self.layer.addSublayer(border)
	}
	
	func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
		self.layer.addSublayer(border)
	}
	
	func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
		let border = CALayer()
		border.backgroundColor = color.cgColor
		border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
		self.layer.addSublayer(border)
	}
}
