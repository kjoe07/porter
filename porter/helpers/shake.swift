//
//  shake.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 14/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
extension CALayer {
	func shake(duration: TimeInterval = TimeInterval(0.5)) {
		let animationKey = "shake"
		removeAnimation(forKey: animationKey)
		let kAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		kAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		kAnimation.duration = duration
		var needOffset = frame.width * 0.15,
		values = [CGFloat]()
		let minOffset = needOffset * 0.1
		repeat {
			values.append(-needOffset)
			values.append(needOffset)
			needOffset *= 0.5
		} while needOffset > minOffset
		values.append(0)
		kAnimation.values = values
		add(kAnimation, forKey: animationKey)
	}
}
