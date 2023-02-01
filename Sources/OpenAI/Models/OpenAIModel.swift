//
//  File 3.swift
//  
//
//  Created by Tyler Wysocki on 2/1/23.
//

import Foundation

public struct OpenAIModel: Codable {
    public let object: String
    public let model: String?
    public let choices: [Choice]
}

public struct Choice: Codable {
    public let text: String
}
