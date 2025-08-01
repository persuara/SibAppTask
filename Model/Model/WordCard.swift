//
//  WordCard.swift
//  WordCard
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//
import Foundation
import SwiftData

public enum ResultStatus: Int {
    case awaiting = -1
    case correct = 1
    case incorrect = 0
}

@Model
public final class WordCard {
    
    @Attribute(.unique) public var id: UUID
    public var word: String
    public var meaning: String
    public var createdAt: Date
    
    private var _status: Int
    
    public var status: ResultStatus {
        get { ResultStatus(rawValue: _status) ?? .awaiting }
        set { _status = newValue.rawValue }
    }
       
    public init(word: String, meaning: String) {
        self.id = .init()
        self.word = word
        self.meaning = meaning
        self._status = ResultStatus.awaiting.rawValue
        self.createdAt = .now
    }
}


