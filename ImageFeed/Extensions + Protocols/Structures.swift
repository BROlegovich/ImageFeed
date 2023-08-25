
import Foundation


struct UserResult: Decodable {
    let profileImage: ImageURL?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageURL: Decodable {
    let small: String?
}

public struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    enum codingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let width: Int?
    let height: Int?
    let urls: UrlsResult?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case width = "width"
        case height = "height"
        case urls = "urls"
    }
}

struct UrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct IsLiked: Decodable {
    let photo: PhotoResult?
}

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension Profile {
    init(result profile: ProfileResult) {
        self.init(
            username: profile.username,
            name: "\(profile.firstName ?? "")  \(profile.lastName ?? "")",
            loginName: "@\(profile.username)",
            bio: profile.bio
        )
    }
}
