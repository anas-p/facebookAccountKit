# Facebook Account Kit using Swift

Account Kit helps people quickly and easily register and log into your app using their phone number or email address as passwordless credentials. Account Kit is powered by Facebook's email and SMS sending infrastructure for reliable scalable performance with global reach. Because it uses email and phone number authentication, Account Kit doesn't require a Facebook account and is the ideal alternative to a social login.

## 1. Select an App or Create a New App

Select an app or create a new one from [facebook developer account](https://developers.facebook.com/docs/accountkit/ios)

## 2. Choose Your App Settings

Choose whether to allow email and SMS login, and choose security settings for your app - [Choose your app settings](https://developers.facebook.com/apps/).

## 3. Set up Your Developer Environment

**Using Cocoapods:**
Make sure you have the [CocoaPods](https://cocoapods.org) gem installed on your machine before installing the [Account Kit](https://cocoapods.org/pods/AccountKit) pod.

```
$ sudo gem install cocoapods
$ pod init
```

Add the following to your Podfile:

```
pod 'AccountKit'
```

Run the following command in your project root directory from a terminal window:

```
$ pod install
```

Add both your **Facebook App ID** and **Account Kit Client Token** to your ```Info.plist``` file as strings. Make sure you have enabled Account Kit in the App Dashboard. You'll find the Account Kit client token in the Account Kit section of the App Dashboard. The application name will be used in the UI of the login screen.

```
<plist version="1.0">
<dict>
...
    <key>FacebookAppID</key>
    <string>{your-app-id}</string>
    <key>AccountKitClientToken</key>
    <string>{your-account-kit-client-token}</string>
    <key>CFBundleURLTypes</key>
    <array>
    <dict>
    <key>CFBundleURLSchemes</key>
    <array>
    <string>ak{your-app-id}</string>
    </array>
    </dict>
    </array>
...
</dict>
</plist>
```

Remember to fill in your app ID for both the FacebookAppID and CFBundleURLSchemes keys.

## 4. Configure Login View Controller

The delegate for your loginViewController must implement the AKFViewControllerDelegate protocol. All of the protocol methods are optional, but you should at least handle successful login callbacks for the login flows (SMS or Email) that you use in your app. Set up your main view controller to receive login callbacks:

```swift
import AccountKit

class LoginViewController: UIViewController, AKFViewControllerDelegate{
    //...
}
```

Prepare the Account Kit login view controller by setting a delegate as shown in the following code block.

```swift
func prepareLoginViewController(loginViewController: AKFViewController) {
    loginViewController.delegate = self
    //UI Theming - Optional
    loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: UIColor.blue)
}
```

## 5. Handle Different Login States

When your initial view controller appears, you should bypass the login view controller if the user is already logged in. It will also resume pending logins if any are present.

```swift
class LoginViewController: UIViewController, AKFViewControllerDelegate {
    var _accountKit: AKFAccountKit!
}
```

To initialize Account Kit, we recommend doing this in the viewDidLoad event of your view controller. The following code initializes Account Kit to use the token access flow:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // initialize Account Kit
    if _accountKit == nil {
    _accountKit = AKFAccountKit(responseType: .accessToken)
    }
}
```

If your app receives the user's access token directly (because the Enable Client Access Token Flow switch in your app's dashboard is ON), then you should check for a valid, existing token using accountKit?.currentAccessToken.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if _accountKit?.currentAccessToken != nil {
        // if the user is already logged in, go to the main screen
        // ...
    }
    else {
        // Show the login screen
    }
}
```

## 6. Initiate a Login Flow for SMS

In your initial view controller, create a phone login handler to invoke when the login button is clicked by the user. There are two important parameters shown in the code below:

```swift
func loginWithPhone(){
    let inputState = UUID().uuidString
    let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
    vc.enableSendToFacebook = true
    self.prepareLoginViewController(loginViewController: vc)
    self.present(vc as UIViewController, animated: true, completion: nil)
}
```

## 7. Initiate a Login Flow for Email

In your initial view controller, create an email login handler to invoke when the login button is clicked by the user. There are two important parameters shown in the code below:

```swift
func loginWithEmail() {
    let inputState = NSUUID().uuidString
    let vc = _accountKit!.viewControllerForEmailLogin(withEmail: nil, state: inputState)
    self.prepareLoginViewController(loginViewController: vc)
    self.present(vc as UIViewController, animated: true, completion: nil)
}
```

## 8. Handle Login Callback

To handle a successful login in Access Token mode:

```swift
func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
    print("did complete login with access token \(accessToken.tokenString) state \(state)")
    //...
}
```

To handle a successful login in Authorization Code mode:

```swift
func viewController(_ viewController: (UIViewController & AKFViewController)!,  didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
    //...
}
```

You may also handle a failed or canceled login:

```swift
func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
    // ... implement appropriate error handling ...
    print("\(viewController) did fail with error: \(error.localizedDescription)")
}

func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
    // ... handle user cancellation of the login process ...
}
```
## 9. Access Account Information

Once you have successfully logged in, you can access account information. For example, to display the account ID and the login credential used in access token mode:

```swift
if accountKit == nil {
    //specify AKFResponseType.AccessToken
    self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
    accountKit.requestAccount {
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
```

10. Provide the Logout Flow

You can invoke the logOut method to log a user out of Account Kit.

```swift
accountKit.logOut()
```

## Next Steps

- Customize the UI
- Configure Country Codes for SMS
- Customize Email Colors
