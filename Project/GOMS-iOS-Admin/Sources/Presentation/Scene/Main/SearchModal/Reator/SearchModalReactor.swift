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
    
    let searchModalProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])
    
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    let studentInfoReactor = StudentInfoReactor.shared
    
    var searchResult: [StudentListResponse] = []
    
    // MARK: - Reactor
    
    enum Action {
        case resetButtonDidTap
        case searchButtonDidTap(grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?)
        case dismissSearchModal
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
        case let .searchButtonDidTap(grade, classNum, name, isBlackList, authority):
            return searchStudent(grade: grade, classNum: classNum, name: name, isBlackList: isBlackList, authority: authority)
        case .dismissSearchModal:
            return dismissSearchModal()
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
    func searchStudent(grade: Int?, classNum: Int?, name: String?, isBlackList: Bool?, authority: String?) -> Observable<Mutation> {
        return Observable.create { observer in
            self.searchModalProvider.request(.search(authorization: self.accessToken, grade: grade, classNum: classNum, name: name, isBlackList: isBlackList, authority: authority)) { response in
                switch response {
                case let .success(result):
                    do {
                        self.searchResult = try result.map([StudentListResponse].self)
                        print("Fetched student list: \(self.searchResult)")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchResultNotification"), object: self.searchResult)
                    }catch(let err) {
                        print(String(describing: err))
                    }
                    let statusCode = result.statusCode
                    print(self.accessToken)
                    switch statusCode{
                    case 200..<300:
                        print("success")
                    case 401:
                        self.gomsAdminRefreshToken.tokenReissuance()
                    case 403:
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "오류",
                            message: "학생회 계정이 아닙니다.",
                            action: [.init(title: "확인",style: .default) { _ in
                                self.steps.accept(GOMSAdminStep.introIsRequired)}
                                ]
                            )
                        )
                    default:
                        print("ERROR")
                    }
                    observer.onCompleted()
                case .failure(let err):
                    print(String(describing: err))
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    func dismissSearchModal() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.searchModalDismiss)
        return .empty()
    }
}


