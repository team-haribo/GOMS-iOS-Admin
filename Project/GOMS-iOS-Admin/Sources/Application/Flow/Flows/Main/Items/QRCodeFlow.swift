import RxFlow
import UIKit
import RxSwift
import RxCocoa

struct QRCodeStepper: Stepper{
    var steps = PublishRelay<Step>()

    var initialStep: Step{
        return GOMSAdminStep.qrocdeIsRequired
    }
}

class QRCodeFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }
    
    var stepper = QRCodeStepper()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init(){}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSAdminStep else { return .none }
        switch step {
            
        case .qrocdeIsRequired:
            return coordinateToQRCode()
            
        case .homeIsRequired:
            return .one(flowContributor: .forwardToParentFlow(withStep: GOMSAdminStep.homeIsRequired))
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSAdminStep.introIsRequired)
            
        case let .alert(title, message, style, actions):
            return presentToAlert(title: title, message: message, style: style, actions: actions)
            
        case let .failureAlert(title, message, action):
            return presentToFailureAlert(title: title, message: message, action: action)
            
        default:
            return .none
        }
    }
    
    private func coordinateToQRCode() -> FlowContributors {
        let vm = QRCodeReactor()
        let vc = QRCodeViewController(vm)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func presentToAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
    
    private func presentToFailureAlert(title: String?, message: String?, action: [UIAlertAction]) -> FlowContributors {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !action.isEmpty {
            action.forEach(alert.addAction(_:))
        } else {
            alert.addAction(.init(title: "확인", style: .default))
        }
        self.rootViewController.topViewController?.present(alert, animated: true)
        return .none
    }
}
