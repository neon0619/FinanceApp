//
//  View+Navigation.swift
//  FinanceApp
//
//  Created by Christopher Castillo on 10/13/22.
//

import SwiftUI

extension View {
    @ViewBuilder
    func embedInNavigation() -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                self
            }
        } else {
            NavigationView {
                self
            }
        }
    }
}
