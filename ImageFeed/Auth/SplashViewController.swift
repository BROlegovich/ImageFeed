
import UIKit

class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()
    private let showLohinFlowSegueIdentifier = "ShowLoginFlow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatus()
//        if let token = oauth2TokenStorage.token {
//            switchToTabBarController()
//        } else {
//            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func checkAuthStatus() {
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
            
            fetchProfile { [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            showAuthController()
        }
    }
    
    private func showAuthController() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else {return}
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")}
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
            
        }
    }
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.fetchProfile(completion: {
                    UIBlockingProgressHUD.dismiss()
                })
            case .failure(let error):
                self.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void) {
        profileService.fetchProfile() { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let userProfile):
                self.profileImageService.fetchProfileImageURL(username: userProfile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                self.showLoginAlert(error: error)
            }
            completion()
        }
    }
    
    private func    showLoginAlert(error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так",
                                 message:"Не удалось войти в систему, \(error.localizedDescription)") {
            self.performSegue(withIdentifier: self.showLohinFlowSegueIdentifier, sender: nil)
        }
    }
}

