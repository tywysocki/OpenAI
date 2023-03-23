//  
//  Created by Tyler Wysocki - ChatMessage.swift
//

import Foundation

/// Enumeration of possible roles in a chat conversation.
public enum ChatRole: String, Codable {
    /// Role for the system that manages the chat interface.
    case system
    /// Role for the user who initiates the chat.
    case user
    /// Role for the artificial assistant who responds to the user.
    case assistant
}

/// Structure representing a single message in a chat conversation.
public struct ChatMessage: Codable {
    /// Role of the message sender.
    public let role: ChatRole
    /// Content of the message.
    public let content: String

    /// Creates a new chat message with a given role and content.
    /// - Parameters:
    ///   - role: The role of the message sender.
    ///   - content: Content of the message.
    public init(role: ChatRole, content: String) {
        self.role = role
        self.content = content
    }
}

/// Structure representing a chat conversation.
public struct ChatConversation: Encodable {
    /// Name or identifier of the user who initiates the chat (optional if not provided).
    let user: String?

    /// Messages to generate chat completions for.
    let messages: [ChatMessage]

    /// The ID of the model used by the assistant to generate responses.
    let model: String

    /// A parameter that controls how random or deterministic the responses are, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. Optional, defaults to 1.
    let temperature: Double?

    /// A parameter that controls how diverse or narrow-minded the responses are, between 0 and 1. Higher values like 0.9 mean only the tokens comprising the top 90% probability mass are considered, while lower values like 0.1 mean only the top 10%. Optional, defaults to 1.
    let topProbabilityMass: Double?

    /// How many chat completion choices to generate for each input message. Optional, defaults to 1.
    let choices: Int?

    /// Array of up to 4 sequences where the API will stop generating further tokens (optional).
    let stop: [String]?

    /// Max number of tokens to generate in the chat completion.
    let maxTokens: Int?

    /// A parameter that penalizes new tokens based on whether they appear in the text so far, between -2 and 2. Positive values increase the model's likelihood to talk about new topics. Optional if not specified by default or by user input. Optional, defaults to 0.
    let presencePenalty: Double?

    /// A parameter that penalizes new tokens based on their existing frequency in the text so far, between -2 and 2. Positive values decrease the model's likelihood to repeat the same line verbatim. Optional if not specified by default or by user input. Optional, defaults to 0.
    let frequencyPenalty: Double?

    /// Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID in the OpenAI Tokenizer—not English words) to an associated bias value from -100 to 100. Values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
    let logitBias: [Int: Double]?

    enum CodingKeys: String, CodingKey {
        case user
        case messages
        case model
        case temperature
        case topProbabilityMass = "top_p"
        case choices = "n"
        case stop
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
    }
}
