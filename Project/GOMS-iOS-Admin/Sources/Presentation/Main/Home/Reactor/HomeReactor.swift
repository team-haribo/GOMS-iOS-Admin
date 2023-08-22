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
    
    // MARK: - Reactor
    
    enum Action {
        case profileButtonDidTap
        case createQRCodeButtonDidTap
        case outingButtonDidTap
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
extension HomeReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .profileButtonDidTap:
            return profileButtonDidTap()
        case .createQRCodeButtonDidTap:
            return createQRCodeButtonDidTap()
        case .outingButtonDidTap:
            return outingButtonDidTap()
        }
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
}
