import UIKit
import Then
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellName = UILabel().then {
        $0.textColor = .black
        $0.font = GOMSAdminFontFamily.SFProText.medium.font(size: 16)
    }
    
    let cellDetail = UILabel().then {
        $0.textColor = GOMSAdminAsset.subColor.color
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 14)
    }
    
    func addView() {
        [cellName, cellDetail].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setLayout() {
        cellName.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        cellDetail.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
