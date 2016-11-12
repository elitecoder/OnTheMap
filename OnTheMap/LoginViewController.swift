//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mukul Sharma on 11/7/16.
//  Copyright © 2016 Mukul Sharma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
	@IBOutlet weak var stackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		emailTextField.text = "elitecoder.mukul@gmail.com"
		passwordTextField.text = "mukulsharma"
		
		facebookLoginButton.readPermissions = ["public_profile", "email"];
		facebookLoginButton.delegate = self
	}
	
	@IBAction func loginButtonPressed(_ sender: AnyObject) {
		authenticateWithUdacity()
	}
	
	func authenticateWithUdacity() {
		let client = UdacityClient.sharedInstance()
		
		client.authenticateWithCredentials(email: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
			
			if success {
				
				client.getPublicUserData() { (success, error) in
					if success {
						DispatchQueue.main.async {
							self.performSegue(withIdentifier: "TabBarSegue", sender: self)
						}
					}
					else {
						DispatchQueue.main.async {
							Utility.displayErrorAlert(inViewController: self, withMessage: error!)
						}
					}
				}
			}
			else {
				DispatchQueue.main.async {
					Utility.displayErrorAlert(inViewController: self, withMessage: error!)
				}
			}
		}
	}
	
	@IBAction func signUpForUdacityAccount(_ sender: AnyObject) {
		
		let signupURL = NSURL(string: "https://www.udacity.com/account/auth#!/signup") as! URL
		
		UIApplication.shared.open(signupURL, options: [:], completionHandler: nil)
	}
	
	// MARK: FBSDKLoginButtonDelegate Methods
	
	public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

		if ((FBSDKAccessToken.current()) != nil) {
			// User is logged in, do work such as go to next view controller.
			
			let token = FBSDKAccessToken.current()
			CurrentUser.sharedInstance().isFacebookLogin = true
			CurrentUser.sharedInstance().facebookToken = token!.tokenString
			
			authenticateWithUdacity()
		}
	}
	
	public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { }
}
