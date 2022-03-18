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
    
    @State private var alertTitle   = ""
    @State private var alertMessage = ""
    @State private var presentAlert = false
    
    
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
            .toolbar(content: {
                Button("New Word"){
                    startGame()
                }
            })
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(alertTitle, isPresented: $presentAlert) {
                Button("OK", role: .cancel) {}
            }message: {
                Text(alertMessage)
            }
        }
    }
    
    
    func startGame() {
        if let startGameURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startGameWords = try? String(contentsOf: startGameURL) {
            let allWords    = startGameWords.components(separatedBy: "\n")
            rootWord        = allWords.randomElement() ?? "wormwood"
                return
            }
        }
        fatalError("failed to grab contents from URL")
    }

    func addNewWord() {
        let answer  = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        guard isNewWord(word: answer) else {
            showAlert(title: "Used word", message: "C'mon! You've used this word already!")
            return
        }
        guard isValid(word: answer) else {
            showAlert(title: "Invalid Word", message: "Words must be used from the letters of the '\(rootWord)' Try again.")
            return
        }
        guard isRealWord(word: answer) else {
            showAlert(title: "Invalid Word", message: "''\(answer)'' isn't a real word! Try again.")
            return
        }
        
        guard isTooShort(word: answer) else {
            showAlert(title: "Too Short", message: "Please enter words that are AT LEAST 3 letters long...")
        return
        }
        
        guard isRootWord(word: answer) else {
            showAlert(title: "Same Word", message: "C'mon, that's already a given!")
            return
        }
        
        withAnimation {
           usedWord.insert(answer, at: 0)
        }
        
        newWord = ""
    }
    
    
    func isNewWord(word: String) -> Bool {
        !usedWord.contains(word)
    }
    
    
    func isValid(word: String) -> Bool{
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else { return false }
        }
        
        return true
    }
    
    
    func isRealWord(word: String) -> Bool {
        let checker         = UITextChecker()
        let range           = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    
    func isTooShort(word: String) -> Bool {
         word.count > 3
    }
    
    
    func isRootWord(word: String) -> Bool {
        word != rootWord
    }
    
    
    func showAlert(title: String, message: String) {
        alertTitle      = title
        alertMessage    = message
        presentAlert    = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
