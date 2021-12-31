//
//  ContentView.swift
//  Shared
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI
import ActivityIndicatorView

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSize

    @ObservedObject private var controller: Controller = .init()

    @FocusState private var textInputFocused: Bool
    @State private var textInput: String = ""
    
    @ScaledMetric private var size: Double = 20
    
    private var selected: [Character] {
        controller.selectedLetters
            + Array(repeating: " ", count: 9 - controller.selectedLetters.count)
    }

    var body: some View {
        NavigationView {
            ZStack {
                MainScreen()
                ActivityOverlay()
            }
            .background(
                TextInput()
            )
            .navigationTitle("Wordsmyther")
            .background(WordsmytherApp.tintColor.opacity(0.2))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #elseif os(macOS)
//            .frame(width: 400)
            #endif
            .toolbar {
                ToolbarItem(placement: horizontalSize == .compact ? .navigationBarLeading : .bottomBar) {
                    EraseButton()
                }

                ToolbarItem(placement: horizontalSize == .compact ? .navigationBarTrailing : .bottomBar) {
                    GenerateButton()
                }
            }
            
            #if os(macOS)
            EmptyView()
                .background(WordsmytherApp.tintColor)
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
    
    private func MainScreen() -> some View {
        ScrollView {
            VStack {
                LetterGrid()
                
                Spacer()
                
                VStack {
                    ForEach(3...9, id: \.self) { length in
                        WordLinkButton(length)
                    }
                }
                .padding()
            }
        }
    }

    private func LetterGrid() -> some View {
        HStack {
            Spacer()

            VStack {
                HStack {
                    LetterGridItem(0)
                    LetterGridItem(1)
                    LetterGridItem(2)
                }
                HStack {
                    LetterGridItem(3)
                    LetterGridItem(4)
                    LetterGridItem(5)
                }
                HStack {
                    LetterGridItem(6)
                    LetterGridItem(7)
                    LetterGridItem(8)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: textInputFocused ? WordsmytherApp.tintColor : .clear, radius: 2)
            )

            Spacer()
        }
        .padding()
        .onTapGesture {
            withAnimation {
                textInputFocused.toggle()
            }
        }
    }
    
    private func LetterGridItem(_ index: Int) -> some View {
        Text("\(selected[index].description)")
            .font(.body)
            .foregroundColor(WordsmytherApp.tintColor)
            .frame(width: size, height: size)
            .padding()
            .onTapGesture {
                withAnimation {
                    controller.gridTapped(at: index)
                }
            }
    }
    
    private func TextInput() -> some View {
        TextField("Letter", text: $textInput)
            .focused($textInputFocused)
            .opacity(0)
            .onChange(of: textInput) { newValue in
                withAnimation {
                    controller.inputUpdated(newValue)
                }
            }
            .onSubmit {
                withAnimation {
                    controller.inputSubmitted()
                }
            }
            .onReceive(controller.$selectedLetters) { newValue in
                textInput = String(newValue)
            }
    }
    
    private func WordLinkButton(_ length: Int) -> some View {
        NavigationLink {
            WordsView(length: length)
                .environmentObject(controller)
        } label: {
            HStack {
                Text("\(length)")
                    .padding(8)
                    .background(
                        Circle()
                            .fill(WordsmytherApp.tintColor.opacity(0.1))
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
        .foregroundColor(WordsmytherApp.tintColor)
        .opacity(controller.hasChanges ? 0.5 : 1)
        .disabled(controller.hasChanges)
    }
    
    private func ActivityOverlay() -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ActivityIndicatorView(isVisible: .constant(true), type: .default)
                    .foregroundColor(WordsmytherApp.tintColor)
                    .frame(width: 50.0, height: 50.0)
                    .padding()
                Text("Loading")
                Text("(This may take a minute)")
                    .font(.caption)
                Spacer()
            }
            Spacer()
        }
        .background(.ultraThinMaterial)
        .opacity(controller.isLoading ? 1 : 0)
    }

    private func EraseButton() -> some View {
        Button {
            withAnimation {
                controller.eraseButtonTapped()
            }
        } label: {
            Label("Erase", systemImage: "xmark")
                .font(.caption2)
                .foregroundColor(WordsmytherApp.tintColor)
                .padding(8)
            #if os(iOS)
                .labelStyle(.iconOnly)
                .background(
                    Circle()
                        .fill(WordsmytherApp.tintColor.opacity(0.1))
                )
            #else
                .labelStyle(.titleAndIcon)
            #endif
        }
        .opacity(
            (controller.selectedLetters.count < 1 || controller.isLoading) ? 0 : 1
        )
        .disabled(controller.isLoading)
    }
    
    private func GenerateButton() -> some View {
        Button {
            withAnimation {
                controller.generateButtonTapped()
            }
        } label: {
            Label("Generate", systemImage: "character.textbox")
                .font(.caption2)
                .foregroundColor(WordsmytherApp.tintColor)
                .padding(8)
            #if os(iOS)
                .labelStyle(.iconOnly)
                .background(
                    Circle()
                        .fill(WordsmytherApp.tintColor.opacity(0.1))
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
