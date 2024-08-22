//
//  AnimationModifier.swift
//  ProfitPath
//
//  Created by Jaspreet Malak on 8/22/24.
//

import SwiftUI

struct FadeTransition: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1 : 0)
            .animation(.easeInOut(duration: 0.5), value: isActive)
    }
}

extension AnyTransition {
    static var fade: AnyTransition {
        .modifier(
            active: FadeTransition(isActive: true),
            identity: FadeTransition(isActive: false)
        )
    }
}
