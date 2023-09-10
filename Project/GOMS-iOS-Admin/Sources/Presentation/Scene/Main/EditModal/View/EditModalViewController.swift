//
//  EditModalViewController.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/28.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class EditModalViewController: BaseViewController<EditModalReactor> {
    
    private var editedUserAuthority: String? = ""
    private var editedUserIsBlackList: Bool?
    
    private let roleLabel = UILabel().then {
        $0.text = "역할"
        $0.font = GOMSAdminFontFamily.SFProText.medium.font(size: 16)
        $0.textColor = .black
    }
    
    private let roleSegmentedControl = CustomSegmentedControl(items: ["학생", "학생회", "외출금지"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var editButton = UIButton().then {
        $0.backgroundColor = GOMSAdminAsset.mainColor.color
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.bold.font(size: 14)
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roleSegmentedControl.buttonTappedHandler = { [weak self] selectedIndex in
            self?.roleSegconChanged(selectedIndex: selectedIndex)
        }
    }
    
    override func addView() {
        [
            roleLabel,
            roleSegmentedControl,
            editButton
        ].forEach {
                view.addSubview($0)
            }
    }
    
    override func setLayout() {
        roleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(42)
            $0.leading.equalToSuperview().offset(40)
        }
        roleSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(roleLabel.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(100)
        }
        editButton.snp.makeConstraints {
            $0.top.equalTo(roleSegmentedControl.snp.bottom).offset(94)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(52)
        }
    }
    
    private func roleSegconChanged(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            editedUserAuthority = "ROLE_STUDENT"
            editedUserIsBlackList = false
        case 1:
            editedUserAuthority = "ROLE_STUDENT_COUNCIL"
            editedUserIsBlackList = false
        case 2:
            editedUserIsBlackList = true
        default: break
            editedUserAuthority = ""
            editedUserIsBlackList = nil
        }
        
        print(editedUserAuthority)
    }
    
    // MARK: - Reactor
    
    override func bindAction(reactor: EditModalReactor) {
        editButton.rx.tap
                .flatMapLatest { [weak self] _ -> Observable<EditModalReactor.Action> in
                    guard let self = self else { return .empty() }
                    if self.editedUserIsBlackList ?? Bool() {
                        return .just(.addToBlackList)
                    } else {
                        return .just(.updateRole(authority: editedUserAuthority ?? ""))
                    }
                }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
    }
}

