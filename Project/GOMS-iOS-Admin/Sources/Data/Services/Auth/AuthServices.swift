import Foundation
import Moya

enum AuthServices {
    case signIn(param: SignInRequest)
    case refreshToken(refreshToken: String)
    case sendEmail(authorization: String, param: SendEmailRequest)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .sendEmail:
            return .post
        case .refreshToken:
            return .patch
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
        case let .sendEmail(_, param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .refreshToken(refreshToken):
            return["Content-Type" :"application/json","refreshToken" : refreshToken]
        case let .sendEmail(authorization, _):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
