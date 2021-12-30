//
//  ContentView.swift
//  Shared
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI
import ActivityIndicatorView

struct ContentView: View {
    @EnvironmentObject var controller: Controller

    @FocusState private var textInputFocused: Bool
    @State private var textInput: String = ""
    @State private var previousInput: String = ""
    
    @ScaledMetric private var size: Double = 20
    
    private var selected: [Character] {
        controller.selectedLetters
            + Array(repeating: " ", count: 9 - controller.selectedLetters.count)
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        LetterGrid()
                            .padding()
                        
                        Spacer()
                        
                        VStack {
                            ForEach(3...9, id: \.self) { length in
                                WordLinkButton(length)
                            }
                        }
                        .padding()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ActivityIndicatorView(isVisible: .constant(true), type: .default)
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.indigo)
                        Spacer()
                    }
                    Spacer()
                }
                .background(.ultraThinMaterial)
                .opacity(controller.isLoading ? 1 : 0)
            }
            .background(
                TextInput()
            )
            .navigationTitle("Wordsmyther")
            .background(Color.indigo.opacity(0.2))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #elseif os(macOS)
//            .frame(width: 400)
            #endif
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EraseButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    GenerateButton()
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
        HStack {
            Spacer()

            VStack {
                HStack {
                    LetterGridItem(selected[0])
                    LetterGridItem(selected[1])
                    LetterGridItem(selected[2])
                }
                HStack {
                    LetterGridItem(selected[3])
                    LetterGridItem(selected[4])
                    LetterGridItem(selected[5])
                }
                HStack {
                    LetterGridItem(selected[6])
                    LetterGridItem(selected[7])
                    LetterGridItem(selected[8])
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: textInputFocused ? .indigo : .clear, radius: 2)
            )

            Spacer()
        }
        .onTapGesture {
            withAnimation {
                textInputFocused.toggle()
            }
        }
    }
    
    private func LetterGridItem(_ letter: Character) -> some View {
        Text("\(letter.description)")
            .font(.body)
            .foregroundColor(.indigo)
            .frame(width: size, height: size)
            .padding()
            .onTapGesture {
                withAnimation {
                    controller.deselect(letter)
                }
            }
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
    
    private func WordLinkButton(_ length: Int) -> some View {
        NavigationLink {
            WordsView(length: length)
        } label: {
            HStack {
                Text("\(length)")
                    .padding(8)
                    .background(
                        Circle()
                            .fill(.indigo.opacity(0.1))
                    )
                Text("Letters")

                Spacer()

                Text("\(controller.words[length]?.count ?? 0)")
                    .font(.caption)
                Text("words")
                    .font(.caption)

                Image(systemName: "chevron.right")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
            )
        }
        .foregroundColor(.indigo)
        .opacity(controller.hasChanges ? 0.5 : 1)
        .disabled(controller.hasChanges)
    }

    private func EraseButton() -> some View {
        Button {
            withAnimation {
                controller.clearSelected()
            }
        } label: {
            Label("Erase", systemImage: "xmark")
                .font(.caption2)
                .foregroundColor(.indigo)
                .padding(8)
            #if os(iOS)
                .labelStyle(.iconOnly)
                .background(
                    Circle()
                        .fill(.indigo.opacity(0.1))
                )
            #else
                .labelStyle(.titleAndIcon)
            #endif
        }
        .opacity(controller.selectedLetters.count > 0 ? 1 : 0)
        .disabled(controller.isLoading) // TODO: should actually allow it and cancel the task
    }
    
    private func GenerateButton() -> some View {
        Button {
            withAnimation {
                controller.generateWords()
            }
        } label: {
            Label("Generate", systemImage: "character.textbox")
                .font(.caption2)
                .foregroundColor(.indigo)
                .padding(8)
            #if os(iOS)
                .labelStyle(.iconOnly)
                .background(
                    Circle()
                        .fill(.indigo.opacity(0.1))
                )
            #else
                .labelStyle(.titleAndIcon)
            #endif
        }
        .opacity(
            (controller.selectedLetters.count < 9 || controller.isLoading) ? 0 : 1
        )
        .disabled(controller.isLoading)
    }
}
