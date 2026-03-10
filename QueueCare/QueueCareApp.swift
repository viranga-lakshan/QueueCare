//
//  QueueCareApp.swift
//  QueueCare
//
//  Created by test on 2026-03-09.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct QueueCareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var controller = QueueController()

    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(controller: controller)
                .onOpenURL { url in
                    _ = Auth.auth().canHandle(url)
                }
        }
    }
}
