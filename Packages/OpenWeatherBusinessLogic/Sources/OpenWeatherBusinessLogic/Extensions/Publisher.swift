//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 14/05/2023.
//

import Foundation
import Combine

extension Publisher {
    func ignoreError() -> AnyPublisher<Output, Never> {
        self
        .catch { _ in Empty() }
        .eraseToAnyPublisher()
    }
}
