//
//  SearchModalViewController.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/23.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class SearchModalViewController: BaseViewController<SearchModalReactor> {
    
    private let searchTextField = UITextField().then {
        let imageView = UIImageView(image: UIImage(named: "Search"))
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width + 20, height: imageView.frame.size.height))
        paddingView.addSubview(imageView)
        
        let placeholderText = "찾으시는 학생이 있으신가요?"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: GOMSAdminFontFamily.SFProText.regular.font(size: 14)
        ]
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        $0.leftPadding(width: 20)
        $0.textColor = .black
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        
        $0.rightView = paddingView
        $0.rightViewMode = .always
        
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
    }
    
    private let resetButton = UIButton().then {
        $0.setImage(UIImage(named: "Reset"), for: .normal)
    }
    
    private let roleLabel = UILabel().then {
        $0.text = "역할"
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 15)
        $0.textColor = .black
    }
    
    private let gradeLabel = UILabel().then {
        $0.text = "학년"
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 15)
        $0.textColor = .black
    }
    
    private let classNumLabel = UILabel().then {
        $0.text = "반"
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 15)
        $0.textColor = .black
    }
    
    private let roleSegmentedControl = CustomSegmentedControl(items: ["학생", "학생회", "외출금지"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let gradeSegmentedControl = CustomSegmentedControl(items: ["1", "2", "3"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let classNumSegmentedControl = CustomSegmentedControl(items: ["1", "2", "3", "4"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var searchButton = UIButton().then {
        $0.backgroundColor = GOMSAdminAsset.mainColor.color
        $0.setTitle("검색하기", for: .normal)
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
    
    override func addView() {
        [
            searchTextField,
            resetButton,
            roleLabel,
            gradeLabel,
            classNumLabel,
            roleSegmentedControl,
            gradeSegmentedControl,
            classNumSegmentedControl,
            searchButton].forEach {
                view.addSubview($0)
            }
    }
    
    override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(55)
        }
        resetButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(27)
        }
        roleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(26)
        }
        gradeLabel.snp.makeConstraints {
            $0.top.equalTo(roleLabel.snp.bottom).offset(55)
            $0.leading.equalToSuperview().offset(26)
        }
        classNumLabel.snp.makeConstraints {
            $0.top.equalTo(gradeLabel.snp.bottom).offset(55)
            $0.leading.equalToSuperview().offset(26)
        }
        roleSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(roleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(36)
        }
        gradeSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(gradeLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(36)
        }
        classNumSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(classNumLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(36)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(classNumSegmentedControl.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(52)
        }
    }
    
    override func bindAction(reactor: SearchModalReactor) {
        resetButton.rx.tap
            .map { SearchModalReactor.Action.resetButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: SearchModalReactor) {
        reactor.state.map { $0.resetSegmentedControls }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.resetSegmentedControls()
            })
            .disposed(by: disposeBag)
    }
    
    private func resetSegmentedControls() {
        //print("resetSegmentedControls() 호출 확인")
        roleSegmentedControl.resetButtons()
        gradeSegmentedControl.resetButtons()
        classNumSegmentedControl.resetButtons()
    }
}
