import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class QRCodeReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    let provider = MoyaProvider<StudentCouncilServices>()
    
    var uuidData: CreateQRCodeResponse?
    
    var steps: PublishRelay<Step> = .init()
    
    let keychain = Keychain()
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case viewDidLoad
        case profileButtonDidTap
    }
    
    enum Mutation {
        case setLoading(loading: Bool)
        case createQRCode(uuid: UUID)
    }
    
    struct State {
        var isLoading: Bool = false
        var uuid: UUID?
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension QRCodeReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case .profileButtonDidTap:
            return profileButtonDidTap()
        }
    }
}

extension QRCodeReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .createQRCode(uuid):
            newState.uuid = uuid
        case let .setLoading(loading):
            newState.isLoading = loading
        }
        return newState
    }
}

// MARK: - Method
private extension QRCodeReactor {
    func viewDidLoad() -> Observable<Mutation> {
        return Observable.create { observer in
            self.provider.request(.createQRCode(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.uuidData = try res.map(CreateQRCodeResponse.self)
                        guard let fetchUUID = self.uuidData?.outingUUID else {return}
                        observer.onNext(Mutation.createQRCode(uuid: fetchUUID))
                    }catch(let err) {
                        print(String(describing: err))
                    }
                case let .failure(err):
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    func profileButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.profileIsRequired)
        return .empty()
    }
}
