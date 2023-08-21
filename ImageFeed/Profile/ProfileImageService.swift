
import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private var task: URLSessionTask?
    private let builder = URLRequestBuilder.shared
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String?, _ completion: @escaping (Result<String?, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let username = username,
              let request = fetchProfileImageRequest(username: username) else {
            assertionFailure("Invalid requet")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let userResult):
                guard let smallPhoto = userResult.profileImage?.small else { return }
                self.avatarURL = smallPhoto
                completion(.success(smallPhoto))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": smallPhoto])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func fetchProfileImageRequest(username: String) -> URLRequest? {
        builder.makeHTTPRequest(path: "/users/\(username)",
                                httpMethod: "GET",
                                baseURL: URL(string: "https://api.unsplash.com")!
        )
    }
}
