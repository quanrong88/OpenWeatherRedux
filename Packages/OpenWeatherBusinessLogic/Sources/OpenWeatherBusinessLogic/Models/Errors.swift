//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 14/05/2023.
//

import Foundation

public enum HomeViewError: Error {
    case locationNotFound
    case network(Error)
}
