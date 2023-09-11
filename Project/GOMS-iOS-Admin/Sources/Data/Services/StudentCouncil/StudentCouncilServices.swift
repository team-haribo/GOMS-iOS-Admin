
import Foundation
import Moya

enum StudentCouncilServices {
    case createQRCode(authorization : String)
    case fetchStudentList(authorization : String)
    case editAuthority(authorization: String, param: EditAuthorityRequest)
    case addToBlackList(authorization: String, accountIdx: UUID)
    case blackListDelete(authorization: String, accountIdx: UUID)
    case search(authorization: String, grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?)
}


extension StudentCouncilServices: TargetType {
    public var baseURL: URL {
        return URL(string: BaseURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createQRCode:
            return "/student-council/outing"
        case .fetchStudentList:
            return "/student-council/accounts"
        case .editAuthority:
            return "/student-council/authority"
        case let .addToBlackList(_,accountIdx),let .blackListDelete(_,accountIdx):
            return "/student-council/black-list/\(accountIdx)"
        case .search:
            return "/student-council/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createQRCode, .addToBlackList:
            return .post
        case .fetchStudentList, .search:
            return .get
        case .editAuthority:
            return .patch
        case .blackListDelete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .createQRCode, .fetchStudentList, .addToBlackList, .blackListDelete:
            return .requestPlain
        case let .editAuthority(_, param):
            return .requestJSONEncodable(param)
        case let .search(_, grade, classNum, name, isBlackList, authority):
            return .requestParameters(
                parameters: ["grade" : grade ?? "", "classNum" : classNum ?? "", "name" : name ?? "", "isBlackList" : isBlackList ?? "", "authority" : authority ?? ""],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .createQRCode(authorization), let .fetchStudentList(authorization), let .editAuthority(authorization,_), let .addToBlackList(authorization, _), let .blackListDelete(authorization,_), let .search(authorization, _, _, _, _, _):
            return["Content-Type" :"application/json","Authorization" : authorization]
        default:
            return["Content-Type" :"application/json"]
        }
    }
}
