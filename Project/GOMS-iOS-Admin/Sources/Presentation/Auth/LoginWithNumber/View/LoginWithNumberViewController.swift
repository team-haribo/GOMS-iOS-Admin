import UIKit
import SnapKit
import Then
import RxCocoa
import RxFlow

class LoginWithNumberViewController: BaseViewController<LoginWithNumberReactor>{

    private let loginWithNumberText = UILabel().then {
        $0.text = "로그인"
        $0.font = GOMSAdminFontFamily.SFProText.bold.font(size: 32)
        $0.textColor = UIColor.black
    }
    
    private let subText = UILabel().then {
        $0.text = "이메일로 인증번호가 발송됩니다."
        $0.font = GOMSAdminFontFamily.SFProText.regular.font(size: 16)
        $0.textColor = GOMSAdminAsset.subColor.color
    }
    
    var emailTextField = LoginWithNumberTextField(
        placeholder: "s21031@gsm.hs.kr",
        width: 16
    )
    
    var confirmationButton = UIButton().then {
        $0.setTitle("인증", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.medium.font(size: 14)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = GOMSAdminAsset.mainColor.color
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
    }
    
    var numberTextField = LoginWithNumberTextField(
        placeholder: "인증번호를 입력하세요",
        width: 16
    ).then {
        $0.isHidden = true
    }
    
    var completeButton = UIButton().then {
        $0.setTitle(
            "인증하기",
            for: .normal
        )
        $0.setTitleColor(
            UIColor.white,
            for: .normal
        )
        $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.bold.font(size: 16)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(
            red: 171/255,
            green: 202/255,
            blue: 248/255,
            alpha: 1
        )
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.isHidden = true
    }

    override func addView() {
        [
            loginWithNumberText,
            subText,
            confirmationButton,
            emailTextField,
            numberTextField,
            completeButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        loginWithNumberText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 6.10)
            $0.leading.equalTo(view.snp.leading).offset(26)
        }
        subText.snp.makeConstraints {
            $0.top.equalTo(loginWithNumberText.snp.bottom).offset(8)
            $0.leading.equalTo(view.snp.leading).offset(26)
        }
        confirmationButton.snp.makeConstraints {
            $0.top.equalTo(subText.snp.bottom).offset(50)
            $0.height.equalTo(52)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo((bounds.width) / 4.8)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(subText.snp.bottom).offset(50)
            $0.height.equalTo(52)
            $0.leading.equalToSuperview().offset(26)
            $0.width.equalTo((bounds.width) / 1.6)
        }
        numberTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).inset(50)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    }
    
    // MARK: - Reactor

    override func bindAction(reactor: LoginWithNumberReactor) {
        confirmationButton.rx.tap
            .map{LoginWithNumberReactor.Action.confirmationButtonDidTap(
                email: self.emailTextField.text ?? ""
            )}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        numberTextField.rx.controlEvent(.editingChanged)
            .map {LoginWithNumberReactor.Action.numberIsTyping}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindView(reactor: LoginWithNumberReactor) {
        completeButton.rx.tap
            .map { LoginWithNumberReactor.Action.loginWithNumberCompleted(
                email: self.emailTextField.text ?? "",
                authCode: self.numberTextField.text ?? ""
            )}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindState(reactor: LoginWithNumberReactor) {
        reactor.state
            .map { $0.numberTextFieldIsHidden }
            .bind(to: self.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.numberIsTyping }
            .bind(to: self.rx.numberIsTyping)
            .disposed(by: disposeBag)
    }
}
