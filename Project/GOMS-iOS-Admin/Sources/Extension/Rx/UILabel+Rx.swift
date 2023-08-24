import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UILabel {
    var outingCount: Binder<Int> {
        Binder(base) { label, outingCount in
            label.text = "\(outingCount) 명이 외출중이에요!"
            label.textColor = UIColor.black
            label.font = GOMSAdminFontFamily.SFProText.medium.font(size: 16)
            let fullText = label.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(outingCount)")
            attribtuedString.addAttribute(
                .foregroundColor,
                value: GOMSAdminAsset.mainColor.color,
                range: range
            )
            label.attributedText = attribtuedString
        }
    }
}
