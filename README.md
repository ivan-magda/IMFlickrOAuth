# IMFlickrOAuth

Flickr OAuth library.

## Installation

IMFlickrOAuth is packaged as a Cocoa Touch framework. Currently this is the simplest way to add it to your app:

* Drag IMFlickrOAuth.xcodeproj to your project in the Project Navigator.
* Select your project and then your app target. Open the Build Phases panel.
* Expand the Target Dependencies group, and add IMFlickrOAuth framework.
* import IMFlickrOAuth whenever you want to use IMFlickrOAuth.

## Examples

```swift
let oauth = IMFlickrOAuth(
            consumerKey:    "********",
            consumerSecret: "********",
            callbackURL:    "flickr-oauth://oauth-callback/flickr"
)
        
oauth.authorizeWithPermission(.Read) { result in
            switch result {
            case .Success(let token, let tokenSecret, let user):
                print("TOKEN: \(token)")
                print("TOKEN_SECRET: \(tokenSecret)")
                print("USER: \(user)")
            case .Failure(let error):
                print(error.localizedDescription)
            }
}
```

See demo project for more examples

## OAuth provider page

* [Flickr](https://www.flickr.com/services/api/auth.oauth.html)  

## License

IMFlickrOAuth is available under the MIT license. See the LICENSE file for more info.
