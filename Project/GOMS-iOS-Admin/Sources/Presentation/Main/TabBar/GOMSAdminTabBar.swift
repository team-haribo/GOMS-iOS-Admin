//
//  GOMSAdminTabBar.swift
//  GOMS-IOS-Admin
//
//  Created by 선민재 on 2023/08/15.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import UIKit

final class GOMSAdminTabBarViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureVC()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension GOMSAdminTabBarViewController {
    func configureVC() {
        tabBar.tintColor = GOMSAdminAsset.mainColor.color
        tabBar.unselectedItemTintColor = GOMSAdminAsset.subColor.color
        tabBar.backgroundColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0.98
        )
    }
}
