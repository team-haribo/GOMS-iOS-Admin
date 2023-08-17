import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class IntroReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    // MARK: - Reactor
    
    enum Action {
        case loginWithNumberButtonTap
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
extension IntroReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginWithNumberButtonTap:
            return pushLoginWithNumberVC()
        }
    }
}

// MARK: - Method
private extension IntroReactor {
    private func pushLoginWithNumberVC() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.loginWithNumberIsRequired)
        return .empty()
    }
}
