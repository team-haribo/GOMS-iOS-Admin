import RxFlow
import UIKit

final class TabBarFlow: Flow {
    
    enum TabIndex: Int {
        case home = 0
        case qrCode = 1
        case outing = 2
    }
    
    var root: Presentable {
        return self.rootVC
    }
    
    private let rootVC = GOMSAdminTabBarViewController()
    
    private var homeFlow = HomeFlow()
    private var qrCodeFlow = QRCodeFlow()
    private var outingFlow = OutingFlow()
    
    init() {}
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GOMSAdminStep else {return .none}
        
        switch step {
        case .tabBarIsRequired:
            return coordinateToTabbar(index: 0)
            
        case .qrocdeIsRequired:
            return coordinateToTabbar(index: 1)
            
        case .outingIsRequired:
            return coordinateToTabbar(index: 2)
            
        case .introIsRequired:
            return .end(forwardToParentFlowWithStep: GOMSAdminStep.introIsRequired)
            
        default:
            return .none
        }
    }
    
}

private extension TabBarFlow {
    func coordinateToTabbar(index: Int) -> FlowContributors {
        Flows.use(
            homeFlow, qrCodeFlow, outingFlow,
            when: .ready
        ) { [unowned self] (root1: UINavigationController,
                            root2: UINavigationController,
                            root3: UINavigationController) in
            let homeItem = UITabBarItem(
                title: "홈",
                image: UIImage(named: "unselectedAdminHome.svg"),
                selectedImage: UIImage(named: "selectedAdminHome.svg")
            )
            
            let qrCodeItem = UITabBarItem(
                title: "외출하기",
                image: UIImage(named: "unselectedAdminQRCode.svg"),
                selectedImage: UIImage(named: "selectedAdminQRCode.svg")
            )
            let outingItem = UITabBarItem(
                title: "외출현황",
                image: UIImage(named: "unselectedAdminOuting.svg"),
                selectedImage: UIImage(named: "selectedAdminOuting.svg")
            )
            root1.tabBarItem = homeItem
            root2.tabBarItem = qrCodeItem
            root3.tabBarItem = outingItem
            
            self.rootVC.setViewControllers([root1,root2,root3], animated: true)
            self.rootVC.selectedIndex = index

        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: GOMSAdminStep.homeIsRequired)),
            .contribute(withNextPresentable: qrCodeFlow, withNextStepper: OneStepper(withSingleStep: GOMSAdminStep.qrocdeIsRequired)),
            .contribute(withNextPresentable: outingFlow, withNextStepper: OneStepper(withSingleStep: GOMSAdminStep.outingIsRequired))
        ])
    }
}
