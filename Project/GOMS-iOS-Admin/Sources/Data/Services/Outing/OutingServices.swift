import Foundation
import Moya

enum OutingServices {
    case outingCount(authorization: String)
}


extension OutingServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .outingCount:
            return "/outing/count"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .outingCount:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .outingCount:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .outingCount(authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
