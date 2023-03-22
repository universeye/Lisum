//
//  SearchViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    lazy var searchTextField = LisumTextField(frame: CGRect(x: 0, y: 0, width: screenWidth - 32, height: 60))
    lazy var settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsTapped))
    private let titleLabel = LisumTitleLabel(textAlignment: .left, fontSize: 40)
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "listenMusic1")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTitleLabel()
        configureImageView()
        configureTextField()
        createDismissKBTappedGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = "Lisum"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTextField.frame.origin.y = imageView.frame.origin.y + imageView.frame.height + 16
    }
    
    private func configureVC() {
        view.backgroundColor = LisumColor.bgColor
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        let mainString = "Dicover Music \nin LISUM"
        let stringToColor = "LISUM"
        let range = (mainString as NSString).range(of: stringToColor)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: LisumColor.mainColor, range: range)
        titleLabel.attributedText = mutableAttributedString
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(searchTextField)
        searchTextField.center.x = view.center.x
        searchTextField.delegate = self
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func search() {
        let mediaListViewController = MediaListViewController2(searchTerm: searchTextField.text ?? "No Text")
        navigationController?.pushViewController(mediaListViewController, animated: true)
    }
    
    private func createDismissKBTappedGesture() { //tap anywhere, the keyboard dismiss
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func settingsTapped() {
        print("self.searchTextField.frame.origin.y\(self.searchTextField.frame.origin.y)")
        print("screenHeight = \(screenHeight)")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if searchTextField.frame.origin.y != 440 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.3, delay: 0.0) {
                        self.searchTextField.frame.origin.y = self.screenHeight - keyboardSize.height - self.searchTextField.frame.height - 16
                    }
                }
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.searchTextField.frame.origin.y = self.imageView.frame.origin.y + imageView.frame.height + 16
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}
