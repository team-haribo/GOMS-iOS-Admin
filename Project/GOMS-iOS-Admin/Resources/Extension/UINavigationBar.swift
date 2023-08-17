import UIKit
import Then

extension UINavigationItem {
    func rightBarButtonItem() {
        let profileButton = UIBarButtonItem().then {
            $0.image = UIImage(named: "profileIcon.svg")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = GOMSIOSAdminAsset.mainColor.color
        }
        self.setRightBarButton(profileButton, animated: true)
    }
    
    func leftLogoImage() {
        let customFont = GOMSIOSAdminFontFamily.Fraunces.black.font(size: 20)
        self.leftBarButtonItem = UIBarButtonItem(
            title: "GOMS",
            style: .plain,
            target: nil,
            action: nil
        ).then {
            $0.tintColor = GOMSIOSAdminAsset.mainColor.color
            $0.setTitleTextAttributes(
                [NSAttributedString.Key.font: customFont],
                for: .normal
            )
        }
    }
    
    func backButton(title:String = "취소") {
        let backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = UIColor.black
        self.backBarButtonItem = backBarButtonItem
    }
}
