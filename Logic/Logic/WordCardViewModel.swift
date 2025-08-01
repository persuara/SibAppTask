//
//  WordCardViewModel.swift
//  WordCardViewModel
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import Foundation
import DataLayer
import Model
import SwiftData
import Combine
import SwiftUI

public enum WordCardViewModelAction {
    case save(_ word: String, meaning: String)
    case compare(_ card: WordCard, input: String)
    case delete(_ card: WordCard)
}

public enum TransactionState {
    case none
    case failure(_ error: Error)
}

public class WordCardViewModel: NSObject, ObservableObject {
    
    @Published public private(set) var cards: [WordCard] = []
    @Published public private(set) var xp: Int = 0
    @Published public private(set) var totalCount: Int = 1
    @Published public private(set) var state: TransactionState = .none
    
    private let wordCardRepository: PersistentWordCardRepositoryProtocol
    private let incrementaionPoint: Int
    
    public init(container: ModelContainer, incrementaionPoint: Int) {
        self.incrementaionPoint = incrementaionPoint
        self.wordCardRepository = PersistentWordCardRepository(container: container)
        super.init()
        
        refresh()
    }
    
    public func dispatch(_ action: WordCardViewModelAction) {
        switch action {
        case .save(let word, let meaning):
            addCard(word: word, meaning: meaning)
        case .compare(let card, let input):
            checkAnswer(for: card, userInput: input)
        case .delete(let card):
            delete(card)
        }
    }
    
    
    @discardableResult
    internal func addCard(word: String, meaning: String) -> WordCard? {
        let normalizedWord = normalizeForStorage(word)
        let normalizedMeaning = normalizeForStorage(meaning)
        let model = WordCard(word: normalizedWord, meaning: normalizedMeaning)
        do {
            try wordCardRepository.insert(model)
            cards.append(model)
            refresh()
            return model
        } catch {
            state = .failure(error)
            return nil
        }
    }
    
    private func refresh(order: SortOrder = .forward) {
        do {
            cards = try wordCardRepository.retreiveAll(order: order)
            xp = cards.filter({ $0.status == .correct }).count * incrementaionPoint
            totalCount = cards.count * incrementaionPoint
        } catch {
            state = .failure(error)
        }
    }
    
    internal func delete(_ card: WordCard) {
        do {
            guard let card = try wordCardRepository.retrieve(card.id) else { return }
            try wordCardRepository.delete(card.id)
            refresh()
        } catch {
            state = .failure(error)
        }
       }
    
    
    @discardableResult
    internal func checkAnswer(for card: WordCard, userInput: String) -> Bool {
        do {
            guard let card = try wordCardRepository.retrieve(card.id) else { return false }
            let result = normalizedCompare(card.meaning, userInput)
            try wordCardRepository.update(card.id, status: result ? .correct : .incorrect)
            refresh()
            return result
        } catch {
            state = .failure(error)
            return false
        }
    }
    
    internal func normalizeForStorage(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased(with: .current)
            .folding(options: [.diacriticInsensitive], locale: .current)
    }
    
    internal func normalizedCompare(_ canonical: String, _ userInput: String) -> Bool {
        normalizeForStorage(canonical) == normalizeForStorage(userInput)
    }
}


