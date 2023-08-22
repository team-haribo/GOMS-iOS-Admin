import Foundation

struct FetchProfileModel: Codable {
    let data: FetchProfileResponse
}

struct FetchProfileResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let authority: String
    let profileUrl: String?
    let lateCount: Int
    let isOuting: Bool
    let isBlackList: Bool
    
    struct StudentNum: Codable{
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
