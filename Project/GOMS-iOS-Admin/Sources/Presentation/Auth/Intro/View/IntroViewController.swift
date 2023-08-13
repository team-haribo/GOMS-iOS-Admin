import UIKit
import Then
import SnapKit
import GAuthSignin
import RxCocoa
import RxSwift

class IntroViewController: BaseViewController<IntroViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        gauthButtonSetUp()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = IntroViewModel.Input(
            loginWithNumberButtonTap: loginWithNumberButton.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
    }
    
    private let logoImage = UIImageView().then {
        $0.image = UIImage(named: "IntroLogo.svg")
    }
    
    private let explainText = UILabel().then {
        $0.text = "간편한 수요 외출제 서비스"
        $0.font = GOMSIOSAdminFontFamily.SFProText.bold.font(size: 20)
        $0.textColor = .black
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "수요 외출제")
        attribtuedString.addAttribute(
            .foregroundColor,
            value: GOMSIOSAdminAsset.mainColor.color,
            range: range
        )
        $0.attributedText = attribtuedString
    }
    
    private let subExplainText = UILabel().then {
        $0.text = "앱으로 간편하게 GSM의 \n수요 외출제를 이용해 보세요!"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = GOMSIOSAdminFontFamily.SFProText.medium.font(size: 16)
        $0.textColor = UIColor(
            red: 121/255,
            green: 121/255,
            blue: 121/255,
            alpha: 1
        )
    }
    
    private let gauthSignInButton = GAuthButton(auth: .signin, color: .colored, rounded: .default)
    
    private let cannotLoginText = UILabel().then {
        $0.text = "GAuth가 안된다면?"
        $0.font = GOMSIOSAdminFontFamily.SFProText.medium.font(size: 12)
        $0.textColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.6
        )
    }
    
    private let loginWithNumberButton = UIButton().then {
        $0.setTitle(
            "인증번호로 로그인",
            for: .normal
        )
        $0.setTitleColor(
            UIColor(
                red: 46/255,
                green: 128/255,
                blue: 204/255,
                alpha: 0.8
            ),
            for: .normal
        )
        $0.titleLabel?.font = GOMSIOSAdminFontFamily.SFProText.medium.font(size: 12)
    }
    
    private func gauthButtonSetUp() {
        gauthSignInButton.prepare(
            clientID: Bundle.module.object(forInfoDictionaryKey: "CLIENT_ID") as? String ?? "",
            redirectURI: Bundle.module.object(forInfoDictionaryKey: "REDIREDCT_URI") as? String ?? "",
            presenting: self
        ) { code in
//            self.viewModel.gauthSignInCompleted(code: code)
        }
    }
    
    override func addView() {
        [
            logoImage,
            explainText,
            subExplainText,
            gauthSignInButton,
            cannotLoginText,
            loginWithNumberButton
        ].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset((bounds.height) / 7.31)
            $0.centerX.equalToSuperview()
        }
        explainText.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
        }
        subExplainText.snp.makeConstraints {
            $0.top.equalTo(explainText.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        gauthSignInButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).inset(96)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(60)
        }
        cannotLoginText.snp.makeConstraints {
            $0.top.equalTo(gauthSignInButton.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset((bounds.width) / 4)
        }
        loginWithNumberButton.snp.makeConstraints {
            $0.top.equalTo(gauthSignInButton.snp.bottom).offset(14)
            $0.leading.equalTo(cannotLoginText.snp.trailing).offset(8)
            $0.height.equalTo(cannotLoginText.snp.height)
        }
    }
}

