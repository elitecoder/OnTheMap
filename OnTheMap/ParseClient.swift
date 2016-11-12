//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/8/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import Foundation

// MARK: - ParseClient: NSObject

class ParseClient {
	
	// MARK: Properties
	
	// shared session
	var session = URLSession.shared
	var overwriteObjectId: String? = nil
	
	// MARK: GET
	
	func taskForGETMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* Build the URL, Configure the request */
		let request = NSMutableURLRequest(url: parseURL(withPathExtension: method, parameters: parameters))
		request.httpMethod = "GET"
		request.addValue(Constants.ApplicationID, forHTTPHeaderField: HeaderFields.ApplicationID)
		request.addValue(Constants.RestAPIKey, forHTTPHeaderField: HeaderFields.RestAPIKey)
		
		/* Make the request */
		let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error)")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* Parse the data and use the data (happens in completion handler) */
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
		})
		
		/* Start the request */
		task.resume()
		
		return task
	}
	
	// MARK: PUT
	
	func taskForPUTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* Build the URL, Configure the request */
		let methodForPUT = method + "/\(overwriteObjectId!)"
		let request = NSMutableURLRequest(url: parseURL(withPathExtension: methodForPUT, parameters: [:]))
		request.httpMethod = "PUT"
		request.addValue(Constants.ApplicationID, forHTTPHeaderField: HeaderFields.ApplicationID)
		request.addValue(Constants.RestAPIKey, forHTTPHeaderField: HeaderFields.RestAPIKey)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonBody.data(using: String.Encoding.utf8)
		
		/* Make the request */
		let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForPOST(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error)")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* Parse the data and use the data (happens in completion handler) */
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
		})
		
		/* Start the request */
		task.resume()
		
		return task
	}
	
	// MARK: POST
	
	func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* Build the URL, Configure the request */
		let request = NSMutableURLRequest(url: parseURL(withPathExtension: method, parameters: [:]))
		request.httpMethod = "POST"
		request.addValue(Constants.ApplicationID, forHTTPHeaderField: HeaderFields.ApplicationID)
		request.addValue(Constants.RestAPIKey, forHTTPHeaderField: HeaderFields.RestAPIKey)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonBody.data(using: String.Encoding.utf8)
		
		/* Make the request */
		let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error)")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* Parse the data and use the data (happens in completion handler) */
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
		})
		
		/* Start the request */
		task.resume()
		
		return task
	}
	
	// given raw JSON, return a usable Foundation object
	fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		
		var parsedResult: AnyObject!
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}
		
		completionHandlerForConvertData(parsedResult, nil)
	}
	
	// create a URL from parameters
	fileprivate func parseURL(withPathExtension: String? = nil, parameters: [String: AnyObject]) -> URL {
		
		var components = URLComponents()
		components.scheme = Constants.ApiScheme
		components.host = Constants.ApiHost
		components.path = Constants.ApiPath + (withPathExtension ?? "")
		components.queryItems = [URLQueryItem]()
		
		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}
		
		return components.url!
	}
	
	// MARK: Shared Instance
	
	class func sharedInstance() -> ParseClient {
		struct Singleton {
			static var sharedInstance = ParseClient()
		}
		return Singleton.sharedInstance
	}
	
}
