import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class OutingReactor: Reactor, Stepper {
    // MARK: - Properties
    
    var initialState: State

    var steps: PublishRelay<Step> = .init()

    let studentInfoProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])

    var searchResults: [OutingItem] = []
    
    var studentList: [StudentListResponse] = []

    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case profileButtonDidTap
        case searchButtonDidTap
        case fetchStudentList
    }
        
    enum Mutation {
        case setSearchResult(searchResults: [OutingItem])
        case fetchStudentList(studentList: [StudentListResponse])
    }
    
   struct OutingItem {
        var id: Int
        var name: String
    }
        
    struct State {
        var isDeleteButtonTapped: Bool = false
        var searchResults: [OutingItem] = []
        var studentList: [StudentListResponse] = []
    }
    
    // MARK: - Init
    
    init() {
        self.initialState = State()
    }
}

extension OutingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .profileButtonDidTap :
            return profileButtonDidTap()
        case .searchButtonDidTap:
            return searchButtonDidTap()
        case .fetchStudentList:
            return fetchOutingStudentList()
        }
    }
}

extension OutingReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchStudentList(studentList):
            newState.studentList = studentList
        case let .setSearchResult(result):
            newState.searchResults = result
        }
        return newState
    }
}

private extension OutingReactor {
    func searchButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.searchButtonIsRequired)
        return .empty()
    }
    
    func profileButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.profileIsRequired)
        return .empty()
    }
    
    func fetchOutingStudentList() -> Observable<Mutation> {
        return Observable.create { observer in
            self.studentInfoProvider.request(.fetchStudentList(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.studentList = try res.map([StudentListResponse].self)
                        print("outingList: \(self.studentList)")
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = res.statusCode
                    switch statusCode{
                    case 200..<300:
                        observer.onNext(Mutation.fetchStudentList(studentList: self.studentList))
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
