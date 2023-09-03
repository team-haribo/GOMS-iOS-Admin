import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class OutingReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    // MARK: - Reactor
    
    enum Action {
        case profileButtonDidTap
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
extension OutingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .profileButtonDidTap:
            return profileButtonDidTap()
        }
    }
}

// MARK: - Method
private extension OutingReactor {
    func profileButtonDidTap() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.profileIsRequired)
        return .empty()
    }
}
