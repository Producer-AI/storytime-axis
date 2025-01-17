//
//  storytimeApp.swift
//  storytime
//
//  Created by Amanda Peterson on 12/28/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct storytimeApp: App {
    // Initialize Firebase
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
