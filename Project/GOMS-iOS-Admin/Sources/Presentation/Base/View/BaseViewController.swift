import UIKit
import RxCocoa
import RxSwift
import Then
import ReactorKit

class BaseViewController<T>: UIViewController {
    let reactor: T
    var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds
    
    init(_ reactor: T) {
        self.reactor = reactor
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = GOMSIOSAdminAsset.background.color
        self.navigationItem.backButtonTitle = ""
        addView()
        setLayout()
        bind(reactor: reactor)
    }
    
    func addView() {
        
    }
    
    func setLayout() {
        
    }
    
    func bind(reactor: T) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindView(reactor: T) {}
    func bindAction(reactor: T) {}
    func bindState(reactor: T) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
