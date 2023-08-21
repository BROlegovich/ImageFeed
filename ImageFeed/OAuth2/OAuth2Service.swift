
import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage.shared
    private var lastCode: String?
    private let builder: URLRequestBuilder
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    var isAuthenticated: Bool {
        tokenStorage.token != nil
    }
    
    func fetchOAuthToken(_ code: String,
                         completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        
        lastCode = code
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Invalid requet")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.task = nil
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    self.lastCode = nil
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
    builder.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!)
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}
