import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Moya

class BaseViewModel{
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
}
