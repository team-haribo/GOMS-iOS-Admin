import UIKit
import Then
import SnapKit
import GAuthSignin
import RxCocoa
import RxSwift

class OutingViewController: BaseViewController<OutingReactor> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        [].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
    }
}
