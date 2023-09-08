import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class StudentInfoReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    static let shared = StudentInfoReactor()
    
    var steps: PublishRelay<Step> = .init()
    
    let studentInfoProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])
    
    var studentList: [StudentListResponse] = []
        
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    // MARK: - Reactor
    
    enum Action {
        case searchButtonDidTap
        case fetchStudentList
        case editIconDidTap(accountIdx: UUID)
    }
    
    enum Mutation {
        case fetchStudentList(studentList: [StudentListResponse])
    }
    
    struct State {
        var studentList: [StudentListResponse] = []
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension StudentInfoReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonDidTap:
            return searchButtonDidTap()
        case .fetchStudentList:
            return fetchStudentList()
        case let .editIconDidTap(accountIdx):
            return editIconDidTap(accountIdx: accountIdx)
        }
    }
}

// MARK: - Reduce
extension StudentInfoReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchStudentList(studentList):
            newState.studentList = studentList
        }
        return newState
    }
}


// MARK: - Method
private extension StudentInfoReactor {
    func searchButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.searchButtonIsRequired)
        return .empty()
    }
    
    func fetchStudentList() -> Observable<Mutation> {
        return Observable.create { observer in
            self.studentInfoProvider.request(.fetchStudentList(authorization: self.accessToken)) { result in
                switch result {
                case let .success(res):
                    do {
                        self.studentList = try res.map([StudentListResponse].self)
                        //print("Fetched student list: \(self.studentList)")
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
    
    func editIconDidTap(accountIdx: UUID) -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.editIconIsRequired(accountIdx: accountIdx))
        print(accountIdx)
        return .empty()
    }
}
