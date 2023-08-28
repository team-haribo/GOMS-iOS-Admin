import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: LoginWithNumberViewController {
    var isHidden: Binder<Bool> {
        Binder(base) { base, isHidden in
            base.numberTextField.isHidden = isHidden
            base.completeButton.isHidden = isHidden
        }
    }
}
