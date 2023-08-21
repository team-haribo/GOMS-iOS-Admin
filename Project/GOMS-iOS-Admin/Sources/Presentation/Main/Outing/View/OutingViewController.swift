import UIKit
import Then
import SnapKit
import GAuthSignin
import RxCocoa
import RxSwift

class OutingViewController: BaseViewController<OutingReactor> {
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        super.viewDidLoad()
    }
    
    override func addView() {
        [].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
    }
    
    // MARK: - Reactor
    
    override func bind(reactor: OutingReactor) {
        navigationItem.rightBarButtonItem?.rx.tap
            .map { OutingReactor.Action.profileButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
