import Foundation
import Moya

enum AuthServices {
    case signIn(param: SignInRequest)
    case refreshToken(refreshToken: String)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
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
        case .signIn(let param):
            return .requestJSONEncodable(param)
        case .refreshToken:
            return .requestPlain
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
