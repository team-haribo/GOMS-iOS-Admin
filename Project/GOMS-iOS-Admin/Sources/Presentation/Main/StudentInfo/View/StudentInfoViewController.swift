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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func addView() {
        
    }
    
    override func setLayout() {
        
    }
    
}
