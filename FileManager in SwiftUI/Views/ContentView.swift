//
//  ContentView.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI
import NMAUtilities

struct ContentView<Value, Coordinator>: View where Coordinator: FileManagerCoordinator, Value == Coordinator.T {

    // MARK: - Properties
    @ObservedObject var coordinator: Coordinator

    @State private var editMode: EditMode = .inactive
    @State private var isShowingCreateAlert = false
    @State private var titleText = String()
    @State private var detailText = String()
    @State private var tagText = String()

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(coordinator.values) { value in
                    valueCell(value)
                }
                .onDelete(perform: coordinator.delete)
                .onMove(perform: moveIfAble)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+") {
                        isShowingCreateAlert.toggle()
                    }
                }
            }
            .alert("Create Note", isPresented: $isShowingCreateAlert) {
                TextField("Title", text: $titleText)
                    .textInputAutocapitalization(.words)
                TextField("Details", text: $detailText)
                if Value.self == TaggedNote.self {
                    TextField("Tag", text: $tagText)
                    ColorPicker("", selection: $color, supportsOpacity: false)
                        .labelsHidden()
                }
                Button("OK", action: didTapSave)
                Button("Cancel", role: .cancel, action: resetNoteValues)
            } message: {
                Text("Add a title and some details.")
            }
            .listStyle(InsetListStyle())
            .environment(\.editMode, $editMode)
            .onAppear {
                printFFL("onAppear")
                coordinator.load()
            }
        }
    }

    @ViewBuilder private func valueCell(_ value: Value) -> some View {
        VStack(alignment: .leading) {
            Text(value.title)
                .font(.headline)

            Text(value.detail)
                .font(.footnote)
                .foregroundStyle(.secondary)

            if let taggedNote = value as? TaggedNote {
                ScrollView {
                    HStack {
                        ForEach(taggedNote.tags.map { $0 }) { value in
                            Text("#" + value.title)
                                .padding()
                                .background {
                                    Capsule(style: .continuous)
                                        .foregroundColor(value.color)
                                }
                        }
                    }
                }

            }
        }
    }

    @State var showColorPicker = false
    @State var color: Color = .clear

    private func didTapSave() {
        let newValue = Value(titleText, detail: detailText)
        if let tagged = newValue as? TaggedNote {
            if color == .clear {
                color = Color.crayonColors.randomElement()!
            }
            let tag = Tag(tagText, color: color)
            tagged.addTag(tag)

        }
        coordinator.save(newValue)
        resetNoteValues()
    }

    private func resetNoteValues() {
        titleText = String()
        detailText = String()
        tagText = String()
        color = .clear
    }

    private func moveIfAble(source: IndexSet, destination: Int) {
        if let dataProvider = coordinator as? DataProvider {
            dataProvider.move(source: source, destination: destination)
        }
    }

}


// MARK: - Previews
struct ContentView_Previews: PreviewProvider {

    static var taggedStorageManager: StorageManager<TaggedNote> = Self.storageManager()
    static var noteStorageManager: StorageManager<Note> = Self.storageManager()


    static var previews: some View {

        TabView {

            ContentView(coordinator: DataProvider.shared)
                .tabItem {
                    Text("DataProvider")
                }

            ContentView(coordinator: taggedStorageManager)
                .tabItem {
                    Text("StorageManager")
                }

        }
        .previewUpdateTime()


        ContentView(coordinator: DataProvider.shared)
            .previewUpdateTime()

        ContentView(coordinator: taggedStorageManager)
            .previewUpdateTime()

    }

}
