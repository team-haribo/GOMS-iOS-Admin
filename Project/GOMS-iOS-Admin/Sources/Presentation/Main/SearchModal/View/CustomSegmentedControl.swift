//
//  CustomSegmentedControl.swift
//  GOMS-IOS-Admin
//
//  Created by 신아인 on 2023/08/26.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then

class CustomSegmentedControl: UIStackView {
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var buttons: [UIButton] = []
    
    init(items: [String]) {
        super.init(frame: .zero)
        
        axis = .horizontal
        distribution = .fillEqually
        spacing = 26
        
        for title in items {
            let segmentButton = UIButton().then {
                $0.setTitle(title, for: .normal)
                $0.setTitleColor(GOMSAdminAsset.subColor.color, for: .normal)
                $0.setTitleColor(.white, for: .selected)
                $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.medium.font(size: 14)
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 8
                $0.layer.applySketchShadow(
                    color: UIColor.black,
                    alpha: 0.1,
                    x: 0,
                    y: 2,
                    blur: 8,
                    spread: 0
                )
                $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                addArrangedSubview($0)
                buttons.append($0)
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = (button == sender)
            button.backgroundColor = button.isSelected ? GOMSAdminAsset.mainColor.color : .white
            button.setTitleColor(button.isSelected ? .white : GOMSAdminAsset.subColor.color, for: .normal)
        }
    }
    
    func resetButtons() {
        for button in buttons {
            button.isSelected = false
            button.backgroundColor = .white
            button.setTitleColor(GOMSAdminAsset.subColor.color, for: .normal)
        }
    }
}
