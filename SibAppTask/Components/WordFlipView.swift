//
//  WordFlipView.swift
//  SibAppTask
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import Foundation
import SwiftUI
import Model
import Logic

struct WordFlipView: View {

    private struct UI {
        
        static let padding: CGFloat = 12
        static let headerItemPadding: CGFloat = 16
        static let iconSize: CGFloat = 24.0
        static let cardStrokeWidth: CGFloat = 0.5
        static let fieldHeight: CGFloat = 40
    }
    
    private enum Localizations: String {
        case word
        case meaning
        case correct
        case incorrect
        case yourGuess
        case submit
        
        var rawValue: String {
            switch self {
            case .word: return "Word"
            case .meaning: return "Meaning"
            case .correct: return "Correct"
            case .incorrect: return "Incorrect"
            case .yourGuess: return "Your guessing..."
            case .submit: return "Submit"
            }
        }
    }
    
    private var buttonIsDisabled: Bool {
        meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @State var meaning: String = ""
    @Binding var isFlipped: Bool

    var model: WordCard
    var tag: Int
    var onReturn: (WordCard, String) -> Void
    var onDelete: (WordCard) -> Void

    // MARK: - Body
    var body: some View {
        FlippableView(front: {
            VStack(spacing: UI.padding) {
                HStack {
                    Text("\(Localizations.word.rawValue):")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding(UI.headerItemPadding)

                    Spacer()

                    Image(systemName: "trash.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: UI.iconSize, height: UI.iconSize)
                        .padding(UI.headerItemPadding)
                        .contentShape(Rectangle())
                        .onTapGesture { onDelete(model) }
                }

                Text(model.word)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(UI.headerItemPadding)

                configure(state: model.status)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, UI.padding)
            .background(
                RoundedRectangle(cornerRadius: UI.padding, style: .continuous)
                    .fill(Color(.tertiarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: UI.padding, style: .continuous)
                    .strokeBorder(.gray, lineWidth: UI.cardStrokeWidth)
            )
        }, back: {
            VStack(spacing: UI.padding) {
                HStack {
                    Text("\(Localizations.meaning.rawValue):")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding(UI.headerItemPadding)
                    Spacer()
                }

                Text(model.meaning)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(UI.headerItemPadding)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, UI.padding)
            .background(
                RoundedRectangle(cornerRadius: UI.padding, style: .continuous)
                    .fill(Color(.tertiarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: UI.padding, style: .continuous)
                    .strokeBorder(.gray, lineWidth: UI.cardStrokeWidth)
            )
        }, isFlipped: $isFlipped)
    }

    @ViewBuilder
    private func configure(state: ResultStatus) -> some View {
        switch state {
        case .awaiting:
            HStack {
                TextField(Localizations.yourGuess.rawValue, text: $meaning)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .font(.caption)
                    .frame(height: UI.fieldHeight)
                    .padding(.horizontal, UI.padding)
                    .background(
                        RoundedRectangle(cornerRadius: UI.padding, style: .continuous)
                            .fill( Color(.systemGroupedBackground))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: UI.padding, style: .continuous))
                    .submitLabel(.done)
                    .onSubmit { onReturn(model, meaning) }
                    .accessibilityLabel("Your Gessing field")
                    .accessibilityHint("Enter Your Gessing here in this field")
                    .accessibilityIdentifier("GuessField+\(tag)")
                Spacer()
                Button(action: {
                    onReturn(model, meaning)
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: UI.iconSize, height: UI.iconSize)
                        
                })
                .font(.callout)
                .disabled(buttonIsDisabled)
                .accessibilityLabel("Submit Button")
                .accessibilityHint("After you have entered you guessing you can submit you result")
                .accessibilityIdentifier("SubmitButton+\(tag)")
            }
        case .correct:
            Label(Localizations.correct.rawValue, systemImage: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundStyle(.green)
                .multilineTextAlignment(.center)

        case .incorrect:
            Label(Localizations.incorrect.rawValue, systemImage: "xmark.circle.fill")
                .font(.subheadline)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)

        @unknown default:
            EmptyView()
        }
    }
}

