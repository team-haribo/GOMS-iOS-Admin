import Foundation
import RxFlow
import RxCocoa
import RxSwift
import Moya

class IntroViewModel: BaseViewModel, Stepper{

    struct Input {
        let loginWithNumberButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transVC(input: Input) {
        input.loginWithNumberButtonTap.subscribe(
            onNext: pushLoginWithNumberVC
        ) .disposed(by: disposeBag)
    }
    
    private func pushLoginWithNumberVC() {
        self.steps.accept(GOMSAdminStep.loginWithNumberIsRequired)
    }

}
