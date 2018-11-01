//
//  router.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 14/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
import Alamofire
enum Router: URLRequestConvertible {
	case login(params: Parameters)
	case updateToken(params: Parameters)
	case register(params: Parameters)
	case changePassword(params: Parameters)
	case passwordReset(params: Parameters)
	case deleteAcount()
	case loginProvider(params: Parameters)
	case setProfile(params: Parameters)
	case getProfile()
	case getProfileById(id: String)
	case distance(params: Parameters)
	case setService(params: Parameters)
	case updateService(params: Parameters)
	case getServiceByuser()
	case getAllServiceByUser()	
	case deleteService(id: String)
	case simulate(params: Parameters)
	case evaluateWorker(params: Parameters)
	case createCardToken(params: Parameters)
	case getDistance(params: Parameters)
	case indexCards()
	case charge(params: Parameters)
	case setDefaultCard(params: Parameters)
	case getChargeByUser(params: Parameters)
	case deleteCard(params: Parameters)
	case avaibleHours(params: Parameters)
	case getActive()
    case getServiceBy(id: String)
	static let baseURLString = "https://apporter.herokuapp.com/api"//"http://192.168.1.251/api"//
	static var isLocal: Bool{
		get{
			return baseURLString == "http://192.168.1.251/api"
		}
	}
	var method: HTTPMethod {
		switch self {		case .login,.loginProvider,.register, .changePassword,.deleteAcount,.passwordReset, .distance, .setService,.simulate,.createCardToken,.evaluateWorker,.getDistance, .indexCards, .charge,.setDefaultCard,.getChargeByUser,.deleteCard,.avaibleHours, .updateToken:
			return .post
		case .getProfile, .getProfileById,.getServiceByuser,.getAllServiceByUser,.getActive,.getServiceBy:
			return .get
		case .setProfile,.updateService:
			return .put
		case .deleteService:
			return .delete
		}
	}
	
	var path: String {
		switch self {
		case .updateToken:
			return "/profile/updatePhoneToken"
		case .login:
			return "/auth/login"
		case .register:
			return "/auth/register"
		case .changePassword:
			return "/auth/changePassword"
		case .loginProvider:
			return "/socialauth/login"
		case .passwordReset:
			return "/auth/hardResetPassword"
		case .distance:
			return "/googlemaps/distance"
		case .getProfile:
			return "/profile/getByUser"
		case .setProfile:
			return "/profile"
		case .getProfileById(let id):
			return "/profile/\(id)"
		case .deleteAcount:
			return "/auth/drop"
		case .setService,.updateService:
			return "/service"
		case .deleteService(let id):
			return "/service/\(id)"
		case .getServiceByuser:
			return "/service/getByUser"
		case .getAllServiceByUser:
			return "/service/getAllByUser"
		case .simulate:
			return "/service/simulate"
		case .createCardToken:
			return "/payment/createCard"
		case .evaluateWorker:
			return "/evaluatedWorker"
		case .getDistance:
			return "/googlemaps/distance"
		case .indexCards:
			return "/payment/indexCard"
		case .charge:
			return "/payment/charge"
		case .setDefaultCard:
			return "/payment/setCardToDefault"
		case .getChargeByUser:
			return "/payment/chargeByUser"
		case .deleteCard:
			return "/payment/deleteCard"
		case .avaibleHours:
			return "/availability/getAvailableHours"
		case .getActive:
			return "service/getActive"
        case .getServiceBy(let id):
            return "/service/\(id)"
		}
	}
	
	// MARK: URLRequestConvertible
	
	func asURLRequest() throws -> URLRequest {
		let url = try Router.baseURLString.asURL()
		
		var urlRequest = URLRequest(url: url.appendingPathComponent(path))
		urlRequest.httpMethod = method.rawValue
		if let token = requestManager.instance.token{
			let tokenString = "Bearer \(token)"
			//print("el valor del token = \(tokenString)")
//			urlRequest.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>) //HTTPHeaderField.authentication.rawValue
			urlRequest.setValue(tokenString, forHTTPHeaderField: "Authorization")
		}
		switch self {
		case .changePassword(let params), .login(let params),.register(let params), .passwordReset(let params),.loginProvider(let params),.setProfile(let params),.setService(let params),.simulate(let params),.createCardToken(let params),.getDistance(let params),.charge(let params),.setDefaultCard(let params), .deleteCard(let params),.updateService(let params),.avaibleHours(let params), .updateToken(let params),.evaluateWorker(let params):
			urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
		
		default:
			break
		}
		//print("the request is \(urlRequest)")
		return urlRequest
	}
}
