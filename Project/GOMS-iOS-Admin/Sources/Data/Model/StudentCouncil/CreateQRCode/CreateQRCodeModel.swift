import Foundation

struct CreateQRCodeModel: Codable {
    let data: CreateQRCodeResponse
}

struct CreateQRCodeResponse: Codable {
    let outingUUID: UUID
}
