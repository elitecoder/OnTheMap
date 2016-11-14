//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/8/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {

	// MARK: Public Methods
	
	func getPublicUserData(_ completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		/* 1. Make the request */
		let url = Methods.Users + "/\(CurrentUser.sharedInstance().key!)"
		
		_ = taskForGETMethod(url) { (results, error) in
			
			/* 2. Send the desired value(s) to completion handler */
			if let error = error {
				print(error)
				completionHandler(false, error.userInfo["NSLocalizedDescription"] as! String?)
			} else {
				
				guard let user = results?[JSONResponseKeys.User] as! [String: AnyObject]? else {
					print("Could not find \(JSONResponseKeys.User) in \(results)")
					completionHandler(false, "User Data retrieval failed.")
					return
				}
				
				if let firstName = user[JSONResponseKeys.FirstName] as! String? {
					CurrentUser.sharedInstance().firstName = firstName
					completionHandler(true, nil)
				} else {
					print("Could not find \(JSONResponseKeys.FirstName) in \(user)")
					completionHandler(false, "User Data retrieval failed.")
				}
				
				if let lastName = user[JSONResponseKeys.LastName] as! String? {
					CurrentUser.sharedInstance().lastName = lastName
					completionHandler(true, nil)
				} else {
					print("Could not find \(JSONResponseKeys.LastName) in \(user)")
					completionHandler(false, "User Data retrieval failed.")
				}
			}
		}
	}

	func authenticateWithCredentials(email: String, password: String, _ completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		/* 1. Specify HTTP body (if POST) */
		
		var jsonBody: String
		if CurrentUser.sharedInstance().isFacebookLogin {
			jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(CurrentUser.sharedInstance().facebookToken!)\"}}"
		}
		else {
			jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
		}
		
		/* 2. Make the request */
		_ = taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) { (results, error) in
			
			/* 3. Send the desired value(s) to completion handler */
			if let error = error {
				print(error)
				completionHandler(false, error.userInfo["NSLocalizedDescription"] as! String?)
			} else {
				
				guard let account = results?[JSONResponseKeys.Account] as! [String: AnyObject]? else {
					print("Could not find \(JSONResponseKeys.Account) in \(results)")
					completionHandler(false, "Login Failed.")
					return
				}
				
				if let key = account[JSONResponseKeys.Key] as! String? {
					CurrentUser.sharedInstance().key = key
				} else {
					print("Could not find \(JSONResponseKeys.Key) in \(account)")
					completionHandler(false, "Login Failed.")
				}
				
				guard let session = results?[JSONResponseKeys.Session] as! [String: String]? else {
					print("Could not find \(JSONResponseKeys.Session) in \(results)")
					completionHandler(false, "Login Failed.")
					return
				}
				
				if let id = session[JSONResponseKeys.ID]! as String? {
					CurrentUser.sharedInstance().sessionId = id
					completionHandler(true, nil)
				} else {
					print("Could not find \(JSONResponseKeys.ID) in \(session)")
					completionHandler(false, "Login Failed.")
				}
			}
		}
	}
	
	func logout(_ completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		/* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
		var requestValues = [String:AnyObject]()
		
		var xsrfCookie: HTTPCookie? = nil
		let sharedCookieStorage = HTTPCookieStorage.shared
		for cookie in sharedCookieStorage.cookies! {
			if cookie.name == Cookies.XSRFToken { xsrfCookie = cookie }
		}
		
		if let xsrfCookie = xsrfCookie {
			requestValues[Cookies.X_XSRFToken] = xsrfCookie.value as AnyObject?
		}
		
		/* 2. Make the request */
		_ = taskForDELETEMethod(Methods.Session, requestValues: requestValues) { (results, error) in
			
			/* 3. Send the desired value(s) to completion handler */
			if let error = error {
				print(error)
				completionHandler(false, error.userInfo["NSLocalizedDescription"] as! String?)
			} else {
				
				guard let session = results?[JSONResponseKeys.Session] as! [String: String]? else {
					print("Could not find \(JSONResponseKeys.Session) in \(results)")
					completionHandler(false, "Logout Failed.")
					return
				}
				
				if (session[JSONResponseKeys.ID]! as String?) != nil {
					CurrentUser.sharedInstance().clear() // Logout complete
					completionHandler(true, nil)
				} else {
					print("Could not find \(JSONResponseKeys.ID) in \(session)")
					completionHandler(false, "Logout Failed.")
				}
			}
		}
	}
}
