//
//  StartShoakShortcuts.swift
//  Shoak
//
//  Created by 정종인 on 8/2/24.
//

import Foundation
import AppIntents

final class StartShoakShortcuts: AppShortcutsProvider {
    static var shortcutTileColor = ShortcutTileColor.navy
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartShoakProcess(), phrases: [
            "\(.applicationName) 시작"
        ], shortTitle: "쇽 시작하기", systemImageName: "hand.wave.fill")
    }
}
