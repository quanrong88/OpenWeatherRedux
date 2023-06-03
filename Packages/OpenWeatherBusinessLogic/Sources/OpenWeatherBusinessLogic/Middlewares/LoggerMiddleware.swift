//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 13/05/2023.
//

import Foundation
import Combine

public extension Middlewares {
    static let logger: Middleware<AppState> = { state, action in
        let stateDescription = "\(state)"
        print("➡️ \(action)\n✅ \(stateDescription)\n")

        return Empty().eraseToAnyPublisher()
    }
}
