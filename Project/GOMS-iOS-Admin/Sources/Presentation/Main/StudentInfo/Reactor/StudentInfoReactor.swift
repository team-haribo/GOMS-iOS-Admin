import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class StudentInfoReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    // MARK: - Reactor
    
    enum Action {
        case searchButtonDidTap
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
extension StudentInfoReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonDidTap:
            return searchButtonDidTap()
        }
    }
}


// MARK: - Method
private extension StudentInfoReactor {
    func searchButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.searchButtonIsRequired)
        return .empty()
    }
}
