//
//  User.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit

struct User {
    let name:String
    let age:Int
    let profession:String
    let imageName:String
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font:UIFont.systemFont(ofSize: 32,weight: .heavy)])
        
        attributedText.append(NSAttributedString(string:" \(age)", attributes: [.font:UIFont.systemFont(ofSize: 24,weight: .regular)]))
        
        attributedText.append(NSAttributedString(string:" \n\(profession)", attributes: [.font:UIFont.systemFont(ofSize: 20,weight: .regular)]))
        return CardViewModel(imageName: imageName, attributtedString: attributedText,textAlignment: .left)

    }
}

