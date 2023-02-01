//
//  File 4.swift
//  
//
//  Created by Tyler Wysocki on 2/1/23.
//

import Foundation

class Instruction: Encodable {
    var instruction: String
    var model: String
    var input: String
    
    init(instruction: String, model: String, input: String) {
        self.instruction = instruction
        self.model = model
        self.input = input
    }
    
    enum CodingKeys: String, CodingKey {
        case instruction
        case model
        case input
    }
}
