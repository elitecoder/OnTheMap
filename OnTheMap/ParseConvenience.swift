//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/8/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation

// MARK: - ParseClient (Convenient Resource Methods)

extension ParseClient {
	
	// MARK: Parse API Methods

	func getAllLocations(withLimit: Int, andSkip: Int, completionHandlerForStudentLocations: @escaping (_ success: Bool,_ studentLocations: [StudentLocation]?, _ error: String?) -> Void) {
		
		getLocations(limit: withLimit, skip: andSkip) { (success, studentLocations, error) in
			
			if success {
				completionHandlerForStudentLocations(success, studentLocations, error)
			} else {
				completionHandlerForStudentLocations(success, nil, error)
			}
		}
	}
	
	func getCurrentUserLocations(completionHandlerForStudentLocations: @escaping (_ success: Bool,_ studentLocations: [StudentLocation]?, _ error: String?) -> Void) {
		
		getUserLocations() { (success, locations, error) in
			if success {
				completionHandlerForStudentLocations(success, locations, error)
			} else {
				completionHandlerForStudentLocations(success, nil, error)
			}
		}
	}

	func postStudentLocation(_ completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		/* 1. Specify request Body */
		let user = CurrentUser.sharedInstance()
		let jsonBody = "{\"uniqueKey\": \"\(user.key!)\", \"firstName\": \"\(user.firstName!)\", \"lastName\": \"\(user.lastName!)\",\"mapString\": \"\(user.locationString!)\", \"mediaURL\": \"\(user.sharedURL!)\",\"latitude\": \(user.latitude!), \"longitude\": \(user.longitude!)}"
		
		if let _ = overwriteObjectId {

			/* 2. Make the request */
			_ = taskForPUTMethod(Methods.StudentLocation, jsonBody: jsonBody) { (result, error) in
				
				/* 3. Send the desired value(s) to completion handler */
				if let error = error {
					print(error)
					completionHandler(false, error.userInfo["NSLocalizedDescription"] as? String)
				} else {
					
					guard let _ = result?[JSONResponseKeys.UpdatedAt] as! String? else {
						print("Could not find \(JSONResponseKeys.UpdatedAt) in \(result)")
						completionHandler(false, "Posting Student Location failed.")
						return
					}
					
					completionHandler(true, nil)
				}
			}
		}
		else {
			/* 2. Make the request */
			_ = taskForPOSTMethod(Methods.StudentLocation, jsonBody: jsonBody) { (result, error) in

				/* 3. Send the desired value(s) to completion handler */
				if let error = error {
					print(error)
					completionHandler(false, error.userInfo["NSLocalizedDescription"] as? String)
				} else {
					
					guard let _ = result?[JSONResponseKeys.ObjectID] as! String? else {
						print("Could not find \(JSONResponseKeys.ObjectID) in \(result)")
						completionHandler(false, "Posting Student Location failed.")
						return
					}
					
					completionHandler(true, nil)
				}
			}
		}
		
	}
	
	// MARK: Internal Helper Methods
	
	fileprivate func getLocations(limit: Int, skip: Int, _ completionHandler: @escaping (_ success: Bool, _ studentLocations: [StudentLocation]?, _ error: String?) -> Void) {
		
		/* 1. Specify query string parameters */
		var queryStringParameters = [String:AnyObject]()
		queryStringParameters[QueryStringKeys.Limit] = limit as AnyObject?
		queryStringParameters[QueryStringKeys.Skip] = skip as AnyObject?
		
		/* 2. Make the request */
		_ = taskForGETMethod(Methods.StudentLocation, parameters: queryStringParameters) { (result, error) in
			
			/* 3. Send the desired value(s) to completion handler */
			if let error = error {
				print(error)
				completionHandler(false, nil, error.userInfo["NSLocalizedDescription"] as? String)
			} else {
				
				guard let results = result?[JSONResponseKeys.Results] as! [Dictionary<String, AnyObject>]? else {
					print("Could not find \(JSONResponseKeys.Results) in \(result)")
					completionHandler(false, nil, "Getting Student Locations failed.")
					return
				}
				
				var locations = [StudentLocation]()
				
				for dictionary: [String: AnyObject] in results {
					guard let location = StudentLocation.init(dictionary: dictionary) else {
						continue
					}
					
					locations.append(location)
				}
				
				completionHandler(true, locations, nil)
			}
		}
	}
	
	fileprivate func getUserLocations(_ completionHandler: @escaping (_ success: Bool, _ studentLocations: [StudentLocation]?, _ error: String?) -> Void) {
		
		/* 1. Specify query string parameters */
		var queryStringParameters = [String:AnyObject]()
		queryStringParameters[QueryStringKeys.Where] = "{\"uniqueKey\":\"\(CurrentUser.sharedInstance().key!)\"}" as AnyObject?
		
		/* 2. Make the request */
		_ = taskForGETMethod(Methods.StudentLocation, parameters: queryStringParameters) { (result, error) in
			
			/* 3. Send the desired value(s) to completion handler */
			if let error = error {
				print(error)
				completionHandler(false, nil, error.userInfo["NSLocalizedDescription"] as? String)
			} else {
				
				guard let results = result?[JSONResponseKeys.Results] as! [Dictionary<String, AnyObject>]? else {
					print("Could not find \(JSONResponseKeys.Results) in \(result)")
					completionHandler(false, nil, "Getting Student Locations failed.")
					return
				}
				
				var locations = [StudentLocation]()
				
				for dictionary: [String: AnyObject] in results {
					guard let location = StudentLocation.init(dictionary: dictionary) else {
						continue
					}
					
					locations.append(location)
				}
				
				completionHandler(true, locations, nil)
			}
		}
	}
}

