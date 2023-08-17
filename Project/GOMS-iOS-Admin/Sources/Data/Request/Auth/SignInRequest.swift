import Foundation

struct SignInRequest: Codable {
    let code: String
    
    init(code: String) {
        self.code = code
    }
}
