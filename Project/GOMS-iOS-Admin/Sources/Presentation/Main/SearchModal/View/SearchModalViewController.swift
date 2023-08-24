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

class SearchModalViewController: BaseViewController<SearchModalReactor>, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//    }
        
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
    
    override func addView() {
        [searchTextField].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(55)
        }
    }
}
