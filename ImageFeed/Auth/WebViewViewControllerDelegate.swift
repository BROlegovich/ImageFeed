import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    
    func ViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func ViewViewControllerDidCancel(_ vc: WebViewViewController)
}
