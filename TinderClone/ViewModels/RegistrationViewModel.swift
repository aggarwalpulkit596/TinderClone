//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 28/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableisFormValid = Bindable<Bool>()

    
    var fullName: String? {didSet{
        checkFormValidity()
        }
    }
    var email: String? {didSet{
        checkFormValidity()
        }
    }
    var password: String? {didSet{
        checkFormValidity()
        }
    }
    
    fileprivate func checkFormValidity(){
        let isFormVaid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableisFormValid.value = isFormVaid
    }
    
    
}
