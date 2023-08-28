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
        
    var authData: SignInResponse?
    
    var steps: PublishRelay<Step> = .init()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    // MARK: - Reactor
    
    enum Action {
        case confirmationButtonDidTap(email: String)
    }
    
    enum Mutation {
        case numberTextFieldIsHidden(Bool)
    }
    
    struct State {
        var numberTextFieldIsHidden = true
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
        }
    }
}

extension LoginWithNumberReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .numberTextFieldIsHidden(isHidden):
            newState.numberTextFieldIsHidden = isHidden
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
                    case 401:
                        self.gomsAdminRefreshToken.tokenReissuance()
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "오류",
                            message: "작업을 한 번 더 시도해주세요"
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
}
