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
extension SearchModalReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        }
    }
}

// MARK: - Method
private extension SearchModalReactor {
    
}


