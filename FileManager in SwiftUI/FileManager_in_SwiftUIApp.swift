//
//  FileManager_in_SwiftUIApp.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI

@main
struct FileManager_in_SwiftUIApp: App {

    var body: some Scene {
        WindowGroup {
            NoteListView()
                .environmentObject(DataProvider.shared)
                .accentColor(.red)
        }
    }
}
