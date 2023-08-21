
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileImage: UIImageView = {
        let image = UIImage(named: "avatar")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private var nameLabel:  UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor.ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        return loginLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor.ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()
    
    private var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(with: UIImage(named: "logoutButton")!, target: ProfileViewController.self, action: #selector(clickLogoutButton(_:)))
        logoutButton.tintColor = UIColor.ypRed
        return logoutButton
    }()
    
    private func updateProfile() {
        guard let profile = profileService.profile else {
            assertionFailure("Profile didn't found")
            return
        }
        
        nameLabel.text = profile.username
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor)])
    }
    
    
    @IBAction private func clickLogoutButton(_ sender: UIButton) {
    }
    
    private func layout() {
        var subviews = [profileImage, nameLabel, loginLabel, descriptionLabel, logoutButton]
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfile()
        updateAvatar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        updateProfile()
        updateAvatar()
        
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self ] notification in
            self?.updateAvatar()
        }
        updateAvatar()
    }
}
