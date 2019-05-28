//
//  ViewController.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    
    let cardViewModels = [
        User(name: "Preksha", age: 22, profession: "Nalli", imageName: "boost_circle").toCardViewModel(),
        User(name: "Aayushi", age: 23, profession: "Pyschologist", imageName: "lady5c").toCardViewModel()
]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach{(cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.nameLabel.attributedText = cardVM.attributtedString
            cardView.nameLabel.textAlignment = cardVM.textAlignment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
   
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}


