//
//  OpenAIModelType.swift
//  
//
//  Created by Tyler Wysocki on 2/1/23.
//


import Foundation

/// Model type used to generate output
public enum OpenAIModelType {
    /// ``GPT3`` Models
    case gpt3(GPT3)
    
    /// ``Codex`` Models
    case codex(Codex)
    
    /// ``Feature`` Models
    case feature(Feature)
    
    /// ``Chat`` Models
    case chat(Chat)
    
    /// ``Embedding`` Models
    case embedding(Embedding)
    
    /// Other Custom Models
    case other(String)
    
    public var modelName: String {
        switch self {
        case .gpt3(let model): return model.rawValue
        case .codex(let model): return model.rawValue
        case .feature(let model): return model.rawValue
        case .chat(let model): return model.rawValue
        case .embedding(let model): return model.rawValue
        case .other(let modelName): return modelName
        }
    }
    
    
    /// Models that understand & generate natural language:
    ///
    /// [GPT-3 Models OpenAI API Docs](https://beta.openai.com/docs/models/gpt-3)
    public enum GPT3: String {
        
        /// Most capable GPT-3 model:
        /// - Can do any task the other models can do, often with higher quality
        /// - Longer output and better instruction-following
        /// - Supports inserting completions within text
        ///
        /// > Model: text-davinci-003
        case davinci = "text-davinci-003"
        
        /// A very capable model.
        /// - Faster and lower cost than GPT3 ``davinci``.
        ///
        /// > Model: text-curie-001
        case curie = "text-curie-001"
        
        /// A model capable of Straightforward tasks
        /// - Very fast
        /// - Lower cost
        ///
        /// > Model: text-babbage-001
        case babbage = "text-babbage-001"
        
        /// - Fastest model in the GPT-3 series (usually),
        /// - Simple tasks
        /// - Lowest cost.
        ///
        /// > Model: text-ada-001
        case ada = "text-ada-001"
    }
    
    
    /// Set of models that understands and generates code. (Also capable of translating natural language to code)
    ///
    /// [Codex Models OpenAI API Docs](https://beta.openai.com/docs/models/codex)
    ///
    ///  >  Limited Beta
    public enum Codex: String {
        /// Most capable Codex model:
        ///  - Great at translating natural language to code
        ///  - Completes code
        ///  - Supports inserting completions in code.
        ///
        /// > Model: code-davinci-002
        case davinci = "code-davinci-002"
        
        /// Not quite as capable as ``davinci`` Codex, but slightly faster.
        ///
        /// > Model: code-cushman-001
        case cushman = "code-cushman-001"
    }
    
    
    /// Feature-specific models.
    ///
    ///  For example, using the Edits endpoint requires a specific data model
    ///
    ///  [API Docs](https://beta.openai.com/docs/guides/completion/editing-text)
    public enum Feature: String {
        
        /// > Model: text-davinci-edit-001
        case davinci = "text-davinci-edit-001"
    }
    
    /// Models for the new chat completions
    ///
    /// [API Docs](https://platform.openai.com/docs/api-reference/chat/create)
    public enum Chat: String {
        
        /// Most capable GPT-3.5 model
        /// - optimized for chat at 10% of the cost of text-davinci-003.
        ///
        /// > Model Name: gpt-3.5-turbo
        case chatgpt = "gpt-3.5-turbo"
        
        /// Snapshot of gpt-3.5-turbo from March 1st 2023.
        ///
        /// > Model Name: gpt-3.5-turbo-0301
        case chatgpt0301 = "gpt-3.5-turbo-0301"
    }
    
    
    /// Models for the embedding
    ///
    /// [API Docs](https://platform.openai.com/docs/api-reference/embeddings)
    public enum Embedding: String {
        
        /// The new model, text-embedding-ada-002,
        /// - Replaces five separate models for:
        ///     - Text search
        ///     - Text similarity
        ///     - Code search
        /// - Outperforms Davinci (at most tasks)
        /// - Priced 99.8% lower.
        ///
        /// > Model Name: text-embedding-ada-002
        case ada = "text-embedding-ada-002"
    }
}
