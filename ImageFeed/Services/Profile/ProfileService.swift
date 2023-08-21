
import UIKit

final class ProfileService {
    
    private let urlSession = URLSession.shared
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    private let builder: URLRequestBuilder
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    public func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = fetchProfileRequest() else {
            assertionFailure("Invalid requet")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else {return}
            self.task = nil
            switch result {
            case .success(let result):
                let profile = Profile(result: result)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
        
    }
    
    private func fetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(path: "/me",
                                httpMethod: "GET",
                                baseURL: URL(string: "https://api.unsplash.com")!
        )
    }
}
