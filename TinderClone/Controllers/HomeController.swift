//
//  ViewController.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    
//    let cardViewModels : [CardViewModel] = {
//        let producers = [
//        User(name: "Preksha", age: 22, profession: "Nalli", imageNames: ["kelly1","kelly2","kelly3"]),
//        User(name: "Aayushi", age: 23, profession: "Pyschologist", imageNames: ["jane1","jane2","jane3"])
//    ] as [ProdocuesCardViewModel]
//        let viewModels = producers.map({return $0.toCardViewModel()})
//        return viewModels
//    }()
    
    var cardViewModels = [CardViewModel]() //empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        buttonsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        fetchUsers()
    }
    
    @objc func handleSettings(){
        let registrationController  = RegistrationController()
        present(registrationController,animated: true)
    }
    
    @objc func handleRefresh(){
       self.fetchUsers()
    }
    
    var lastFetchedUser : User?
    
    fileprivate func fetchUsers(){
        let hud = JGProgressHUD.init(style: .dark)
        hud.textLabel.text = "Fetching User..."
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(at: [lastFetchedUser?.uid ?? ""]).limit(to: 1)
            query.getDocuments { (snapshot, err) in
                hud.dismiss()
            if let err = err {
                print("Error getting users :",err)
                return
            }
            snapshot?.documents.forEach({ (docSnapshot) in
                let userDictinoary = docSnapshot.data()
                let user = User(dictionary : userDictinoary)
                self.lastFetchedUser = user
                self.cardViewModels.append(user.toCardViewModel())
                self.setupCardForUser(user: user)
            })
//            self.setupDummyCards()
        }
    }
    
    fileprivate func setupCardForUser(user:User) {
//        cardViewModels.forEach{(cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = user.toCardViewModel()
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
//        }
   
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}


