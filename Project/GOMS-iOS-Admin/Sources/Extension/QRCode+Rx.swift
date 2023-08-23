import QRCode
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: QRCodeViewController {
    var urlUUID: Binder<UUID?> {
        Binder(base) { base, uuid in
            base.urlUUID = uuid
            base.createQrCode()
        }
    }
}
