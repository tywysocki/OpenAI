//
//  File 2.swift
//  
//
//  Created by Tyler Wysocki on 2/1/23.
//


import Foundation

/// Model used to generate output
public enum OpenAIModelType {
    /// ``GPT3`` Model Group
    case gpt3(GPT3)
    
    /// ``Codex`` Model Group
    case codex(Codex)
    
    /// ``Feature`` Model Group
    case feature(Feature)
    
    public var modelName: String {
        switch self {
        case .gpt3(let model): return model.rawValue
        case .codex(let model): return model.rawValue
        case .feature(let model): return model.rawValue
        }
    }
    
    /// Models that understand & generate natural language:
    ///
    /// [GPT-3 Models OpenAI API Docs](https://beta.openai.com/docs/models/gpt-3)
    public enum GPT3: String {
        
        /// Most capable GPT-3 model:
        ///  - Can do any task the other models can do, often with higher quality
        ///  - Longer output and better instruction-following
        ///  - Supports inserting completions within text
        ///
        /// > Model: text-davinci-003
        case davinci = "text-davinci-003"
        
        /// A very capable model.
        /// - Faster and lower cost than GPT3 ``davinci``.
        ///
        /// > Model: text-curie-001
        case curie = "text-curie-001"
        
        /// - Straightforward tasks,
        /// - very fast
        /// - lower cost
        ///
        /// > Model: text-babbage-001
        case babbage = "text-babbage-001"
        
        /// - Fastest model in the GPT-3 series (usually),
        /// - Simple tasks
        /// - lowest cost.
        ///
        /// > Model Name: text-ada-001
        case ada = "text-ada-001"
    }
    
    /// - Set of models that understands code
    /// - generates code,
    /// - translates natural language to code
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
        /// > Model Name: code-davinci-002
        case davinci = "code-davinci-002"
        
        /// Not quite as capable as ``davinci`` Codex, but slightly faster.
        ///
        /// > Model Name: code-cushman-001
        case cushman = "code-cushman-001"
    }
    
    /// Feature-specific models.
    ///
    ///
    ///  Read the [API Docs](https://beta.openai.com/docs/guides/completion/editing-text)
    public enum Feature: String {
        
        /// > Model: text-davinci-edit-001
        case davinci = "text-davinci-edit-001"
    }
}
