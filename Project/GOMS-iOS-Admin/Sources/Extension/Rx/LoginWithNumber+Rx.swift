import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: LoginWithNumberViewController {
    var isHidden: Binder<Bool> {
        Binder(base) { base, isHidden in
            base.numberTextField.isHidden = isHidden
            base.completeButton.isHidden = isHidden
            base.confirmationButton.isEnabled = isHidden
            base.emailTextField.isEnabled = isHidden
            if isHidden == false {
                base.confirmationButton.backgroundColor = UIColor(
                    red: 171/255,
                    green: 202/255,
                    blue: 248/255,
                    alpha: 1
                )
            }
        }
    }
    var numberIsTyping: Binder<Bool> {
        Binder(base) { base, numberIsTyping in
            base.completeButton.backgroundColor = numberIsTyping == true ? GOMSAdminAsset.mainColor.color : UIColor(
                red: 171/255,
                green: 202/255,
                blue: 248/255,
                alpha: 1
            )
            base.numberTextField.rx.controlEvent(.editingDidEnd)
                .asObservable()
                .subscribe(onNext: { _ in
                    base.completeButton.backgroundColor = UIColor(
                        red: 171/255,
                        green: 202/255,
                        blue: 248/255,
                        alpha: 1
                    )
                }).disposed(by: base.disposeBag)
        }
    }
}
