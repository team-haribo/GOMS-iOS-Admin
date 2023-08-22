import Foundation

struct FetchLateRankModel: Codable {
    let data: FetchLateRankResponse
}

struct FetchLateRankResponse: Codable {
    let accountIdx: UUID
    let name: String
    let studentNum: StudentNum
    let profileUrl: String?
    
    struct StudentNum: Codable {
        let grade: Int
        let classNum: Int
        let number: Int
    }
}
