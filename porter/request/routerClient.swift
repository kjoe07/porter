//
//  routerClient.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 14/7/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
import Alamofire
class routeClient {
	static let instance = routeClient()
	//MARK: - Auth
	func login(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.login(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func register(params: Parameters, success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.register(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func login(provider params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.loginProvider(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func changePassword(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.changePassword(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func updateToken(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.updateToken(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func resetpassword(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error) ->()){
		myRequest(url: Router.passwordReset(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	//MARK: - Profile
	func setProfile(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.setProfile(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func getProfile(success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getProfile(), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func getProfile(by id: String,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getProfileById(id: id), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	//MARK: - services
	func setServices(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.setService(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func simulate(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.simulate(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func updateService(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.updateService(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func deleteService(id: String,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.deleteService(id: id), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func getServiceByuser(success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getServiceByuser(), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func getAllServicesByUser(success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getAllServiceByUser(), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
    func getService(by id: String,success: @escaping (_ response: Data)-> (), failure: @escaping (_ error: Error)-> ()){
        myRequest(url: Router.getServiceBy(id: id), success: {data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
	func getActive(success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getActive(), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	//MARK: - evaluate Porter
	func evaluateWorker(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.evaluateWorker(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	//MARK: - getDistance
	func getDistance(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getDistance(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	//MARK: - Payments
	func createCardToken(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.createCardToken(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func indexCard(success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.indexCards(), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func charge(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.charge(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func setDefaultCard(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.setDefaultCard(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func getChargesByUser(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.getChargeByUser(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func deleteCard(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.deleteCard(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	func avaibleHours(params: Parameters,success:@escaping (_ response : Data)->(), failure : @escaping (_ error : Error)->()){
		myRequest(url: Router.avaibleHours(params: params), success: {data in
			success(data)
		}, failure: {error in
			failure(error)
		})
	}
	private var Manager : Alamofire.SessionManager = {
		// Create the server trust policies
		let serverTrustPolicies: [String: ServerTrustPolicy] = [ "apporter.herokuapp.com": .disableEvaluation]
		// Create custom manager
		let configuration = URLSessionConfiguration.default
		configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
		let man = Alamofire.SessionManager(
			configuration: URLSessionConfiguration.default,
			serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
		)
		return man
	}()
	//MARK: -the Request -
	func myRequest(url: URLRequestConvertible,success:@escaping (_ response : Data)->(), failure: @escaping(_ error : Error)->()){
		let c = Manager.request(url).responseJSON { (response) in
			print("the response value of \(String(describing: url.urlRequest)) \(response)")
			switch response.result {
			case .success:
				if let data = response.data {
					success(data)
				}
			case .failure(let error):
				failure(error)
			}
		}
		print("response \(c.debugDescription)")
	}	
}
