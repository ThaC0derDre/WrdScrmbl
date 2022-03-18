//
//  ContentView.swift
//  WrdScrmbl
//
//  Created by Andres Gutierrez on 3/17/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWord = [String]()
    @State private var newWord  = ""
    @State private var rootWord = ""
    
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    TextField("Enter a word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    ForEach(usedWord, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    
    
    func startGame() {
        if let startGameURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startGameWords = try? String(contentsOf: startGameURL) {
            let allWords    = startGameWords.components(separatedBy: "\n")
            rootWord    = allWords.randomElement() ?? "wormwood"
                return
            }
        }
        fatalError("failed to grab contents from URL")
    }

    func addNewWord() {
        let answer  = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
           usedWord.insert(answer, at: 0)
        }
        
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
