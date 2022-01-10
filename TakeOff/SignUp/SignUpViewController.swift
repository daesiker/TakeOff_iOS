//
//  DefaultSignUpViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/01/06.
//

import UIKit
import RxSwift
import RxCocoa
import AVFAudio

class SignUpViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let vm = SignUpViewModel()
    
    lazy var scrollView:UIScrollView = UIScrollView(frame: .zero).then {
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.layoutIfNeeded()
    }
    
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    
    let backBt = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "btBack"), for: .normal)
    }
    
    let welcomeLabel = UILabel().then {
        $0.text = "환영합니다!"
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        $0.textColor = UIColor.rgb(red: 101, green: 101, blue: 101)
    }
    
    let titleLabel = UILabel().then {
        $0.attributedText = NSAttributedString(string: "한페이지로\n끝내는 회원가입").withLineSpacing(6)
        $0.font = UIFont(name: "GodoM", size: 26)
        $0.textColor = UIColor.rgb(red: 101, green: 101, blue: 101)
        $0.numberOfLines = 2
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let emailTextField = CustomTextField(image: UIImage(named: "tfEmail")!, text: "이메일 주소 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }
    
    let emailAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let pwLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let pwTextField = CustomTextField(image: UIImage(named: "tfPassword")!, text: "영문자와 숫자 포함 8자 이상 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        $0.isSecureTextEntry = true
    }
    
    let pwAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let pwConfirmLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let pwConfirmTextField = CustomTextField(image: UIImage(named: "tfPassword")!, text: "다시 한번 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        $0.isSecureTextEntry = true
    }
    
    let pwConfirmAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let nameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let nameTextField = CustomTextField(image: UIImage(named: "tfPeople")!, text: "닉네임 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        $0.isSecureTextEntry = true
    }
    
    let nameAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let typeLabel = UILabel().then {
        $0.text = "가입 유형"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let artistBt = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.setTitle("아티스트", for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.setTitleColor(UIColor.rgb(red: 55, green: 57, blue: 61), for: .normal)
        $0.layer.cornerRadius = 20.0
        $0.contentEdgeInsets = UIEdgeInsets(top: 16, left: 61, bottom: 15, right: 61)
    }
    
    let peopleBt = UIButton(type: .custom).then {
        $0.setTitle("일반인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.setTitleColor(UIColor.rgb(red: 55, green: 57, blue: 61), for: .normal)
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.layer.cornerRadius = 20.0
        $0.contentEdgeInsets = UIEdgeInsets(top: 16, left: 61, bottom: 15, right: 61)
    }
    
    let hashTagLabel = UILabel().then {
        $0.text = "관심 분야"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let hashtagCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let hashTagData = Observable<[String]>.of(["#전체", "#버스킹", "#밴드", "#힙합", "#인디", "#공예", "#전시", "#디지털", "#패션", "#기타"])
    let hashTagDomy = ["#전체", "#버스킹", "#밴드", "#힙합", "#인디", "#공예", "#전시", "#디지털", "#패션", "#기타"]
    
    let signInBt = UIButton(type: .custom).then {
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = UIColor.rgb(red: 195, green: 195, blue: 195)
            $0.layer.cornerRadius = 27.0
            $0.contentEdgeInsets = UIEdgeInsets(top: 15, left: 134, bottom: 13, right: 131)
            $0.isEnabled = false
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCV()
        setUI()
        bind()
    }
    
}

extension SignUpViewController {
    
    private func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        safeView.addSubview(backBt)
        backBt.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 950)
        safeView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backBt.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(33)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(emailAlert)
        emailAlert.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwLabel)
        pwLabel.snp.makeConstraints {
            $0.top.equalTo(emailAlert.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwTextField)
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(pwLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(pwAlert)
        pwAlert.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwConfirmLabel)
        pwConfirmLabel.snp.makeConstraints {
            $0.top.equalTo(pwAlert.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwConfirmTextField)
        pwConfirmTextField.snp.makeConstraints {
            $0.top.equalTo(pwConfirmLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(pwConfirmAlert)
        pwConfirmAlert.snp.makeConstraints {
            $0.top.equalTo(pwConfirmTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(pwConfirmAlert.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(nameAlert)
        nameAlert.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(nameAlert.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(25)
        }
        
        let typeStackView = UIStackView(arrangedSubviews: [artistBt, peopleBt]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 28
        }
        
        scrollView.addSubview(typeStackView)
        typeStackView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(hashTagLabel)
        hashTagLabel.snp.makeConstraints {
            $0.top.equalTo(typeStackView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(hashtagCollectionView)
        hashtagCollectionView.snp.makeConstraints {
            $0.top.equalTo(hashTagLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
            $0.height.equalTo(220)
        }
        
        scrollView.addSubview(signInBt)
        signInBt.snp.makeConstraints {
            $0.top.equalTo(hashtagCollectionView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
    }
    
    private func bind() {
        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        emailTextField.rx.controlEvent([.editingDidEnd])
            .map { self.emailTextField.text ?? "" }
            .bind(to: vm.input.emailObserver)
            .disposed(by: disposeBag)
        
        pwTextField.rx.controlEvent([.editingDidEnd])
            .map { self.pwTextField.text ?? "" }
            .bind(to: vm.input.pwObserver)
            .disposed(by: disposeBag)
        
        pwConfirmTextField.rx.controlEvent([.editingDidEnd])
            .map { self.pwConfirmTextField.text ?? "" }
            .bind(to: vm.input.pwConfirmObserver)
            .disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent([.editingDidEnd])
            .map { self.nameTextField.text ?? "" }
            .bind(to: vm.input.nameObserver)
            .disposed(by: disposeBag)
        
        artistBt.rx.tap
            .map { TypeValid.artist }
            .bind(to: vm.input.typeObserver)
            .disposed(by: disposeBag)
        
        peopleBt.rx.tap
            .map { TypeValid.person }
            .bind(to: vm.input.typeObserver)
            .disposed(by: disposeBag)
        
        
    }
    
    private func bindOutput() {
        
    }
}

extension SignUpViewController: UICollectionViewDelegateFlowLayout {
    
    private func setCV() {
        hashtagCollectionView.delegate = nil
        hashtagCollectionView.dataSource = nil
        hashtagCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        hashtagCollectionView.register(HashTagCell.self, forCellWithReuseIdentifier: "cellID")
        hashTagData
            .bind(to: hashtagCollectionView.rx.items(cellIdentifier: "cellID", cellType: HashTagCell.self)) { row, element, cell in
                cell.title.text = element
            }.disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 94) / 3
        return CGSize(width: width, height: 42)
    }
    
}

extension SignUpViewController: UIScrollViewDelegate {
    
    private func setSV() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @objc func myTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: Methods to manage keybaord
    @objc func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    
}



class HashTagCell: UICollectionViewCell {
    
    let view = UIView().then {
        $0.backgroundColor = UIColor.rgb(red: 255, green: 238, blue: 211)
        $0.layer.cornerRadius = 23.5
    }
    
    let title = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        $0.textColor = UIColor.rgb(red: 108, green: 108, blue: 108)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
