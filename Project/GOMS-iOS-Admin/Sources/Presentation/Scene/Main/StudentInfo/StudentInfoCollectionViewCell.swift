//
//  StudentInfoCell.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/23.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import UIKit
import Then
import SnapKit

class StudentInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "studentCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    let userProfile = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 23
        $0.layer.masksToBounds = true
    }
    
    let userName = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 16)
        $0.textColor = .black
    }
    
    let userNum = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 14)
        $0.textColor = GOMSAdminAsset.subColor.color
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(named: "editIcon"), for: .normal)
    }
    
    func addView() {
        [
            userProfile,
            userName,
            userNum,
            editButton
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        userProfile.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        userNum.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(6)
            $0.leading.equalTo(userProfile.snp.trailing).offset(24)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(17)
        }
    }
}
