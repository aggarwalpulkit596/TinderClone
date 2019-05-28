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

class CardViewModel {
    
    let imageNames : [String]
    let attributtedString : NSAttributedString
    let textAlignment : NSTextAlignment
    
    init(imageName : [String],attributtedString:NSAttributedString,
         textAlignment : NSTextAlignment) {
        self.imageNames = imageName
        self.attributtedString = attributtedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0{
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex,image ?? UIImage())
        }
    }
    
    //ReactiveProgramming
    var imageIndexObserver:((Int,UIImage)  -> ())?
    
     func advanceToNextPhoto(){
        imageIndex = min(imageIndex +  1,imageNames.count - 1)
    }
    
     func goToPreviosPhoto(){
        imageIndex = max(0,imageIndex - 1)
    }

}



