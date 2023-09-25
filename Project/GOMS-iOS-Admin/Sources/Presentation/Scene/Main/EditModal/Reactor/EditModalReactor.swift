//
//  EditModalReactor.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/28.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class EditModalReactor: Reactor, Stepper{
    // MARK: - Properties
    var initialState: State
    
    var steps: PublishRelay<Step> = .init()
    
    let editModalProvider = MoyaProvider<StudentCouncilServices>(plugins: [NetworkLoggerPlugin()])
    
    let keychain = Keychain()
    
    let gomsAdminRefreshToken = GOMSAdminRefreshToken.shared
    
    lazy var accessToken = "Bearer " + (keychain.read(key: Const.KeychainKey.accessToken) ?? "")
    
    let studentInfoReactor = StudentInfoReactor.shared
    
    var accountIdx: UUID = UUID()
    
    
    // MARK: - Reactor
    
    enum Action {
        case updateRole(authority: String)
        case addToBlackList
        case deleteBlackList
        case dismissEditModal
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    // MARK: - Init
    init(accountIdx: UUID) {
        self.initialState = State()
        self.accountIdx = accountIdx
    }
}

// MARK: - Mutate
extension EditModalReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateRole(authority):
            return updateRole(authority: authority)
        case .addToBlackList:
            return addToBlackList()
        case .dismissEditModal:
            return dismissEditModal()
        case .deleteBlackList:
            return deleteBlackList()
        }
    }
}

// MARK: - Method
private extension EditModalReactor {
    func updateRole(authority: String) -> Observable<Mutation> {
        return Observable.create { [self] observer in
            let param = EditAuthorityRequest(accountIdx: self.accountIdx, authority: authority)
            editModalProvider.request(.editAuthority(authorization: self.accessToken, param: param)){ response in
                switch response {
                case let .success(result):
                    let statusCode = result.statusCode
                    switch statusCode{
                    case 200..<300:
                        print("success")
                        observer.onCompleted()
                    case 401:
                        self.gomsAdminRefreshToken.tokenReissuance()
                        self.steps.accept(GOMSAdminStep.failureAlert(
                            title: "오류",
                            message: "작업을 한 번 더 시도해주세요"
                        ))
                    case 403:
                        self.steps.accept(GOMSAdminStep.failureAlert(title: "오류", message: "학생회 계정이 아닙니다."))
                        self.steps.accept(GOMSAdminStep.introIsRequired)
                    case 404:
                        self.steps.accept(GOMSAdminStep.failureAlert(title: "오류", message: "계정을 찾을 수 없습니다."))
                        self.steps.accept(GOMSAdminStep.introIsRequired)
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
    
    func addToBlackList() -> Observable<Mutation> {
        return Observable.create { [self] observer in
            editModalProvider.request(.addToBlackList(authorization: self.accessToken, accountIdx: accountIdx)){ response in
                switch response {
                case let .success(result):
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
                    case 404:
                        self.steps.accept(
                            GOMSAdminStep.failureAlert(
                                title: "오류",
                                message: "계정을 찾을 수 없습니다.",
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
    
    func deleteBlackList() -> Observable<Mutation> {
        return Observable.create { [self] observer in
            editModalProvider.request(.blackListDelete(authorization: self.accessToken, accountIdx: accountIdx)){ response in
                switch response {
                case let .success(result):
                    let statusCode = result.statusCode
                    print(self.accessToken)
                    switch statusCode{
                    case 200..<300:
                        print("success")
                    case 401:
                        self.gomsAdminRefreshToken.tokenReissuance()
                        self.steps.accept(
                            GOMSAdminStep.failureAlert(
                                title: "오류",
                                message: "다시 한 번 작업을 실행해주세요",
                                action: [.init(title: "확인",style: .default) { _ in
                                    self.steps.accept(GOMSAdminStep.introIsRequired)}
                                ]
                            )
                        )
                    case 403:
                        self.steps.accept(
                            GOMSAdminStep.failureAlert(
                                title: "오류",
                                message: "학생회 계정이 아닙니다.",
                                action: [.init(title: "확인",style: .default) { _ in
                                    self.steps.accept(GOMSAdminStep.introIsRequired)}
                                ]
                            )
                        )
                    case 404:
                        self.steps.accept(
                            GOMSAdminStep.failureAlert(
                                title: "오류",
                                message: "계정을 찾을 수 없습니다.",
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
    
    func dismissEditModal() -> Observable<Mutation> {
        self.steps.accept(GOMSAdminStep.editModalDismiss)
        return .empty()
    }
}



