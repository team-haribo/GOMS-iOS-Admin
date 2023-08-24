
import Foundation
import Moya

enum StudentCouncilServices {
    case createQRCode(authorization : String)
    case studentList(authorization : String)
}


extension StudentCouncilServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createQRCode:
            return "/student-council/outing"
        case .studentList:
            return "/student-council/account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createQRCode:
            return .post
        case .studentList:
            return .get
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .createQRCode, .studentList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .createQRCode(authorization), let .studentList(authorization):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
