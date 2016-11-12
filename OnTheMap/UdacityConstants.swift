//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/8/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
	
	// MARK: Constants
	struct Constants {
				
		// MARK: URLs
		static let ApiScheme = "https"
		static let ApiHost = "www.udacity.com"
		static let ApiPath = "/api"
	}
	
	// MARK: Methods
	struct Methods {
		
		// MARK: Authentication
		static let Session = "/session"
		
		// MARK: Public Data
		static let Users = "/users"
	}
	
	// MARK: JSON Response Keys
	struct JSONResponseKeys {
		
		// MARK: Authorization
		static let Account = "account"
		static let Key = "key"
		static let Session = "session"
		static let ID = "id"
		
		// MARK: Public User Data
		static let User = "user"
		static let FirstName = "first_name"
		static let LastName = "last_name"
	}
	
	// MARK: Cookies
	struct Cookies {
		
		// MARK: Cookie Names		
		static let X_XSRFToken = "X-XSRF-TOKEN"
		static let XSRFToken = "XSRF-TOKEN"
	}
}
