import UIKit
import Then
import SnapKit
import GAuthSignin
import RxCocoa
import RxSwift

class OutingViewController: BaseViewController<OutingReactor> {
    
    private let outingMainText = UILabel().then {
        $0.text = "외출현황"
        $0.font = GOMSAdminFontFamily.SFProText.bold.font(size: 24)
        $0.textColor = .black
    }
    
    private let searchTextField = UITextField().then {
        let placeholderText = "찾으시는 학생이 있으신가요?"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: GOMSAdminFontFamily.SFProText.regular.font(size: 14)
        ]
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        $0.leftPadding(width: 20)
        $0.textColor = .black
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
    }
    
    private lazy var searchButton = UIButton().then {
        $0.isEnabled = true
        $0.backgroundColor = GOMSAdminAsset.mainColor.color
        $0.layer.cornerRadius = 10
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = GOMSAdminFontFamily.SFProText.regular.font(size: 14)
    }
       
    private let layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(
            width: (UIScreen.main.bounds.width - 48),
            height: (90)
        )
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.minimumLineSpacing = 16
    }
       
    private let outingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = true
        $0.backgroundColor = GOMSAdminAsset.background.color
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        
        outingCollectionView.delegate = self
        outingCollectionView.dataSource = self
        outingCollectionView.register(OutingCollectionViewCell.self, forCellWithReuseIdentifier: OutingCollectionViewCell.identifier)

        outingCollectionView.collectionViewLayout = layout
        
        super.viewDidLoad()
    }
    
    override func addView() {
        [
        outingMainText, searchTextField, searchButton, outingCollectionView
        ].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        outingMainText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 7.73)
            $0.leading.equalToSuperview().offset(26)
        }
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(outingMainText.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalToSuperview().inset(113)
            $0.height.equalTo(55)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(outingMainText.snp.bottom).offset(26)
            $0.leading.equalTo(searchTextField.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(55)
        }
        outingCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Reactor
    
    override func bindView(reactor: OutingReactor) {
        super.bindView(reactor: reactor)
        self.rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in OutingReactor.Action.fetchStudentList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func bindAction(reactor: OutingReactor) {
        navigationItem.rightBarButtonItem?.rx.tap
            .map { OutingReactor.Action.profileButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        }
}

extension OutingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor.currentState.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outingCell", for: indexPath) as? OutingCollectionViewCell else {
            fatalError("Could not dequeue cell")
        }
        
//        let outingItem = reactor.currentState.searchResults[indexPath.item]
//        cell.configure(with: outingItem)
        return cell
    }
    
    
}
