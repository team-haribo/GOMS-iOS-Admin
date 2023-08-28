import Foundation

struct EmailVerifyModel: Codable {
    let data: EmailVerifyResponse
}

struct EmailVerifyResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExp: String
    let refreshTokenExp: String
    let authority: String
}

