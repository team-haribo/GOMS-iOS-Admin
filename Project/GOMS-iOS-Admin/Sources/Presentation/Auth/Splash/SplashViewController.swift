import UIKit
import Foundation
import SnapKit
import Then
import ViewAnimator
import RxFlow
import RxCocoa
import RxSwift

final class SplashViewController: UIViewController, Stepper {
    
    var steps = PublishRelay<Step>()
    
    private let gomsRefreshToken = GOMSAdminRefreshToken.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addView()
        setLayout()
        setAnimation()
        navigateToLogin()
    }
    
    private let splashLogo = UIImageView().then {
        $0.image = UIImage(named: "SplashLogo.svg")
    }
    
    private let splashSunImage = UIImageView().then {
        $0.image = UIImage(named: "SplashBearLogo.svg")
    }
    
    private func navigateToLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.gomsRefreshToken.autoLogin {
                switch self.gomsRefreshToken.statusCode {
                case 200..<300:
                    self.steps.accept(GOMSAdminStep.tabBarIsRequired)
                default:
                    print(self.gomsRefreshToken.statusCode)
                    self.steps.accept(GOMSAdminStep.introIsRequired)
                }
            }
        }
    }
    
    private func setAnimation() {
        UIView.animate(views: [
            splashSunImage
        ], animations: [
            AnimationType.from(direction: .bottom, offset: 30)
        ], initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.7, options: .curveEaseInOut)
    }
        
    private func addView() {
        [splashLogo,splashSunImage].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayout() {
        splashLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        splashSunImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(splashLogo.snp.top).inset(12.82)
        }
    }
}
