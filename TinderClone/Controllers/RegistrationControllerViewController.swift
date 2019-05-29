//
//  RegistrationControllerViewController.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registationViewModel.bindableImage.value = image
    }
}

class RegistrationController: UIViewController {
    
    let selectPhotoButton:UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32,weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Full Name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true //password
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField:UITextField){
        if textField == fullNameTextField {
            registationViewModel.fullName = textField.text
        }else if textField == emailTextField {
            registationViewModel.email = textField.text
        }else {
            registationViewModel.password = textField.text
        }
    }
    
    let registerButton:UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObserver()
        setupTagGesture()
        setupRegistrationObserver()
    }
    
    // MARK:- Private
    
    @objc fileprivate func selectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    
    @objc fileprivate func registerUser() {
        self.handleTapDismiss()
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (res, err) in
            if let err = err {
                print(err)
                self.showHUDWithError(error:err)
                return
            }
        }
    }
    
    fileprivate func showHUDWithError(error:Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    
    let registationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationObserver(){
        registationViewModel.bindableisFormValid.bind { [unowned self](isFormValid) in
            guard let isFormValid =  isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            if(isFormValid){
                self.registerButton.backgroundColor =  #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            }else{
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .disabled)
            }
        }
    
        registationViewModel.bindableImage.bind(observer: { [unowned self](img) in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    fileprivate func setupTagGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)  //dismiss keyboad
    }
    
    fileprivate func setupNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardHide(notification:Notification){
        UIView.animate(withDuration: 0/5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = .identity //transform to original layout
        })
    }

    
    
    @objc fileprivate func handleKeyboardShow(notification:Notification){
        //getting size of keyboard    // how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        // let's try to figure out how tall the gap is from the register button to the bottom of the screen
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews:[
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if(self.traitCollection.verticalSizeClass == .compact){
            overallStackView.axis = .horizontal
        }else{
            overallStackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func setupGradientLayer(){
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        //make sure to use cgColor
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }


}
