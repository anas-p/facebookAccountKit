//
//  DetailsViewController.swift
//  FB AccountKit
//
//  Created by 🅐🅝🅐🅢 on 12/05/18.
//  Copyright © 2018 nfnlabs. All rights reserved.
//

import UIKit
import AccountKit

class MainViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var lblAccountId: UILabel!
    @IBOutlet weak var lblEmailOrPhone: UILabel!
    
    //MARK: - Variable
    var accountKit: AKFAccountKit!

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize Account Kit
        if accountKit == nil {
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                if let accountID = account?.accountID{
                    self.lblAccountId.text = accountID
                }
                if let email = account?.emailAddress {
                    self.lblEmailOrPhone.text = email
                }
                else if let phoneNumber = account?.phoneNumber{
                    self.lblEmailOrPhone.text = phoneNumber.stringRepresentation()
                }
            }
        }
    }

    //MARK: - Actions
    @IBAction func btnLogoutOnClick(_ sender: UIButton) {
        accountKit.logOut()
        dismiss(animated: true, completion: nil)
    }

}
