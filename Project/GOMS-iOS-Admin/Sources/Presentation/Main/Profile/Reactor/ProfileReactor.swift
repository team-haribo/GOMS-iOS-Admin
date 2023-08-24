import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class ProfileReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    let provider = MoyaProvider<AccountServices>(plugins: [NetworkLoggerPlugin()])
    
    var userData: FetchProfileResponse?
    
    var steps: PublishRelay<Step> = .init()
    
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case fetchUserData(userData: FetchProfileResponse)
    }
    
    struct State {
        var userData: FetchProfileResponse?
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension ProfileReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return viewWillAppear()
        }
    }
}

extension ProfileReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchUserData(userData):
            newState.userData = userData
        }
        return newState
    }
}

// MARK: - Method
private extension ProfileReactor {
    func viewWillAppear() -> Observable<Mutation> {
        return Observable.create { observer in
            self.provider.request(.fetchProfile(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.userData = try res.map(FetchProfileResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        guard let data = self.userData else {return}
                        print(data)
                        observer.onNext(Mutation.fetchUserData(userData: data))
                    case 401:
                        self.gomsAdminRefreshToken.tokenReissuance()
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "오류",
                            message: "작업을 한 번 더 시도해주세요"
                        ))
                    default:
                        print("ERROR")
                    }
                case let .failure(err):
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
}
