import Foundation

struct OutingModel: Codable {
    let data: OutingResponse
}

struct OutingResponse: Codable {
    let outingUUID: UUID
}
