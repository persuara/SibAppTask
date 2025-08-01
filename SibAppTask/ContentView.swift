//
//  ContentView.swift
//  SibAppTask
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import SwiftUI
import SwiftData
import Logic
import DataLayer
import Model

struct ContentView: View {
    
    @StateObject var vm: WordCardViewModel
    
    @State private var showingAdd = false
    @State private var userInput: String = ""
    @State private var isFlipped: Bool = false
    
    private struct UI {
        static let padding: CGFloat = 24.0
        static let vSpacing: CGFloat = 20.0
        static let maxOffsetViews = 3
        static let offsetYPerLayer: CGFloat = 10
    }
    
    private enum Localizations: String {
        case pocketWords
        
        var rawValue: String {
            switch self {
            case .pocketWords:
                return "PocketWords"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: UI.vSpacing) {
                ProgressView("Xp: \(vm.xp)", value: CGFloat(vm.xp), total: CGFloat(vm.totalCount))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.all, UI.padding / 2.0)
                    .background(
                        RoundedRectangle(cornerRadius: UI.padding / 2.0, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                    )
                    .padding(.all, UI.padding)
                ZStack() {
                    ForEach(vm.cards.indices, id: \.self) { index in
                        let item = vm.cards[index]
                        let depth = vm.cards.count - 1 - index
                        let visibleDepth = min(depth, UI.maxOffsetViews)
                        let isLast = index == (vm.cards.count - 1)
                        
                        WordFlipView(
                            isFlipped: isLast ? $isFlipped : .constant(false),
                            model: item,
                            tag: index,
                            onReturn: { model, input in
                                vm.dispatch(.compare(model, input: input))
                            },
                            onDelete: { model in
                                vm.dispatch(.delete(model))
                            }
                        )
                        .frame(height: 400.0, alignment: .center)
                        .offset(y: CGFloat(visibleDepth) * UI.offsetYPerLayer)
                        .animation(.spring(.smooth, blendDuration: 0.3), value: vm.cards)
                        .zIndex(Double(index))
                        Spacer()
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isFlipped.toggle()
                        }
                    }
                    .padding(.horizontal, UI.padding)
                    .accessibilityLabel(isFlipped ? "Meaning" : "Word")
                    .accessibilityHint("Double tap to flip the card")
                    Spacer()
                }
            }
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationTitle(Localizations.pocketWords.rawValue)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new card")
                    .accessibilityIdentifier("AddNewCard")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddCardModalView { word, meaning in
                    vm.dispatch(.save(word, meaning: meaning))
                }
                .presentationDetents([.fraction(0.4)])
            }
        }
    }
}


#Preview {
    var sharedModelContainer: ModelContainer = {
        do {
            return try ContainerFactory.build()
        } catch {
            print(error)
            fatalError()
        }
    }()
    ContentView(vm: .init(container: sharedModelContainer, incrementaionPoint: 10))
}
