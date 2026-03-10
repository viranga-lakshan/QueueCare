//
//  QueueCareApp.swift
//  QueueCare
//
//  Created by test on 2026-03-09.
//

import SwiftUI

@main
struct QueueCareApp: App {
    @StateObject private var controller = QueueController()

    var body: some Scene {
        WindowGroup {
            ContentView(controller: controller)
        }
    }
}
