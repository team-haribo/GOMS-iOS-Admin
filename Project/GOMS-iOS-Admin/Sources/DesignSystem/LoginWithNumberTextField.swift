import UIKit

public final class LoginWithNumberTextField: UITextField {
    required public init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    convenience init(
        placeholder: String = "",
        width: Int = 0
    ) {
        self.init()
        self.placeholder = placeholder
        self.leftPadding(width: width)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.textColor = .black
        self.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        self.font = GOMSIOSAdminFontFamily.SFProText.regular.font(size: 14)

    }
    
    public override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            self.layer.borderWidth = 1
            self.layer.borderColor = GOMSIOSAdminAsset.mainColor.color.cgColor
        }
        return didBecomeFirstResponder
    }

    public override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        if didResignFirstResponder {
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
        }
        return didResignFirstResponder
    }
}
