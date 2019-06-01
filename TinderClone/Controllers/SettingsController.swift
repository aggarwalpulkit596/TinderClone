//
//  SettingsController.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 01/06/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit

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
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
}
