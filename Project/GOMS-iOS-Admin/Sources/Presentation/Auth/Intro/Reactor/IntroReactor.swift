import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class IntroReactor: Reactor, Stepper{
    // MARK: - Properties
    
    let keychain = Keychain()
    
    let authProvider = MoyaProvider<AuthServices>()
    
    var initialState: State
    
    var authData: SignInResponse?
    
    var steps: PublishRelay<Step> = .init()
    
    // MARK: - Reactor
    
    enum Action {
        case loginWithNumberButtonTap
        case gauthSigninCompleted(code: String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension IntroReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginWithNumberButtonTap:
            return pushLoginWithNumberVC()
        case let .gauthSigninCompleted(code):
            return gauthSigninCompleted(code: code)
        }
    }
}

// MARK: - Method
private extension IntroReactor {
    private func pushLoginWithNumberVC() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.loginWithNumberIsRequired)
        return .empty()
    }
    
    private func gauthSigninCompleted(code: String) -> Observable<Mutation> {
        let param = SignInRequest(code: code)
        authProvider.request(.signIn(param: param)) { response in
            switch response {
            case .success(let result):
                print(String(data: result.data, encoding: .utf8))
                do {
                    self.authData = try result.map(SignInResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    if self.authData?.authority == "ROLE_STUDENT_COUNCIL" {
                        self.addKeychainToken()
                        self.steps.accept(GOMSAdminStep.tabBarIsRequired)
                    }
                    else {
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "오류",
                            message: "어드민 계정이 아닙니다."
                        ))
                    }
                case 400:
                    self.steps.accept(GOMSAdminStep.failureAlert(
                        title: "오류",
                        message: "로그인 할 수 없습니다. 나중에 다시 시도해주세요."
                    ))
                default:
                    print("ERROR")
                }
            case .failure(let err):
                print(String(describing: err))
            }
        }
        return .empty()
    }
    
    func addKeychainToken() {
        self.keychain.create(
            key: Const.KeychainKey.accessToken,
            token: self.authData?.accessToken ?? ""
        )
        self.keychain.create(
            key: Const.KeychainKey.refreshToken,
            token: self.authData?.refreshToken ?? ""
        )
        self.keychain.create(
            key: Const.KeychainKey.authority,
            token: self.authData?.authority ?? ""
        )
    }
}
