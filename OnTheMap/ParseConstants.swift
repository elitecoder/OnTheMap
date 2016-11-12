//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/8/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation

// MARK: - ParseClient (Constants)

extension ParseClient {
	
	// MARK: Constants
	struct Constants {
		
		// MARK: API Key
		static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
		static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
		
		// MARK: URLs
		static let ApiScheme = "https"
		static let ApiHost = "parse.udacity.com"
		static let ApiPath = "/parse/classes"
	}
	
	// MARK: Methods
	struct Methods {
		
		// MARK: Authentication		
		static let StudentLocation = "/StudentLocation"
	}
	
	// MARK: HTTP Header Fields
	struct HeaderFields {
		static let ApplicationID = "X-Parse-Application-Id"
		static let RestAPIKey = "X-Parse-REST-API-Key"
	}
	
	// MARK: Parameter Keys
	struct QueryStringKeys {
		static let Limit = "limit"
		static let Skip = "skip"
		static let Order = "order"
		static let Where = "where"
	}
	
	// MARK: Parameter Values
	struct QueryStringValues {
		static let Descending = "-updatedAt"
	}
	
	// MARK: JSON Response Keys
	struct JSONResponseKeys {
		
		// MARK: Authorization
		static let Results = "results"
		static let Latitude = "latitude"
		static let Longitude = "longitude"
		static let FirstName = "firstName"
		static let LastName = "lastName"
		static let MediaURL = "mediaURL"
		static let ObjectID = "objectId"
		static let UpdatedAt = "updatedAt"
	}
}
