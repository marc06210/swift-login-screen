//
//  demoLoginScreenApp.swift
//  demoLoginScreen
//
//  Created by Marc Guerrini on 29/06/2022.
//

import SwiftUI

@main
struct demoLoginScreenApp: App {

    @AppStorage("loggedIn") var loggedIn: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("lastAuthenticationSuccessDate") var lastAuthenticationSuccessDate: Date?
    

    var body: some Scene {
        WindowGroup {
            if loggedIn {
                ContentView()
            } else {
                LoginScreenView()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                let now = Date()
                print("scene becomes active at \(now) with status \(loggedIn)")
                let oldStatus = loggedIn
                // clean up resources, stop timers, etc.
                loggedIn = false
                guard let lastAuthenticationSuccessDate = lastAuthenticationSuccessDate else {
                    return
                }

                let minutes = Calendar.current.dateComponents([.minute], from: lastAuthenticationSuccessDate, to: now).minute!

                print("last connection occured \(minutes) minutes ago")
                if minutes < 1 && oldStatus == true {
                    loggedIn = true
                }
            }
        }
    }
}

// this is to be able to save a Date into the AppStorage, the data needs to conform to RawRepresentable
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
