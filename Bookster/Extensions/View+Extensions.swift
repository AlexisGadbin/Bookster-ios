//
//  View+Extensions.swift
//  Bookster
//
//  Created by Alexis Gadbin on 13/03/2025.
//

import SwiftUI
import Combine

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func onChange<T: Equatable>(
        of value: T,
        debounceFor dueTime: TimeInterval,
        perform action: @escaping (T) -> Void
    ) -> some View {
        modifier(DebouncedChangeModifier(value: value, dueTime: dueTime, action: action))
    }
}

private struct DebouncedChangeModifier<T: Equatable>: ViewModifier {
    let value: T
    let dueTime: TimeInterval
    let action: (T) -> Void

    @State private var debounceCancellable: AnyCancellable?

    func body(content: Content) -> some View {
        content
            .onAppear {
                let publisher = Just(value)
                    .removeDuplicates()
                    .debounce(for: .seconds(dueTime), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()

                debounceCancellable = publisher
                    .sink(receiveValue: action)
            }
            .onChange(of: value) { newValue in
                let publisher = Just(newValue)
                    .removeDuplicates()
                    .debounce(for: .seconds(dueTime), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()

                debounceCancellable = publisher
                    .sink(receiveValue: action)
            }
    }
}
