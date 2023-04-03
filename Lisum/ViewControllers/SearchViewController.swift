//
//  SearchViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    lazy var searchTextField = LisumTextField(frame: CGRect(x: 0, y: 0, width: screenWidth - 32, height: 60))
    lazy var settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsTapped))
    private let titleView = TitleView()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let assets = Assets()
    private var isSearchTextfieldEntered: Bool {
        !searchTextField.text!.isEmpty
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    //MARK: - VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTitleView()
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
    
    //MARK: - Configurations
    private func configureVC() {
        view.backgroundColor = LisumColor.bgColor
//        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func configureTitleView() {
        view.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(searchTextField)
        searchTextField.center.x = view.center.x
        searchTextField.delegate = self
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.image = assets.searchPageIllustrator
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    //MARK: - Functions
    private func search() {
        guard isSearchTextfieldEntered else {
            presentAlert(title: AlertMessage.emptyAlertTitle, messgae: AlertMessage.emptyAlertMessage, buttonTitle: "Ok")
            return
        }
        let mediaListViewController = MediaListViewController(searchTerm: searchTextField.text ?? "No Text")
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
