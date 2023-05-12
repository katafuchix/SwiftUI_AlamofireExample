//
//  CustomTrigger.swift
//  SwiftUI_AlamofireExample
//
//  Created by cano on 2023/05/12.
//

import Foundation
import Combine

class CustomTrigger {
    private let subject = PassthroughSubject<Void, Never>()
    
    var publisher: AnyPublisher<Void, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func trigger() {
        subject.send(())
    }
}
