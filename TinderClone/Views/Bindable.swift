//
//  Bindable.swift
//  TinderClone
//
//  Created by Pulkit Aggarwal on 29/05/19.
//  Copyright © 2019 Pulkit Aggarwal. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet{
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
