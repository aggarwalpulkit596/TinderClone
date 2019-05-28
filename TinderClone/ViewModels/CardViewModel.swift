//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit


protocol ProdocuesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    let imageNames : [String]
    let attributtedString : NSAttributedString
    let textAlignment : NSTextAlignment

}

