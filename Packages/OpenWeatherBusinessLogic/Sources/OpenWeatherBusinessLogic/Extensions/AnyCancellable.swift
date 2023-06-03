//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 05/05/2023.
//

import Foundation
import Combine

extension AnyCancellable {
    func store(in dictionary: inout [UUID: AnyCancellable], key: UUID) {
        dictionary[key] = self
    }
}
