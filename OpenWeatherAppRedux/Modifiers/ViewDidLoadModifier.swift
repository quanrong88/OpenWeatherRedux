//
//  ViewDidLoadModifier.swift
//  OpenWeatherAppRedux
//
//  Created by Tạ Minh Quân on 28/05/2023.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    private let action: () -> Void

    @State private var didLoad = false

    init(_ action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if !didLoad {
                didLoad.toggle()
                action()
            }
        }
    }
}
