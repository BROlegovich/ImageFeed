
import Foundation

class OAuth2TokenStorage {
    static var shared = OAuth2TokenStorage()
    
    private init() {}
    
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
