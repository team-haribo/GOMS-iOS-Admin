
import Foundation
import Moya

enum StudentCouncilServices {
    case createQRCode(authorization : String)
}


extension StudentCouncilServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createQRCode:
            return "/student-council/outing"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createQRCode:
            return .post
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .createQRCode:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .createQRCode(authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
