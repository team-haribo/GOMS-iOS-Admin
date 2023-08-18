import UIKit
import Then
import SnapKit
import GAuthSignin
import RxCocoa
import RxSwift

class QRCodeViewController: BaseViewController<QRCodeReactor> {
    
    var timerLeft = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
            self.timerLeft -= 1
            let minutes = self.timerLeft / 60
            let seconds = self.timerLeft % 60
            if self.timerLeft > 0 {
                self.lastTimer.text = String(format: "%d분 %02d초", minutes, seconds)
            }
            else {
                self.lastTimer.text = "0분 00초"
                self.timerLeft = 300
            }
        })
    }
    
    private let outingText = UILabel().then {
        $0.text = "외출하기"
        $0.font = GOMSIOSAdminFontFamily.SFProText.bold.font(size: 22)
        $0.textColor = .black
    }
    
    private let explainText = UILabel().then {
        $0.text = "모바일 기기로\nQRCode를 스캔한 후 외출해주세요"
        $0.font = GOMSIOSAdminFontFamily.SFProText.medium.font(size: 16)
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let lastTimeText = UILabel().then {
        $0.text = "남은시간"
        $0.textColor = .black
        $0.font = GOMSIOSAdminFontFamily.SFProText.bold.font(size: 16)
    }
    
    private let lastTimer = UILabel().then {
        $0.text = "5분 00초"
        $0.textColor = GOMSIOSAdminAsset.mainColor.color
        $0.font = GOMSIOSAdminFontFamily.SFProText.bold.font(size: 22)
    }
    
    override func addView() {
        [
            outingText,
            explainText,
            lastTimer,
            lastTimeText
        ].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        outingText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 4.95)
            $0.centerX.equalToSuperview()
        }
        explainText.snp.makeConstraints {
            $0.top.equalTo(outingText.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        lastTimeText.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).inset((bounds.height) / 3.34)
            $0.centerX.equalToSuperview()
        }
        lastTimer.snp.makeConstraints {
            $0.top.equalTo(lastTimeText.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
