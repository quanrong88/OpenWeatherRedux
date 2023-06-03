//
//  View+Modifier.swift
//  OpenWeatherAppRedux
//
//  Created by Tạ Minh Quân on 28/05/2023.
//

import SwiftUI

extension View {
    func onLoad(_ action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action))
    }
}
