import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
    }
    
    override func viewDidLoad() {
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
}
