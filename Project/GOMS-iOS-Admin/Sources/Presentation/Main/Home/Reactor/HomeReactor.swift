import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class HomeReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    let outingProvider = MoyaProvider<OutingServices>()
    
    var outingCount: OutingCountResponse = .init(outingCount: 0)
        
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case profileButtonDidTap
        case createQRCodeButtonDidTap
        case outingButtonDidTap
        case fetchOutingCount
    }
    
    enum Mutation {
        case fetchOutingCount(count: Int)
    }
    
    struct State {
        var count: Int = 0
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension HomeReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .profileButtonDidTap:
            return profileButtonDidTap()
        case .createQRCodeButtonDidTap:
            return createQRCodeButtonDidTap()
        case .outingButtonDidTap:
            return outingButtonDidTap()
        case .fetchOutingCount:
            return fetchOutingCount()
        }
    }
}

extension HomeReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchOutingCount(count):
            newState.count = count
        }
        return newState
    }
}

// MARK: - Method
private extension HomeReactor {
    func profileButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.profileIsRequired)
        return .empty()
    }
    
    func createQRCodeButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.qrocdeIsRequired)
        return .empty()
    }
    
    func outingButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.outingIsRequired)
        return .empty()
    }
    
    func fetchOutingCount() -> Observable<Mutation> {
        return Observable.create { observer in
            self.outingProvider.request(.outingCount(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.outingCount = try res.map(OutingCountResponse.self)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        observer.onNext(Mutation.fetchOutingCount(
                            count: self.outingCount.outingCount
                        ))
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
