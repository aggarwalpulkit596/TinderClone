//
//  SettingsCellTableViewCell.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 01/06/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit

class SettingsCellTableViewCell: UITableViewCell {
    
    class SettingsTextField : UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0,height: 44)
        }
    }
    
    let textField: SettingsTextField = {
        let tf = SettingsTextField()
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
