//
//  ContentViewOG.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import SwiftUI

struct FFLError: Error {
    let innerError: Error
    let nsError: NSError
    let ffl: FFL
    let userInfo: [String: Any]


    var localizedDescription: String { "\(ffl.description)\n\(innerError.localizedDescription)" }

    init(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
        self.innerError = error
        self.nsError = error as NSError
        self.ffl = FFL(file, function, line)
        var errorInfo = (error as NSError).userInfo
        errorInfo["FFL"] = ffl.description
        errorInfo["errorScript"] = error.localizedDescription
        self.userInfo = errorInfo
    }
}

struct ContentViewOG: View {

    // MARK: - Properties
    @ObservedObject var dataProvider = DataProviderOG.shared

//    @State var selectedUserTab: User.Tab = .all
    @State var currentUser: User = .user_0

    @State private var editMode: EditMode = .inactive
    @State private var isShowingCreateAlert = false
    @State private var titleText = String()
    @State private var detailText = String()

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            ZStack {
                content
                if let error = dataProvider.error {
                    errorContent(error)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 6))
                        .padding(.all, 20)

                }
            }
            .navigationTitle("Notes")
            .toolbar {
                toolbarViews
            }
            .alert("Create UserNote for \(currentUser.name)", isPresented: $isShowingCreateAlert) {
                alertView
            } message: {
                Text("Add a title and some details.")
            }
            .listStyle(InsetListStyle())
            .environment(\.editMode, $editMode)
        }
    }

    var content: some View {
        List {
            ForEach(dataProvider.allNotes) { note in
                noteCell(note)
            }
            .onDelete(perform: dataProvider.delete)
            .onMove(perform: dataProvider.move)
        }
        .onChange(of: currentUser) {
            dataProvider.updateUser($0)
        }
    }

    @ViewBuilder func errorContent(_ error: FFLError) -> some View {
        VStack {
            Text("Error")
                .font(.system(.subheadline))
                .foregroundColor(.red)
            ForEach(error.userInfo.keys.map { $0 }, id: \.self) { key in
                Text("[\(key)] \(error.userInfo[key] == nil ? "nil" : String(describing: error.userInfo[key]!))")
            }
            Button("Dismiss") {
                dataProvider.error = nil
            }
        }
    }

    @ViewBuilder var alertView: some View {
        TextField("Title", text: $titleText)
            .textInputAutocapitalization(.words)
        TextField("Details", text: $detailText)
        Button("Random") {
            titleText = String.randomWord()
            detailText = String.randomWords(5).joined(separator: " ")
            didTapSave()
        }
        Button("OK", action: didTapSave)
        Button("Cancel", role: .cancel, action: resetNoteValues)
    }

    @ToolbarContentBuilder var toolbarViews: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button("+") {
                isShowingCreateAlert.toggle()
            }
            Button("clear all") {
                dataProvider.allNotes.forEach { dataProvider.delete($0) }
            }
        }

        ToolbarItem(placement: .navigationBarLeading) {
            Picker(currentUser.name, selection: $currentUser) {
                ForEach(User.allUsers, id: \.self) { value in
                    Text(value.name).tag(value)
                }
            }
            .pickerStyle(.menu)
        }
    }

    @ViewBuilder private func noteCell(_ note: UserNote) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)

                Text(note.detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(note.user.name)

        }
    }

//    private func filteredNotes() -> [UserNote] {
//        return dataProvider.allNotes.filter { $0.user == currentUser }
//    }

    private func didTapSave() {
        let newNote = UserNote(user: currentUser, titleText, detail: detailText)
        DataProviderOG.shared.create(note: newNote)
        resetNoteValues()
    }

    private func resetNoteValues() {
        titleText = String()
        detailText = String()
    }

}


// MARK: - Previews
struct ContentViewOG_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewOG()
            .previewUpdateTime()
    }
}


// MARK: - DataProviderOG
class DataProviderOG: ObservableObject {

    // MARK: - Propeties
    static let shared = DataProviderOG()
    private let dataSourceURL: URL
    @Published var allNotes = [UserNote]()
    @Published var error: FFLError? = nil

    var currentDir: URL

    // MARK: - Life Cycle
    init(currentUser: User = .user_0) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let userNotesPath = documentsPath.appendingPathComponent("userNotes")
        dataSourceURL = userNotesPath
        currentDir = dataSourceURL.appendingPathComponent(currentUser.name).appendingPathExtension("json")
        _allNotes = Published(wrappedValue: getAllNotes())
    }

    func updateUser(_ newUser: User) {
        saveNotes()
        print(URL.currentDirectory())
        print(FileManager.default.currentDirectoryPath)
        currentDir = dataSourceURL.appendingPathComponent(newUser.name).appendingPathExtension("json")
        self._allNotes = Published(wrappedValue: getAllNotes())
    }

    // MARK: - Methods
    private func getAllNotes() -> [UserNote] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedNotes = try decoder.decode([UserNote].self, from: data)
            return decodedNotes
        } catch {
            self.error = .init(error)
            do {
                try FileManager.default.removeItem(at: currentDir)
            } catch {
                self.error = .init(error)
            }
            return []
        }
    }

    private func saveNotes() {
        print("start")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            FileManager.default.createFile(atPath: currentDir.path(), contents: data, attributes: nil)
//            try data.write(to: currentDir)
        } catch {
            self.error = .init(error)
        }
    }

    func create(note: UserNote) {
        allNotes.insert(note, at: 0)
        saveNotes()
    }

    func changeNote(note: UserNote, index: Int) {
        allNotes[index] = note
        saveNotes()
        allNotes = getAllNotes()
    }

    func delete(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }

    func delete(_ note: UserNote) {
        if let index = allNotes.firstIndex(of: note) {
            allNotes.remove(at: index)
        }
        saveNotes()
    }

    func move(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }
}
