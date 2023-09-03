import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class LoginWithNumberReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    let keychain = Keychain()
    
    let authProvider = MoyaProvider<AuthServices>(plugins: [NetworkLoggerPlugin()])
        
    var authData: EmailVerifyResponse?
    
    var steps: PublishRelay<Step> = .init()
        
    // MARK: - Reactor
    
    enum Action {
        case confirmationButtonDidTap(email: String)
        case loginWithNumberCompleted(email: String, authCode: String)
        case numberIsTyping
    }
    
    enum Mutation {
        case numberTextFieldIsHidden(Bool)
        case numberIsTyping(Bool)
    }
    
    struct State {
        var numberTextFieldIsHidden = true
        var numberIsTyping = false
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension LoginWithNumberReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .confirmationButtonDidTap(email):
            return confirmationButtonDidTap(email: email)
        case let .loginWithNumberCompleted(email, authCode):
            return loginWithNumberCompleted(email: email, authCode: authCode)
        case .numberIsTyping:
            return Observable.just(Mutation.numberIsTyping(true))
        }
    }
}

extension LoginWithNumberReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .numberTextFieldIsHidden(isHidden):
            newState.numberTextFieldIsHidden = isHidden
        case let .numberIsTyping(typing):
            newState.numberIsTyping = typing
        }
        return newState
    }
}

// MARK: - Method
private extension LoginWithNumberReactor {
    func confirmationButtonDidTap(email: String) -> Observable<Mutation> {
        let param = SendEmailRequest(email: email)
        return Observable.create { observer in
            self.authProvider.request(.sendEmail(param: param)) { result in
                print(email)
                switch result {
                case let .success(res):
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        observer.onNext(Mutation.numberTextFieldIsHidden(false))
                    case 404:
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "실패",
                            message: "회원가입을 해주세요"
                        ))
                        observer.onNext(Mutation.numberTextFieldIsHidden(true))
                    case 429:
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "오류",
                            message: "시도 횟수가 5번 이상입니다."
                        ))
                        observer.onNext(Mutation.numberTextFieldIsHidden(true))
                    default:
                        observer.onNext(Mutation.numberTextFieldIsHidden(true))
                    }
                case let .failure(err):
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    func loginWithNumberCompleted(email:String, authCode: String) -> Observable<Mutation> {
        authProvider.request(.emailVerify(email: email, authCode: authCode)) { response in
            switch response {
            case .success(let result):
                print(String(data: result.data, encoding: .utf8))
                do {
                    self.authData = try result.map(EmailVerifyResponse.self)
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
                case 404:
                    self.steps.accept(GOMSAdminStep.failureAlert(
                        title: "오류",
                        message: "인증코드를 확인해주세요"
                    ))
                case 429:
                    self.steps.accept(GOMSAdminStep.failureAlert(
                        title: "오류",
                        message: "시도 횟수가 5번 이상입니다."
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
