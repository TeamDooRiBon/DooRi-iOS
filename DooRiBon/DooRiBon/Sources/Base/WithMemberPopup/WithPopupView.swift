//
//  withPopupView.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/14.
//
import UIKit

class WithPopupView: UIView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    private var profileList: [Profile] = [] {
        didSet {
            memberCollectionView.reloadData()
            changeLabel()
        }
    }
    private var groupId: String = ""
    
    fileprivate lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.pointOrange.color
        button.setTitleColor(Colors.white9.color, for: .normal)
        button.titleLabel?.font = UIFont.SpoqaHanSansNeo(.medium, size: 15)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private var eventHandler: ((_ type: EventType) -> Void)?
    
    enum ButtonArrangeType {
        case vertical
        case horizontal
    }
    
    enum EventType {
        case confirm
        case cancel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.isHidden = true
        descriptionLabel.isHidden = true
        
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        
        memberCollectionView.register(NibConstants.MemberPopupNib, forCellWithReuseIdentifier: "MemberPopupCollectionViewCell")
        
    }
    
    func setProfileData(id: String)
    {
        GetMemberProfileDataService.shared.getPersonInfo(groupId: id) { (response) in
            switch(response)
            {
            case .success(let profileData):
                if let data = profileData as? [Profile] {
                    self.profileList = data
                    print(self.profileList)
                }
            case .requestErr(let message):
                print("requestERR", message)
            case .pathErr:
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func setGroupId(id: String) -> Self {
        setProfileData(id: id)
        return self
    }
    
    func present(_ eventHandler: @escaping ((_ type: EventType) -> Void)) {
        self.eventHandler = eventHandler
        DispatchQueue.main.async {
            self.frame = UIScreen.main.bounds
            AppDelegate.currentKeyWindow?.addSubview(self)
            UIApplication.topViewController()?.view.endEditing(false)
            self.moveIn()
        }
    }
    
    func setTitle(_ text: String) -> Self {
        titleLabel.isHidden = false
        titleLabel.text = text
        return self
    }
    
    func setDescription(_ text: String) -> Self {
        descriptionLabel.isHidden = false
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 18
        style.minimumLineHeight = 18
        let content = NSAttributedString(string: text, attributes: [.paragraphStyle: style])
        descriptionLabel.attributedText = content
        return self
    }
    
    func setButtonsArrange(_ type: ButtonArrangeType) -> Self {
        buttonsStackView.axis = type == .horizontal ? .horizontal : .vertical
        return self
    }
    
    func setConfirmButton(_ text: String = "확인") -> Self {
        confirmButton.setTitle(text, for: .normal)
        buttonsStackView.addArrangedSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        return self
    }
    
    func changeLabel() {
        descriptionLabel.text = "총 \(profileList.count)명"
    }
    
    @objc private func confirmAction(_ sender: UIButton) {
        closeView(.confirm)
    }
    
    private func closeView(_ type: EventType) {
        eventHandler?(type)
        moveOut()
    }
    
    private func moveOut() {
        UIView.animate(withDuration: 0.15) {
            self.alpha = 0
            self.containerView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    private func moveIn() {
        self.alpha = 0.0
        self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        self.containerView.alpha = 0.0
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.05) {
                self.containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.containerView.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.containerView.transform = CGAffineTransform.identity
                }
            }
        }
    }
}

extension WithPopupView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let memberCell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberPopupCollectionViewCell.identifier, for: indexPath) as? MemberPopupCollectionViewCell else {return UICollectionViewCell() }
        
        memberCell.setData(imageName: profileList[indexPath.row].profileImage,
                           memberName: profileList[indexPath.row].name)
        
        return memberCell
    }
    
    
}

extension WithPopupView: UICollectionViewDelegate
{
    
}

extension WithPopupView: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width      // 현재 사용하는 기기의 width를 가져와서 저장
        let cellWidth = width * (121/375)            // 제플린에서의 비율만큼 곱해서 width를 결정
        let cellHeight = cellWidth * (40/121)        // 제플린에서의 비율만큼 곱해서 height를 결정
        
        return CGSize(width: cellWidth, height: cellHeight)     // 정해진 가로/세로를 CGSize형으로 return
    }
    
    // ContentInset 메서드: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero    //  Inset을 사용하지 않는다는 뜻
    }
    
    // minimumLineSpacing 메서드: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    // minimumInteritemSpacing 메서드: Cell 들의 좌,우 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
