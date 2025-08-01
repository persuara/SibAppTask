//
//  AddCardModalView.swift
//  SibAppTask
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import SwiftUI

public struct AddCardModalView: View {
    
    private struct UI {
        static let headerVerticalPadding: CGFloat = 12
        static let headerHorizontalPadding: CGFloat = 24
        static let closeIconSize: CGFloat = 24
        static let closeIconTapPadding: CGFloat = 16

        static let formCornerRadius: CGFloat = 16
        static let formHorizontalPadding: CGFloat = 12
        static let fieldHorizontalPadding: CGFloat = 20

        static let buttonMinHeight: CGFloat = 44
        static let buttonCornerRadius: CGFloat = 12
        static let buttonHorizontalPadding: CGFloat = 24
    }
    
    private enum Localizations: String {
        case addNewCard
        case word
        case meaning
        case save
        
        var rawValue: String {
            switch self {
            case .addNewCard: return "Add New Card"
            case .word: return "Word"
            case .meaning: return "Meaning"
            case .save: return "Save"
            }
        }
    }

    @Environment(\.dismiss) private var dismiss

    @State private var animateForm: Bool = false
    @State private var animateHStack: Bool = false
    @State private var animateButton: Bool = false
    @State private var word: String = ""
    @State private var meaning: String = ""

    private var buttonMustBeDisabed: Bool {
        word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public let onSave: (_ word: String, _ meaning: String) -> Void

    public var body: some View {
        VStack {
            HStack {
                Text(Localizations.addNewCard.rawValue)
                    .padding(.vertical, UI.headerVerticalPadding)
                    .padding(.horizontal, UI.headerHorizontalPadding)
                    .multilineTextAlignment(.leading)
                    .font(.title3)
                Spacer()
                Image(systemName: "xmark")
                    .frame(width: UI.closeIconSize, height: UI.closeIconSize)
                    .padding(UI.closeIconTapPadding)
                    .onTapGesture { dismiss() }
            }
            .blurSlider(animateHStack)
            
            Form {
                TextField(Localizations.word.rawValue, text: $word)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, UI.fieldHorizontalPadding)
                    .accessibilityLabel("Word field")
                    .accessibilityHint("Add your word here")
                    .accessibilityIdentifier("WordField")
                    

                TextField(Localizations.meaning.rawValue, text: $meaning)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, UI.fieldHorizontalPadding)
                    .accessibilityLabel("Meaning field")
                    .accessibilityHint("Add your meaning here")
                    .accessibilityIdentifier("MeaningField")
            }
            .clipShape(RoundedRectangle(cornerRadius: UI.formCornerRadius, style: .continuous))
            .padding(.horizontal, UI.formHorizontalPadding)
            .blurSlider(animateForm)

            Button {
                let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedMeaning = meaning.trimmingCharacters(in: .whitespacesAndNewlines)
                onSave(trimmedWord, trimmedMeaning)
                dismiss()
            } label: {
                Text(Localizations.save.rawValue)
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: UI.buttonMinHeight)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: UI.buttonCornerRadius, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: UI.buttonCornerRadius, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(buttonMustBeDisabed)
            .padding(.horizontal, UI.buttonHorizontalPadding)
            .accessibilityIdentifier("Save")
            .accessibilityLabel("Save")
            .accessibilityHint("Attempts to save the input data")
            .blurSlider(animateButton)

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .task {
            guard !animateForm else { return }
            
            
            await performDelayed(0.1) {
                animateHStack = true
            }
            
            await performDelayed(0.1) {
                animateForm = true
                animateButton = true
            }
        }
    }
    
    private func performDelayed(_ delay: TimeInterval, animation: @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        
        withAnimation(.smooth) {
            animation()
        }
    }
}


#Preview {
    AddCardModalView(onSave: { _, _ in})
}
