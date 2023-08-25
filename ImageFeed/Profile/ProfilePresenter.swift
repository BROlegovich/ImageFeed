

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var profileService: ProfileService { get }
    func updateProfile()
    func viewDidLoad()
    func showAlert() -> UIAlertController
    func observeAvatarChanges()
    func cleanAllService()
    func logOut()
}

final class ProfilePresenter: ProfilePresenterProtocol{
    
    
    var profileService = ProfileService.shared
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    func viewDidLoad() {
        updateProfile()
        observeAvatarChanges()
    }
    
    
    func updateProfile() {
        guard let profile = profileService.profile else {
            assertionFailure("Profile didn't found")
            return
        }
        
        view?.nameLabel.text = profile.username
        view?.loginLabel.text = profile.loginName
        view?.descriptionLabel.text = profile.bio
    }
    
    
    func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self ] notification in
            self?.view?.updateAvatar()
        }
    }
    
    func cleanAllService() {
        ProfileService.shared.cleanSession()
        ProfileImageService.shared.cleanSession()
        ImagesListService.shared.cleanSession()
        oAuth2TokenStorage.clearTokenKey()
        WebViewViewController.clean()
    }
    
    func switchToSplashViewController() {
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        tabBarController.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    func logOut() {
        cleanAllService()
        switchToSplashViewController()
    }
    
    func showAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Выход",
                                                message: "Вы уверены что хотите выйти?",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.logOut()
        }))
        alertController.addAction(UIAlertAction(title: "Нет", style: .default))
        alertController.dismiss(animated: true)
        return alertController
    }
}
