//
//  CurrentUser.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/11/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation

// MARK: CurrentUser

class CurrentUser {
	
	// MARK: Properties
	
	var key: String? = nil
	var isFacebookLogin: Bool = false
	var facebookToken: String? = nil
	var sessionId: String? = nil
	var firstName: String? = nil
	var lastName: String? = nil
	var locationString: String? = nil
	var sharedURL: String? = nil
	var latitude: String? = nil
	var longitude: String? = nil
	
	// MARK: Public Methods
	
	func clear() {
		key = nil
		sessionId = nil
		firstName = nil
		lastName = nil
		locationString = nil
		sharedURL = nil
		latitude = nil
		longitude = nil
	}
	
	// MARK: Shared Instance
	
	class func sharedInstance() -> CurrentUser {
		struct Singleton {
			static var sharedInstance = CurrentUser()			
		}
		
		return Singleton.sharedInstance
	}
}
