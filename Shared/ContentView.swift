//
//  ContentView.swift
//  Shared
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: Controller

    @FocusState private var textInputFocused: Bool
    @State private var textInput: String = ""
    @State private var previousInput: String = ""
    
    private var selected: [Character] {
        var chars = controller.selectedLetters
        
        chars.append(contentsOf: Array(repeating: " ", count: 9 - chars.count))
        
        return chars
    }

    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                VStack {
                    LetterGrid()
                        .padding()
                    
                    Spacer()
                    
                    
                }
                Spacer()
            }
            .background(
                TextInput()
            )
            .navigationTitle("Wordsmyther")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.indigo.opacity(0.2))
            #elseif os(macOS)
//            .frame(width: 400)
            #endif
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    EraseButton()
                }
            }
            
            #if os(macOS)
            EmptyView()
            #endif
        }
        .navigationViewStyle(.automatic)
        #if os(iOS)
        .onTapGesture {
            withAnimation {
                hideKeyboard()
            }
        }
        #endif
    }

    private func LetterGrid() -> some View {
        GeometryReader { proxy in
            LazyVGrid(columns: Array.init(repeating: .init(), count: 3)) {
                ForEach(self.selected, id: \.self) { letter in
                    Text("\(letter.description)")
                        .font(.body)
                        .foregroundColor(.indigo)
                        .padding()
                        .onTapGesture {
                            withAnimation {
                                controller.select(letter)
                            }
                        }
                }
            }
            .padding()
            .frame(
                width: proxy.size.width,
                height: proxy.size.width
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: textInputFocused ? .indigo : .clear, radius: 2)
            )
            .onTapGesture {
                withAnimation {
                    textInputFocused.toggle()
                }
            }
        }
        .frame(maxWidth: 350)
    }
    
    private func TextInput() -> some View {
        TextField("Letter", text: $textInput)
            .focused($textInputFocused)
            .opacity(0)
            .onReceive(controller.$selectedLetters) { newValue in
                textInput = String(controller.selectedLetters)
//                print("sel:   ", textInput)
                if textInput.count < previousInput.count {
                    previousInput = textInput.uppercased()
                }
            }
            .onChange(of: textInput) { newValue in
                guard newValue.uppercased() != previousInput.uppercased() else { return }
//                print("")
//                print("prev:  ", previousInput)
//                print("new:   ", newValue)
                
                let value = newValue.uppercased()
                var letter: Character
                
                if newValue.count > previousInput.count {
                    letter = value.last ?? " "
                } else {
                    letter = previousInput.last ?? " "
                }
                
                previousInput = textInput.uppercased()
                withAnimation {
                    controller.select(letter)
                }
            }
    }
    
    @ViewBuilder
    private func EraseButton() -> some View {
        if controller.selectedLetters.count > 0 {
            Button {
                withAnimation {
                    controller.clearSelected()
                }
            } label: {
                Label("Erase", systemImage: "xmark")
                    .font(.caption2)
                    .foregroundColor(.indigo)
                    .padding(6)
                #if os(iOS)
                    .labelStyle(.iconOnly)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.indigo.opacity(0.1))
                    )
                #else
                    .labelStyle(.titleAndIcon)
                #endif
            }
        } else {
            Button {} label: { EmptyView() }
                .opacity(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
