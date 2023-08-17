import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import Kingfisher

class HomeViewController: BaseViewController<HomeViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        tardyCollectionView.collectionViewLayout = layout
    }
    
    private let homeMainImage = UIImageView().then {
        $0.image = UIImage(named: "homeUndrawImage.svg")
    }
    
    private let homeMainText = UILabel().then {
        $0.text = "간편하게\n수요외출제를\n관리해보세요"
        $0.numberOfLines = 3
        $0.font = GOMSIOSAdminFontFamily.SFProText.bold.font(size: 24)
        $0.textColor = .black
    }
    
    private lazy var useQRCodeButton = UIButton().then {
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = GOMSIOSAdminFontFamily.SFProText.bold.font(size: 14)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = GOMSIOSAdminAsset.mainColor.color
    }
    
    private let outingButton = UIButton().then {
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
    
    private let totalStudentText = UILabel().then {
        $0.text = "현재 183명의 학생 중에서"
        $0.textColor = GOMSIOSAdminAsset.subColor.color
        $0.font = GOMSIOSAdminFontFamily.SFProText.regular.font(size: 12)
    }
    
    private lazy var outingStudentText = UILabel().then {
        $0.text = "0 명이 외출중이에요!"
        $0.textColor = UIColor.black
        $0.font = GOMSIOSAdminFontFamily.SFProText.medium.font(size: 16)
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "0")
        attribtuedString.addAttribute(
            .foregroundColor,
            value: GOMSIOSAdminAsset.mainColor.color,
            range: range
        )
        $0.attributedText = attribtuedString
    }
    
    private let outingNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")
    }
    
    private let tardyText = UILabel().then {
        $0.text = "지각의 전당"
        $0.textColor = UIColor(
            red: 120/255,
            green: 120/255,
            blue: 120/255,
            alpha: 1.00
        )
        $0.font = GOMSIOSAdminFontFamily.SFProText.semibold.font(size: 20)
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(
            width: (
                (UIScreen.main.bounds.width) / 3.87
            ),
            height: (
                (UIScreen.main.bounds.height) / 6.76
            )
        )
        $0.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) //아이템 상하좌우 사이값 초기화
    }
    
    private lazy var tardyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = GOMSIOSAdminAsset.background.color
    }
    
    private let profileButton = UIButton().then {
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
    
    private lazy var subStudnetInfoText = UILabel().then {
        $0.text = "모든 학생들의 역할을 관리해보세요!"
        $0.textColor = GOMSIOSAdminAsset.subColor.color
        $0.font = GOMSIOSAdminFontFamily.SFProText.regular.font(size: 12)
    }
    
    private lazy var studnetInfoText = UILabel().then {
        $0.text = "학생 관리하기"
        $0.textColor = UIColor.black
        $0.font = GOMSIOSAdminFontFamily.SFProText.medium.font(size: 16)
    }
    
    private let profileNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")
    }
    
    override func addView() {
        [homeMainImage, homeMainText, useQRCodeButton, outingButton, totalStudentText, outingStudentText, outingNavigationButton, tardyText, tardyCollectionView, profileButton ,subStudnetInfoText,studnetInfoText, profileNavigationButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        homeMainImage.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 7.73)
            $0.trailing.equalToSuperview().offset(16)
        }
        homeMainText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 6.94)
            $0.leading.equalToSuperview().offset(26)
        }
        useQRCodeButton.snp.makeConstraints {
            $0.top.equalTo(homeMainText.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(26)
            $0.height.equalTo((bounds.height) / 21.36)
            $0.trailing.equalTo(homeMainImage.snp.leading).inset(23)
        }
        outingButton.snp.makeConstraints {
            $0.top.equalTo(homeMainImage.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo((bounds.height) / 11.6)
        }
        totalStudentText.snp.makeConstraints {
            $0.top.equalTo(outingButton.snp.top).offset((bounds.height) / 54)
            $0.leading.equalTo(outingButton.snp.leading).offset(16)
        }
        outingStudentText.snp.makeConstraints {
            $0.top.equalTo(totalStudentText.snp.bottom).offset(8)
            $0.leading.equalTo(outingButton.snp.leading).offset(16)
        }
        
        outingNavigationButton.snp.makeConstraints {
            $0.centerY.equalTo(outingButton.snp.centerY).offset(0)
            $0.trailing.equalTo(profileButton.snp.trailing).inset(23)
        }
        
        tardyText.snp.makeConstraints {
            $0.top.equalTo(outingButton.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(26)
        }
        tardyCollectionView.snp.makeConstraints {
            $0.top.equalTo(tardyText.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalTo(view.snp.bottom).inset((bounds.height) / 3.5)
        }
        profileButton.snp.makeConstraints {
            $0.top.equalTo(tardyCollectionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo((bounds.height) / 11.6)
        }
        subStudnetInfoText.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.top).offset((bounds.height) / 45.11)
            $0.leading.equalTo(profileButton.snp.leading).offset(14)
        }
        studnetInfoText.snp.makeConstraints {
            $0.top.equalTo(subStudnetInfoText.snp.bottom).offset(8)
            $0.leading.equalTo(profileButton.snp.leading).offset(14)
        }
        profileNavigationButton.snp.makeConstraints {
            $0.centerY.equalTo(profileButton.snp.centerY).offset(0)
            $0.trailing.equalTo(profileButton.snp.trailing).inset(23)
        }
    }
}

extension HomeViewController :
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
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
        cell.studentName.text = "선민재"
        cell.studentNum.text = "3111"
        cell.userProfileImage.image = UIImage(named: "userDummyImage.svg")!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((bounds.width) / 3.87), height: ((bounds.height) / 6.76))
    }
}
