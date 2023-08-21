import Foundation
import UIKit
import Then
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "homeCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
        self.setLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userProfileImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    var studentName = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.black
        $0.font = GOMSAdminFontFamily.SFProText.medium.font(size: 14)
    }
    
    var studentNum = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = GOMSAdminAsset.subColor.color
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 12)
    }
    
    func addView() {
        [userProfileImage, studentName, studentNum].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        userProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview().offset(0)
            $0.width.height.equalTo(40)
        }
        studentName.snp.makeConstraints {
            $0.top.equalTo(userProfileImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview().offset(0)
        }
        studentNum.snp.makeConstraints {
            $0.top.equalTo(studentName.snp.bottom).offset(5)
            $0.centerX.equalToSuperview().offset(0)
        }
    }
}
