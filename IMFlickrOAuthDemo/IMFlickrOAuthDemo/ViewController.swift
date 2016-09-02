/**
 * Copyright (c) 2016 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import IMFlickrOAuth

private let kFlickrApplicationKey = "9e42bee98f9d8d12c26072b9793b3562"
private let kFlickrApplicationSecret = "2698f58d09b06c20"
private let kFlickrOAuthCallbackURL = "imflickr-oauth://oauth-callback/flickr"

class ViewController: UIViewController {
    
    @IBAction func doFlickrAuthButtonDidPressed(sender: UIButton) {
        let oauth = IMFlickrOAuth(
            consumerKey: kFlickrApplicationKey,
            consumerSecret: kFlickrApplicationSecret,
            callbackURL: kFlickrOAuthCallbackURL
        )
        
        oauth.authorizeWithPermission(.Read) { result in
            switch result {
            case .Success(let token, let tokenSecret, let user):
                print("TOKEN: \(token)\nTOKEN_SECRET: \(tokenSecret)\nUSER: \(user)")
            case .Failure(let error):
                print("Failed to auth with error: \(error.localizedDescription)")
            }
        }
    }
    
}

