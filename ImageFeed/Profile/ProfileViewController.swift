
import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol { get set }
    var profileImage: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var loginLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    func updateAvatar()
    func layout()
    func showAlert()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    
    private let profileImageService = ProfileImageService.shared
    
    lazy var presenter: ProfilePresenterProtocol = {
        return ProfilePresenter()
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImage(named: "avatar")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var nameLabel:  UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor.ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        return loginLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor.ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()
    
    private var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(with: UIImage(named: "logoutButton")!, target: self, action: #selector(Self.didTapButton))
        logoutButton.tintColor = UIColor.ypRed
        return logoutButton
    }()
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor)])
    }
    
    
    @objc private func didTapButton(){
        showAlert()
    }
    
    
    func layout() {
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
        presenter.view = self
        presenter.viewDidLoad()
        updateAvatar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        presenter.view = self
        presenter.viewDidLoad()
        updateAvatar()
    }
}

extension ProfileViewController {
    
    func showAlert() {
        let alert = presenter.showAlert()
        present(alert, animated: true, completion: nil)
    }
}
