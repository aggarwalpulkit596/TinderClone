//
//  ViewController.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let bottomStackView = HomeBottomControlsStackView()
    let blueView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        blueView.backgroundColor = .blue
        
        setupLayout()
        
    }
    
    //MARK :- Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,blueView,bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}


