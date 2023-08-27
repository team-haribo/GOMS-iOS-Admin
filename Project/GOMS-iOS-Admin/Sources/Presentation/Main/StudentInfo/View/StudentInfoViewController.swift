//
//  StudentViewController.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/21.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class StudentInfoViewController: BaseViewController<StudentInfoReactor> {
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : GOMSAdminFontFamily.SFProText.medium.font(size: 16)
        ]
        self.navigationItem.title = "학생 정보 수정"
        super.viewDidLoad()
        
        studentInfoCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private var searchButton = UIButton().then {
        $0.setTitle("찾으시는 학생이 있으신가요?", for: .normal)
        $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.regular.font(size: 14)
        $0.setTitleColor(GOMSAdminAsset.subColor.color, for: .normal)
        $0.contentHorizontalAlignment = .leading
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 120)
        $0.backgroundColor = .white
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
    
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(named: "Search")
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(
            width: (
                (UIScreen.main.bounds.width) - 52
            ),
            height: (
                90
            )
        )
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private let studentInfoCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.isScrollEnabled = true
        $0.register(StudentInfoCollectionViewCell.self, forCellWithReuseIdentifier: "studentCell")
        $0.backgroundColor = GOMSAdminAsset.background.color
    }
    
    override func addView() {
        [searchButton, searchIcon, studentInfoCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(55)
        }
        searchIcon.snp.makeConstraints {
            $0.centerY.equalTo(searchButton)
            $0.trailing.equalTo(searchButton.snp.trailing).inset(20)
        }
        studentInfoCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Reactor
    
    override func bind(reactor: StudentInfoReactor) {
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in StudentInfoReactor.Action.fetchStudentList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        searchButton.rx.tap
            .map { StudentInfoReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: StudentInfoReactor) {
        reactor.state
            .map { $0.studentList }
            .bind(
                to: studentInfoCollectionView.rx.items(cellIdentifier: "studentCell", cellType: StudentInfoCollectionViewCell.self)
            ) { ip, item, cell in
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 10
                cell.layer.applySketchShadow(
                    color: UIColor.black,
                    alpha: 0.1,
                    x: 0,
                    y: 2,
                    blur: 8,
                    spread: 0
                )
                let url = URL(string: item.profileUrl ?? "")
                cell.userProfile.kf.setImage(with: url, placeholder: UIImage(named: "DummyImage.svg"))
                cell.userName.text = item.name
                cell.userNum.text = "\(item.studentNum.grade)\(item.studentNum.classNum)\(item.studentNum.number)"
            }.disposed(by: disposeBag)
    }
}
