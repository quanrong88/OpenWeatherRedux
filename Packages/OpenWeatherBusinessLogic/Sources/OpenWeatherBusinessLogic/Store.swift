//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 05/05/2023.
//

import Foundation
import Combine
import SwiftUI

/// Namespace for Middlewares
public enum Middlewares {}
public protocol Action {}
public struct NoOpAction: Action {}

public typealias Reducer<State> = (State, Action) -> State
public typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

final public class Store<State>: ObservableObject {
    var isEnabled = true

    @Published public var state: State

    private var subscriptions: [UUID: AnyCancellable] = [:]

    private let queue = DispatchQueue(label: "pl.wojciechkulik.ReduxDemo.store", qos: .userInitiated)
    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]

    public init(
        initial state: State,
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>]
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func restoreState(_ state: State) {
        self.state = state
    }

    public func dispatch(_ action: Action) {
        guard isEnabled else { return }

        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)

        middlewares.forEach { middleware in
            let key = UUID()
            middleware(newState, action)
                .receive(on: RunLoop.main)
                .handleEvents(receiveCompletion: { [weak self] _ in self?.subscriptions.removeValue(forKey: key) })
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions, key: key)
        }

        withAnimation {
            state = newState
        }
    }
}
