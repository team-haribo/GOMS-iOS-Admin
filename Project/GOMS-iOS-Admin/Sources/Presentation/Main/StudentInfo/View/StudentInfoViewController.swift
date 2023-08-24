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
    
    private var userNameList = [String]()
    private var userGradeList = [Int]()
    private var userClassNumList = [Int]()
    private var userNumList = [Int]()
    private var userProfile = [String]()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : GOMSAdminFontFamily.SFProText.medium.font(size: 16)
        ]
        self.navigationItem.title = "학생 정보 수정"
        super.viewDidLoad()
        
        studentInfoCollectionView.dataSource = self
        studentInfoCollectionView.delegate = self
        studentInfoCollectionView.register(
            StudentInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: StudentInfoCollectionViewCell.identifier
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
        
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
    
    private let studentInfoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = true
        $0.backgroundColor = GOMSAdminAsset.background.color
    }
    
    override func addView() {
        [searchTextField, studentInfoCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(55)
        }
        studentInfoCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Reactor
    
    override func bind(reactor: StudentInfoReactor) {
        searchTextField.rx.controlEvent(.editingDidBegin)
            .map { StudentInfoReactor.Action.searchTextFieldDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension StudentInfoViewController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentInfoCollectionViewCell.identifier, for: indexPath) as? StudentInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
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
        cell.userName.text = "\(userNameList[indexPath.row])"
        if userNumList[indexPath.row] < 10 {
            cell.userNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])0\(userNumList[indexPath.row])"
        }
        else {
            cell.userNum.text = "\(userGradeList[indexPath.row])\(userClassNumList[indexPath.row])\(userNumList[indexPath.row])"
        }
        let url = URL(string: userProfile[indexPath.row])
        let imageCornerRadius = RoundCornerImageProcessor(cornerRadius: 20)
        cell.userProfile.kf.setImage(
            with: url,
            placeholder:UIImage(named: "userDummyImage"),
            options: [.processor(imageCornerRadius)]
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (
                (UIScreen.main.bounds.width) - 52
            ),
            height: (
                90
            )
        )
    }
}
