import RxFlow
import UIKit

enum GOMSAdminStep: Step {
    
    //MARK: Splash
    case splashIsRequired
    
    // MARK: Auth
    case introIsRequired
    case loginWithNumberIsRequired
    
    // MARK: TabBar
    case tabBarIsRequired
    
    // MARK: Home
    case qrocdeIsRequired
    case outingIsRequired
    case homeIsRequired
    case profileIsRequired
    case studentManagementIsRequired
    case searchButtonIsRequired
    case editIconIsRequired
    
    //MARK: Alert
    case alert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction])
    case failureAlert(title: String?, message: String?, action: [UIAlertAction] = [])
}
