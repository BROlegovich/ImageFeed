
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static var shared = OAuth2TokenStorage()
    private let keychainStorage = KeychainWrapper.standard
    
    private init() {}
    
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            keychainStorage.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                keychainStorage.set(token, forKey: tokenKey)
            } else {
                print("removing tokenKey")
                keychainStorage.removeObject(forKey: tokenKey)
            }
        }
    }
    
    func clearTokenKey() {
        keychainStorage.removeAllKeys()
    }
}
