//
//  StandupsApp.swift
//  Standups
//
//  Created by David Reed on 2/10/23.
//

import SwiftUI

@main
struct StandupsApp: App {
    // @StateObject private var appModel = AppModel(standupsList: StandupsListModel(standups: [.engineeringMock, .designMock]))
    @StateObject private var appModel = AppModel(standupsList: StandupsListModel())

    var body: some Scene {
        WindowGroup {
            AppView(model: appModel)
        }
    }
}
