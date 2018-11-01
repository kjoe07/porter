//
//  dateExtension.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 26/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
import UIKit

enum DateFormat : String {
	///format: MMMM yyyy -> October 2018
	case MMMMyyyy = "MMMM yyyy"
	///format: EEEE dd MMMM -> October 2018
	case EEEEddMMMM = "EEEE dd MMMM"
	///format: yyyy-MM -> 2018 08
	case yyyy_MM = "yyyy-MM"
	///format: MMM -> Oct
	case MMM = "MMM"
	///format: dd/MM/yyyy -> 24/05/2018
	case ddMMyyyy = "dd/MM/yyyy"
	///format: yyyy-MM-ddTHH:mm:ss -> 2018-05-22T00:00:00
	case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
	///format: "EEEE, MMMM dd, yyyy" -> Monday, June 03, 2018
	case EEEEMMMMddyyyy = "EEEE, MMMM dd, yyyy"
	
	case ddMMyyyyHHmmss = "ddMMyyyyHHmmss"
	
	///format: dd/MM/yyyy -> 24/05/2018
	case ddMMyyHHmmss = "dd/MM/yy HH:mm:ss"
	///format: dd/MM/yyyy -> 24/05/2018
	case dd = "dd"
	
	case short = "short"
	
	case medium = "medium"
	case yyyyMMdd = "yyyy-MM-dd"
	case dOfMMofYYYY = "dd 'de' MMMM 'de' yyyy"
	
	case hhmmss = "HH:mm:ss"
}

extension Date {
	
	static func parse(dateString:String,dateFormat:DateFormat) ->Date? {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat.rawValue
		return dateFormatter.date(from: dateString)
	}
	
	func string(dateFormat:DateFormat) ->String? {
		
		let dateFormatter = DateFormatter()
		if(dateFormat == .short || dateFormat == .medium) {
			if(dateFormat == .short) {
				dateFormatter.dateStyle = .short
			}
			if(dateFormat == .medium) {
				dateFormatter.dateStyle = .medium
			}
			return dateFormatter.string(from: self)
		}else {
			dateFormatter.dateFormat = dateFormat.rawValue
		}
		return dateFormatter.string(from: self)
		
	}
	
	var isInThePast: Bool {
		return self.timeIntervalSinceNow < 0 && !isToday()
	}
	
	func isToday() ->Bool {
		return Calendar.current.isDateInToday(self)
	}
	
	func isTomorrow() ->Bool {
		return Calendar.current.isDateInTomorrow(self)
	}
	
	func isThisWeek() ->Bool {
		
		var interval = TimeInterval(0)
		var startOfThisWeek: Date = Date()
		if !Calendar.current.dateInterval(of: .weekOfMonth, start: &startOfThisWeek, interval: &interval, for: Date()) {
			fatalError("Can't calculate start of this week")
		}
		let startOfNextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startOfThisWeek)!
		
		if startOfThisWeek <= self && self < startOfNextWeek {
			return true
		}
		return false
	}
	
	func isAfterThisWeek() ->Bool {
		var interval = TimeInterval(0)
		var startOfThisWeek: Date = Date()
		if !Calendar.current.dateInterval(of: .weekOfMonth, start: &startOfThisWeek, interval: &interval, for: Date()) {
			fatalError("Can't calculate start of this week")
		}
		let startOfNextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startOfThisWeek)!
		if self > startOfNextWeek {
			debugPrint("IS IN FUTURE")
			return true
		}
		return false
	}
	
	static func firstDayOfMonth(date:Date) ->Date {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.year,.month], from: date)
		return calendar.date(from: components)!
	}
	
	static func lastDayOfMonth(date:Date) ->Date {
		let calendar = Calendar.current
		let comps2 = NSDateComponents()
		comps2.month = 1
		comps2.day = -1
		let endOfMonth = calendar.date(byAdding: comps2 as DateComponents, to: Date.firstDayOfMonth(date: date))
		return endOfMonth!
	}
	
}
extension Date {
	var millisecondsSince1970:Int {
		return Int((self.timeIntervalSince1970 * 1000.0).rounded())
	}
	
	init(milliseconds:Int) {
		self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
	}
}
