import Foundation
import Moya

enum AuthServices {
    case signIn(param: SignInRequest)
    case refreshToken(refreshToken: String)
    case sendEmail(email: String)
    case emailVerify(email: String, authCode: String)
}


extension AuthServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth/signin/"
        case .refreshToken:
            return "/auth/"
        case .sendEmail:
            return "/auth/email/send"
        case .emailVerify:
            return "auth/email/verify"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .sendEmail:
            return .post
        case .refreshToken:
            return .patch
        case .emailVerify:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .signIn(param):
            return .requestJSONEncodable(param)
        case .refreshToken:
            return .requestPlain
        case let .sendEmail(email):
            return .requestJSONEncodable(email)
        case let .emailVerify(email, authCode):
            return .requestParameters(parameters: [
                "email" : email,
                "authCode" : authCode
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .refreshToken(refreshToken):
            return["Content-Type" :"application/json","refreshToken" : refreshToken]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
