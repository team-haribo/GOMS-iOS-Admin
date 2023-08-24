import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import Kingfisher

class HomeViewController: BaseViewController<HomeReactor> {
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        super.viewDidLoad()
        tardyCollectionView.collectionViewLayout = layout
    }
    
    private let homeMainImage = UIImageView().then {
        $0.image = UIImage(named: "homeUndrawImage.svg")
    }
    
    private let homeMainText = UILabel().then {
        $0.text = "간편하게\n수요외출제를\n관리해보세요"
        $0.numberOfLines = 3
        $0.font = GOMSAdminFontFamily.SFProText.bold.font(size: 24)
        $0.textColor = .black
    }
    
    private lazy var useQRCodeButton = UIButton().then {
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.bold.font(size: 14)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = GOMSAdminAsset.mainColor.color
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
        $0.textColor = GOMSAdminAsset.subColor.color
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 12)
    }
    
    private lazy var outingStudentText = UILabel().then {
        $0.text = "0 명이 외출중이에요!"
        $0.textColor = UIColor.black
        $0.font = GOMSAdminFontFamily.SFProText.medium.font(size: 16)
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "0")
        attribtuedString.addAttribute(
            .foregroundColor,
            value: GOMSAdminAsset.mainColor.color,
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
        $0.font = GOMSAdminFontFamily.SFProText.semibold.font(size: 20)
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
        $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "homeCell")
        $0.backgroundColor = GOMSAdminAsset.background.color
    }
    
    private let studentManagementButton = UIButton().then {
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
        $0.textColor = GOMSAdminAsset.subColor.color
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 12)
    }
    
    private lazy var studnetInfoText = UILabel().then {
        $0.text = "학생 관리하기"
        $0.textColor = UIColor.black
        $0.font = GOMSAdminFontFamily.SFProText.medium.font(size: 16)
    }
    
    private let profileNavigationButton = UIImageView().then {
        $0.image = UIImage(named: "navigationButton.svg")
    }
    
    override func addView() {
        [homeMainImage, homeMainText, useQRCodeButton, outingButton, totalStudentText, outingStudentText, outingNavigationButton, tardyText, tardyCollectionView, studentManagementButton ,subStudnetInfoText,studnetInfoText, profileNavigationButton].forEach {
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
            $0.trailing.equalTo(studentManagementButton.snp.trailing).inset(23)
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
        studentManagementButton.snp.makeConstraints {
            $0.top.equalTo(tardyCollectionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo((bounds.height) / 11.6)
        }
        subStudnetInfoText.snp.makeConstraints {
            $0.top.equalTo(studentManagementButton.snp.top).offset((bounds.height) / 45.11)
            $0.leading.equalTo(studentManagementButton.snp.leading).offset(14)
        }
        studnetInfoText.snp.makeConstraints {
            $0.top.equalTo(subStudnetInfoText.snp.bottom).offset(8)
            $0.leading.equalTo(studentManagementButton.snp.leading).offset(14)
        }
        profileNavigationButton.snp.makeConstraints {
            $0.centerY.equalTo(studentManagementButton.snp.centerY).offset(0)
            $0.trailing.equalTo(studentManagementButton.snp.trailing).inset(23)
        }
    }
    
    // MARK: - Reactor
    
    override func bindAction(reactor: HomeReactor) {
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in HomeReactor.Action.fetchOutingCount }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in HomeReactor.Action.fetchLateRank }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindView(reactor: HomeReactor) {
        navigationItem.rightBarButtonItem?.rx.tap
            .map { HomeReactor.Action.profileButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        useQRCodeButton.rx.tap
            .map { HomeReactor.Action.createQRCodeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        outingButton.rx.tap
            .map { HomeReactor.Action.outingButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: HomeReactor) {
        reactor.state
            .map{ $0.count }
            .distinctUntilChanged()
            .bind(to: outingStudentText.rx.outingCount)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.lateRank }
            .bind(
                to: tardyCollectionView.rx.items(cellIdentifier: "homeCell", cellType: HomeCollectionViewCell.self)
            ) { ip, item, cell in
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
                let url = URL(string: item.profileUrl ?? "")
                cell.userProfileImage.kf.setImage(with: url, placeholder: UIImage(named: "DummyImage.svg"))
                cell.studentName.text = item.name
                cell.studentNum.text = "\(item.studentNum.grade)\(item.studentNum.classNum)\(item.studentNum.number)"
            }.disposed(by: disposeBag)
        
    }
}
