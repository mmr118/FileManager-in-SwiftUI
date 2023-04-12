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
            ContentViewOG()
//            BaseView()
                .accentColor(.red)
        }
    }
}


struct BaseView: View {

    var body: some View {

        TabView {

            ContentView(coordinator: DataProvider.shared)
                .tabItem {
                    Text("DataProvider")
                }

            ContentView(coordinator: StorageManager(base: "notes"))
                .tabItem {
                    Text("StorageManager")
                }
        }
    }
}


// MARK: - Previews
struct BaseView_Previews: PreviewProvider {

    static var previews: some View {
        BaseView()
    }
}
