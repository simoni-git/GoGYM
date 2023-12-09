//
//  extention.swift
//  myGYMapp
//
//  Created by 시모니 on 12/7/23.
//

import UIKit
import Combine

extension UITextField {
    var myKindPublisher: AnyPublisher<String , Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .map{$0.text ?? ""}
            .eraseToAnyPublisher()
            
    }
    
    var myWeightPublisher: AnyPublisher<Double , Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .compactMap { Double($0.text ?? "") }
            .eraseToAnyPublisher()
        
    }
    
    var myCountPublisher: AnyPublisher<Int , Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .compactMap { Int($0.text ?? "") }
            .eraseToAnyPublisher()
        
    }
    
    var mySetPublisher: AnyPublisher<Int , Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .compactMap { Int($0.text ?? "") }
            .eraseToAnyPublisher()
        
    }
}
