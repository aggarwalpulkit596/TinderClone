//
//  SettingsController.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 01/06/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton : UIButton?
}

class SettingsController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    lazy var imageButton1 = createButton(selector: #selector(handlePhotoSelect))
    lazy var imageButton2 = createButton(selector: #selector(handlePhotoSelect))
    lazy var imageButton3 = createButton(selector: #selector(handlePhotoSelect))
    
    
    func createButton(selector:Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
        
    }
    
    @objc func handlePhotoSelect(button:UIButton){
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
    
    }
    var user: User?
    fileprivate func fetchCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else{ return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            
            guard let dictonary = snapshot?.data() else {return}
            self.user = User(dictionary:dictonary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos(){
        guard let imageUrl = user?.imageUrl1 ,let url = URL(string: imageUrl) else {return}
        
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil){
            (image,_,_,_,_,_) in
            self.imageButton1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    lazy var header : UIView = {
        let header = UIView()
        header.addSubview(imageButton1)
        
        let padding: CGFloat = 16
        imageButton1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageButton1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageButton2,imageButton3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing  = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: imageButton1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    
    class HeaderLabel:UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0){
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1 :
            headerLabel.text = "Name"
        
        case 2 :
            headerLabel.text = "Profession"
        case 3 :
            headerLabel.text = "Age"
        default :
            headerLabel.text = "Bio"
        }
    
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 300
        } else{
            return 40
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 0
        }
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCellTableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.keyboardType = .numberPad
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"

        }
        return cell
    }
    
    @objc fileprivate func handleTextChange(textField:UITextField){
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField:UITextField){
        self.user?.profession = textField.text

    }
    
    @objc fileprivate func handleAgeChange(textField:UITextField){
        self.user?.age = Int(textField.text ?? "")

    }
    
    @objc fileprivate func handleChange(textField:UITextField){
        
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String:Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "profession": user?.profession ?? "",
            "age" : user?.age ?? -1,
            "imageUrl1":user?.imageUrl1 ?? ""]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Settings..."
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData){(err) in
            hud.dismiss()
            if let err = err{
                print("There was some error:",err)
                return
            }
        }
    }
    
    
}
