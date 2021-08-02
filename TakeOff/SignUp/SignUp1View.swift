import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SignUpViewAttributes {
    func setUI()
}

class SignUp1View: UIViewController {
    
    var user: User
    
    let backgroundView: UIView = {
        let view = UIImageView(image: UIImage(named: "background"))
        return view
    }()
    
    let chooseLabel: UILabel = {
       let lb = UILabel()
        lb.text = "가입 유형을 선택해주세요"
        lb.textColor = UIColor.mainColor
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    let artistButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "profile_image"), for: .normal)
        bt.setTitle("Artist", for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.titleLabel?.font = .boldSystemFont(ofSize: 12)
        bt.contentHorizontalAlignment = .center
        bt.semanticContentAttribute = .forceLeftToRight
        bt.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        bt.tag = 0
        bt.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return bt
    }()
    
    let peopleButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "profile_image"), for: .normal)
        bt.setTitle("People", for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.titleLabel?.font = .boldSystemFont(ofSize: 12)
        bt.contentHorizontalAlignment = .center
        bt.semanticContentAttribute = .forceLeftToRight
        bt.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        bt.tag = 1
        bt.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return bt
    }()
    
    @objc func buttonClick(sender: UIButton) {
        if sender.tag == 0 {
            user.type = true
        } else {
            user.type = false
        }
        let vc = SignUp2View(user: user)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    init() {
        self.user = User()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    

}

extension SignUp1View: SignUpViewAttributes {
    
    func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        makeStackView()
    }
    
    func makeStackView() {
        let buttonStackView = UIStackView(arrangedSubviews: [artistButton, peopleButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 15
        buttonStackView.distribution = .fillEqually
        
        let mainStackView = UIStackView(arrangedSubviews: [chooseLabel, buttonStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 15
        mainStackView.distribution = .fillEqually
        
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.centerX.centerY.equalToSuperview()
        }

    }
    
}
