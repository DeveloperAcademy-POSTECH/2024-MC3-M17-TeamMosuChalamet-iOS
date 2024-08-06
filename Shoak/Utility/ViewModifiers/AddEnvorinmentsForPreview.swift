//
//  AddEnvorinmentsForPreview.swift
//  Shoak
//
//  Created by 정종인 on 7/30/24.
//

import SwiftUI

struct AddEnvorinmentsForPreview: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(NavigationManager.shared)
            .environment(AccountManager.shared)
            .environment(ShoakDataManager.shared)
            .environment(InvitationManager.shared)
    }
}

extension View {
    func addEnvironmentsForPreview() -> some View {
        modifier(AddEnvorinmentsForPreview())
    }
}
