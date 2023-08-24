import UIKit
import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!
    var presenter: WebViewPresenterProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.webViewLoad()
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [], changeHandler: {[weak self] _, _ in
            guard let self = self else { return }
            self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
        })
    }
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
