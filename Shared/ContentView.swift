//
//  ContentView.swift
//  Shared
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: Controller

    @ScaledMetric private var letterFrame: Double = Double(ScreenSize.width) / 25

    @FocusState private var textInputFocused: Bool
    @State private var textInput: String = ""
    
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
                        .frame(width: letterFrame*12)
                        .padding()
                    
                    Spacer()
                }
                Spacer()
            }
            .background(Color.indigo.opacity(0.2))
            .background(
                TextInput()
            )
            .navigationTitle("Wordsmyther")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    EraseButton()
                }
            }
        }
        .navigationViewStyle(.automatic)
        .background(Color.indigo.opacity(0.2))
        #if os(iOS)
        .onTapGesture {
            withAnimation {
                hideKeyboard()
            }
        }
        #endif
    }

    private func LetterGrid() -> some View {
        LazyVGrid(columns: Array.init(repeating: .init(), count: 3)) {
            ForEach(self.selected, id: \.self) { letter in
                Text("\(letter.description)")
                    .font(.body)
                    .foregroundColor(.indigo)
                    .frame(width: letterFrame, height: letterFrame)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            controller.select(letter)
                        }
                    }
            }
        }
        .padding()
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
    
    private func TextInput() -> some View {
        TextField("Letter", text: $textInput)
//            .keyboardType(.default)
            .focused($textInputFocused)
            .opacity(0)
            .onChange(of: textInput) { newValue in
                guard newValue.count > 0,
                      let letter = newValue.uppercased().first else { return }

                withAnimation {
                    controller.select(letter)
                }
                textInput = ""
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
