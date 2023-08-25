import Foundation

let AccessKey = "E1trHJ0Js5C_fT0MNSESA9bd2L0aOL5bfzvAXDyYxLc"
let SecretKey = "hS-uSzsT_haBYLNHymKpKlQuaoZsjZEDhZ14cIi_n8c"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let BaseURL = "https://unsplash.com"
let DefaultBaseURL = URL(string: "https://api.unsplash.com/")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let baseURL: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey, secretKey: SecretKey, redirectURI: RedirectURI, accessScope: AccessKey, baseURL: BaseURL, defaultBaseURL: DefaultBaseURL, unsplashAuthorizeURLString: UnsplashAuthorizeURLString)
    }
    
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, baseURL: String, defaultBaseURL: URL, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.baseURL = baseURL
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
}
