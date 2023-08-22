import Foundation
import Moya

enum LateServices {
    case fetchLateRank(authorization: String)
}


extension LateServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchLateRank:
            return "/late/rank"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchLateRank:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .fetchLateRank:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchLateRank(authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
