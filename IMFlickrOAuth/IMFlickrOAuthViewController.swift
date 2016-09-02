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

// MARK: Typealiases

typealias IMFlickrOAuthViewControllerSuccessCompletionHandler = (URL: NSURL) -> Void
typealias IMFlickrOAuthViewControllerFailureCompletionHandler = (error: NSError) -> Void

// MARK: - IMFlickrOAuthViewController: UIViewController

class IMFlickrOAuthViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var webView: UIWebView = {
        return UIWebView()
    }()
    
    private var authorizationURL: String!
    private var callbackURL: String!
    
    private var successBlock: IMFlickrOAuthViewControllerSuccessCompletionHandler!
    private var failureBlock: IMFlickrOAuthViewControllerFailureCompletionHandler!
    
    // MARK: Init
    
    init(authorizationURL: String, callbackURL: String) {
        self.authorizationURL = authorizationURL
        self.callbackURL = callbackURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - IMFlickrOAuthViewController (Public API) -

extension IMFlickrOAuthViewController {
    
    func authorize(success success: IMFlickrOAuthViewControllerSuccessCompletionHandler, failure: IMFlickrOAuthViewControllerFailureCompletionHandler) {
        successBlock = success
        failureBlock = failure
        
        guard let rootViewController = UIUtils.rootViewController() else {
            return assertionFailure("Root view controller must exist.")
        }
        
        let navigationController = UINavigationController(rootViewController: self)
        rootViewController.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - IMFlickrOAuthViewController (Configure) -

extension IMFlickrOAuthViewController {
    
    private func setup() {
        title = "Flickr"
        
        webView.delegate = self
        webView.frame = view.bounds
        webView.backgroundColor = .whiteColor()
        webView.scalesPageToFit = true
        webView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .FlexibleWidth, .FlexibleHeight)
        view.addSubview(webView)
        
        let request = NSURLRequest(URL: NSURL(string: authorizationURL)!)
        webView.loadRequest(request)
        
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self,
                                                action: #selector(dismiss))
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
}

// MARK: - IMFlickrOAuthViewController: UIWebViewDelegate -

extension IMFlickrOAuthViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let callback = NSURL(string: callbackURL)!
        
        if request.URL!.host == callback.host {
            successBlock(URL: request.URL!)
            dismiss()
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIUtils.showNetworkIndicator()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIUtils.hideNetworkIndicator()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        guard let error = error else {
            let error = NSError(
                domain: "IMFlickrOAuth.IMFlickrOAuthViewController",
                code: 66,
                userInfo: [NSLocalizedDescriptionKey : "Failed promts for a user authorization."]
            )
            return failureBlock(error: error)
        }
        
        failureBlock(error: error)
    }
    
}
