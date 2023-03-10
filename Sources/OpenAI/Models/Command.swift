//
//  File.swift
//  
//
//  Created by Tyler Wysocki on 2/1/23.
//

import Foundation

class Command: Encodable {
    var prompt: String
    var model: String
    var maxTokens: Int
    
    init(prompt: String, model: String, maxTokens: Int) {
        self.prompt = prompt
        self.model = model
        self.maxTokens = maxTokens
    }
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case maxTokens = "max_tokens"
    }
}
