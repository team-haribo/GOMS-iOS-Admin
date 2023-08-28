import Foundation

struct StudentListModel: Codable {
    let data: StudentListResponse
}

struct StudentListResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    let authority: String
    let isBlackList: Bool
    
    struct StudentNum: Codable {
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
