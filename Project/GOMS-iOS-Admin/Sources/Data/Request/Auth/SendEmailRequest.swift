import Foundation

struct SendEmailRequest: Codable {
    let email: String
    
    init(email: String) {
        self.email = email
    }
}
