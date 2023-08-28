//
//  SearchMadalReactor.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/24.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class SearchModalReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    // MARK: - Reactor
    
    enum Action {
        case resetButtonDidTap
    }
    
    enum Mutation {
        case resetButtons
        case resetSegmentedControls(Bool)
    }
    
    struct State {
        var resetSegmentedControls: Bool = false
    }
    
    // MARK: - Init
    init() {
        self.initialState = State()
    }
}

// MARK: - Mutate
extension SearchModalReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .resetButtonDidTap:
            return .concat([
                .just(.resetSegmentedControls(true)),
                .just(.resetButtons)
            ])
        }
    }
}

// MARK: - Reduce
extension SearchModalReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .resetSegmentedControls(let shouldReset):
            newState.resetSegmentedControls = shouldReset
        case .resetButtons:
            newState.resetSegmentedControls = false
        }
        
        return newState
    }
}

// MARK: - Method
private extension SearchModalReactor {
    
}


