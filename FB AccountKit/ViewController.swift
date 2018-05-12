//
//  ViewController.swift
//  FB AccountKit
//
//  Created by 🅐🅝🅐🅢 on 12/05/18.
//  Copyright © 2018 nfnlabs. All rights reserved.
//

import UIKit
import AccountKit



class LoginViewController: UIViewController {

    var _accountKit: AKFAccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize Account Kit
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if _accountKit?.currentAccessToken != nil{
            // if the user is already logged in, go to the main screen
            print("Already Logged in")
        }
    }
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
    }
    
    func loginWithEmail() {
        let inputState = NSUUID().uuidString
        let vc: AKFViewController = _accountKit!.viewControllerForEmailLogin(withEmail: nil, state: inputState) as AKFViewController
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as! UIViewController, animated: true, completion: nil)
    }
    
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc: AKFViewController = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as! UIViewController, animated: true, completion: nil)
    }
    
    func successfullyLoggedIn(){
        _accountKit?.requestAccount({ (account:AKFAccount?, error:Error?) in
            //account ID
            if let accountID = account?.accountID{
                print(accountID)
            }
            if let email = account?.emailAddress {
                print(email)
            }
            if let phoneNumber = account?.phoneNumber{
                print(phoneNumber.stringRepresentation())
            }
        })
    }
    
    func logout(){
        _accountKit?.logOut()
    }

}

extension LoginViewController: AKFViewControllerDelegate {
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(state)")
    }
    
    // handle callback on successful login to show authorization code
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        // Pass the code to your own server and have your server exchange it for a user access token.
        // You should wait until you receive a response from your server before proceeding to the main screen.
        
        /*
         [self sendAuthorizationCodeToServer:code];
         [self proceedToMainScreen];
         */
        self.successfullyLoggedIn()
        print("didCompleteLoginWithAuthorizationCode")
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
         // ... handle user cancellation of the login process ...
        print("viewControllerDidCancel")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(viewController) did fail with error: \(error.localizedDescription)")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("didCompleteLoginWith")
    }
}
