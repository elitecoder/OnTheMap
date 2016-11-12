//
//  Utility.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/9/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation

struct Utility {
	
	static func displayErrorAlert(inViewController: UIViewController, withMessage: String) {
		var alertController:UIAlertController?
		alertController = UIAlertController(title: "Error",
		                                    message: withMessage,
		                                    preferredStyle: .alert)

		let dismissAction = UIAlertAction(title: "Dismiss",
		                                  style: UIAlertActionStyle.default,
		                                  handler: nil
		)
		
		alertController!.addAction(dismissAction)
		
		inViewController.present(alertController!, animated: true, completion: nil)
	}
	
	// Obtain Error message from provided JSON
	static func obtainErrorMessage(_ data: Data)-> String {
		
		// Udacity response contains 5 chars in the beginning which needs to be stripped off before parsing.
		let validData = data.subdata(in: Range(uncheckedBounds: (lower: 5, upper: data.count))) /* subset response data! */
		
		var parsedResult: AnyObject!
		do {
			parsedResult = try JSONSerialization.jsonObject(with: validData, options: .allowFragments) as AnyObject
		} catch {
			return "Could not parse the data as JSON: '\(data)'"
		}
		
		if let result = parsedResult as! [String: AnyObject]? {
			return result["error"] as! String
		}
		
		return "Could not parse the data as JSON: '\(data)'"
	}
}
