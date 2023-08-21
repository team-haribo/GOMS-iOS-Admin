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
    
    var createQRCodeData: CreateQRCodeResponse?
    
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
        provider.request(.createQRCode(authorization: accessToken)) { response in
            switch response {
            case .success(let result):
                print(String(data: result.data, encoding: .utf8))
                do {
                    self.createQRCodeData = try result.map(CreateQRCodeResponse.self)
                }catch(let err) {
                    print(String(describing: err))
                }
                let statusCode = result.statusCode
                switch statusCode{
                case 200..<300:
                    print("success")
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
        return Observable.concat([
            .just(Mutation.createQRCode(uuid: createQRCodeData?.outingUUID))
        ])
    }
    
//    func viewDidLoad() -> Observable<Mutation> {
//        return Observable<CreateQRCodeResponse>.create { observer in
//            provider.request(.createQRCode(authorization: accessToken)) { response in
//                switch response {
//                case let .success(res):
//                    let responseData = res.data
//                    do {
//                        self.createQRCodeData = try JSONDecoder().decode(CreateQRCodeResponse.self, from: responseData)
//                        print(self.createQRCodeData?.outingUUID)
//                    }catch(let err) {
//                        print(String(describing: err))
//                    }
//                case let .failure(err):
//                    observer.onError(err)
//                }
//            }
////            observer.onNext(Mutation.createQRCode(uuid: createQRCodeData?.outingUUID))
////            observer.onComplete()
////            return Disposables.create()
//            observer.onNext(Mutation.createQRCode(uuid: <#T##CreateQRCodeResponse#>))
//            return Observable.just(Mutation.createQRCode(uuid: createQRCodeData?.outingUUID))
//        }
//    }
    func profileButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.profileIsRequired)
        return .empty()
    }
}
