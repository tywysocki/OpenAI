import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public enum OpenAIError: Error {
    case genericError(error: Error)
    case decodingError(error: Error)
    case chatError(error: ChatError.Payload)
}

public class OpenAISwift {
    fileprivate(set) var token: String?
    fileprivate let config: Config
    
    /// Configuration object for client
    public struct Config {
        
        /// Initialiser
        /// - Parameter session: session to use for network requests.
        public init(session: URLSession = URLSession.shared) {
            self.session = session
        }

        let session:URLSession
    }
    
    public init(authToken: String, config: Config = Config()) {
        self.token = authToken
        self.config = Config()
    }
}

extension OpenAISwift {
    /// Send Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: Set to `OpenAIModelType.gpt3(.davinci)` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendCompletion(with prompt: String, model: OpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16, temperature: Double = 1, completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.completions
        let body = Command(prompt: prompt, model: model.modelName, maxTokens: maxTokens, temperature: temperature)
        let request = prepareRequest(endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI<TextResult>.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send Edit request to the OpenAI API
    /// - Parameters:
    ///   - instruction: Example: "Fix the spelling mistake"
    ///   - model: The only support model is `text-davinci-edit-001`
    ///   - input: Example: "Me name is Ty"
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "", completionHandler: @escaping (Result<OpenAI<TextResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.edits
        let body = Instruction(instruction: instruction, model: model.modelName, input: input)
        let request = prepareRequest(endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                do {
                    let res = try JSONDecoder().decode(OpenAI<TextResult>.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send Chat request to the OpenAI API
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use, the only support model is `gpt-3.5-turbo`
    ///   - user: A unique identifier representing your end-user (helps OpenAI monitor and detect abuse).
    ///   - temperature: What sampling temperature to use, between 0 and 2. Higher values make the output more random, while lower values make it more focused & deterministic.
    ///   - topProbabilityMass: The OpenAI API equivalent of the "top_p" parameter.
    ///   - choices: How many chat completion choices to generate for each input message.
    ///   - stop: Up to 4 sequences where the API will stop generating further tokens.
    ///   - maxTokens: Max number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens).
    ///   - presencePenalty: Number between -2.0 and 2.0.
    ///   - frequencyPenalty: Number between -2.0 and 2.0. 
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion.
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendChat(with messages: [ChatMessage],
                         model: OpenAIModelType = .chat(.chatgpt),
                         user: String? = nil,
                         temperature: Double? = 1,
                         topProbabilityMass: Double? = 0,
                         choices: Int? = 1,
                         stop: [String]? = nil,
                         maxTokens: Int? = nil,
                         presencePenalty: Double? = 0,
                         frequencyPenalty: Double? = 0,
                         logitBias: [Int: Double]? = nil,
                         completionHandler: @escaping (Result<OpenAI<MessageResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.chat
        let body = ChatConversation(user: user,
                                    messages: messages,
                                    model: model.modelName,
                                    temperature: temperature,
                                    topProbabilityMass: topProbabilityMass,
                                    choices: choices,
                                    stop: stop,
                                    maxTokens: maxTokens,
                                    presencePenalty: presencePenalty,
                                    frequencyPenalty: frequencyPenalty,
                                    logitBias: logitBias)

        let request = prepareRequest(endpoint, body: body)
        
        makeRequest(request: request) { result in
            switch result {
            case .success(let success):
                if let chatErr = try? JSONDecoder().decode(ChatError.self, from: success) as ChatError {
                    completionHandler(.failure(.chatError(error: chatErr.error)))
                    return
                }
                
                do {
                    let res = try JSONDecoder().decode(OpenAI<MessageResult>.self, from: success)
                    completionHandler(.success(res))
                } catch {
                    completionHandler(.failure(.decodingError(error: error)))
                }
                
            case .failure(let failure):
                completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }
    
    /// Send Embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: Example: "The food was delicious and the waiter..."
    ///   - model: The only support model is `text-embedding-ada-002`
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendEmbeddings(with input: String,
                               model: OpenAIModelType = .embedding(.ada),
                               completionHandler: @escaping (Result<OpenAI<EmbeddingResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.embeddings
        let body = EmbeddingsInput(input: input,
                                   model: model.modelName)

        let request = prepareRequest(endpoint, body: body)
        makeRequest(request: request) { result in
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<EmbeddingResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
            }
        }
    }


    /// Send Image generation request to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - numImages: # of images to generate, defaults to 1
    ///   - size: Image size, defaults to 1024x1024. Other options are 512x512 and 256x256
    ///   - user: An optional unique identifier representing your end-user (helps OpenAI to monitor and detect abuse).
    ///   - completionHandler: Returns an OpenAI Data Model
    public func sendImages(with prompt: String, numImages: Int = 1, size: ImageSize = .size1024, user: String? = nil, completionHandler: @escaping (Result<OpenAI<UrlResult>, OpenAIError>) -> Void) {
        let endpoint = Endpoint.images
        let body = ImageGeneration(prompt: prompt, n: numImages, size: size, user: user)
        let request = prepareRequest(endpoint, body: body)

        makeRequest(request: request) { result in
            switch result {
                case .success(let success):
                    do {
                        let res = try JSONDecoder().decode(OpenAI<UrlResult>.self, from: success)
                        completionHandler(.success(res))
                    } catch {
                        completionHandler(.failure(.decodingError(error: error)))
                    }
                case .failure(let failure):
                    completionHandler(.failure(.genericError(error: failure)))
                }
        }
    }
    
    private func makeRequest(request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = config.session
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
    }
    
    private func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = endpoint.method
        
        if let token = self.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
}

extension OpenAISwift {
    /// Send Completion to the OpenAI API
    /// - Parameters:
    ///   - prompt: The Text Prompt
    ///   - model: Set to `OpenAIModelType.gpt3(.davinci)` by default which is the most capable model
    ///   - maxTokens: The limit character for the returned response, defaults to 16 as per the API
    ///   - temperature: Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. Defaults to 1
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendCompletion(with prompt: String, model: OpenAIModelType = .gpt3(.davinci), maxTokens: Int = 16, temperature: Double = 1) async throws -> OpenAI<TextResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendCompletion(with: prompt, model: model, maxTokens: maxTokens, temperature: temperature) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send Edit request to the OpenAI API
    /// - Parameters:
    ///   - instruction: Example: "Fix the spelling mistake"
    ///   - model: The only support model is `text-davinci-edit-001`
    ///   - input: Example: "Me name is Ty"
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendEdits(with instruction: String, model: OpenAIModelType = .feature(.davinci), input: String = "") async throws -> OpenAI<TextResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendEdits(with: instruction, model: model, input: input) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send Chat request to the OpenAI API
    /// - Parameters:
    ///   - messages: Array of `ChatMessages`
    ///   - model: The Model to use, the only support model is `gpt-3.5-turbo`
    ///   - user: A unique identifier representing your end-user (helps OpenAI monitor and detect abuse).
    ///   - temperature: What sampling temperature to use, between 0 and 2. Higher values make the output more random, while lower values make it more focused & deterministic.
    ///   - topProbabilityMass: The OpenAI API equivalent of the "top_p" parameter.
    ///   - choices: How many chat completion choices to generate for each input message.
    ///   - stop: Up to 4 sequences where the API will stop generating further tokens.
    ///   - maxTokens: Max number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens).
    ///   - presencePenalty: Number between -2.0 and 2.0.
    ///   - frequencyPenalty: Number between -2.0 and 2.0. 
    ///   - logitBias: Modify the likelihood of specified tokens appearing in the completion.
    ///   - completionHandler: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendChat(with messages: [ChatMessage],
                         model: OpenAIModelType = .chat(.chatgpt),
                         user: String? = nil,
                         temperature: Double? = 1,
                         topProbabilityMass: Double? = 0,
                         choices: Int? = 1,
                         stop: [String]? = nil,
                         maxTokens: Int? = nil,
                         presencePenalty: Double? = 0,
                         frequencyPenalty: Double? = 0,
                         logitBias: [Int: Double]? = nil) async throws -> OpenAI<MessageResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendChat(with: messages,
                     model: model,
                     user: user,
                     temperature: temperature,
                     topProbabilityMass: topProbabilityMass,
                     choices: choices,
                     stop: stop,
                     maxTokens: maxTokens,
                     presencePenalty: presencePenalty,
                     frequencyPenalty: frequencyPenalty,
                     logitBias: logitBias) { result in
                switch result {
                    case .success: continuation.resume(with: result)
                    case .failure(let failure): continuation.resume(throwing: failure)
                }
            }
        }
    }

    /// Send Embeddings request to the OpenAI API
    /// - Parameters:
    ///   - input: The Input For Example "The service was great and the clerk..."
    ///   - model: The only support model is `text-embedding-ada-002`
    ///   - completionHandler: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendEmbeddings(with input: String,
                               model: OpenAIModelType = .embedding(.ada)) async throws -> OpenAI<EmbeddingResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendEmbeddings(with: input) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send Image generation request to the OpenAI API
    /// - Parameters:
    ///   - prompt: Text Prompt
    ///   - numImages: # of images to generate, defaults to 1
    ///   - size: Image size, defaults to 1024x1024. Other options are 512x512 and 256x256
    ///   - user: Optional unique identifier representing your end-user (helps OpenAI to monitor and detect abuse).
    /// - Returns: Returns an OpenAI Data Model
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func sendImages(with prompt: String, numImages: Int = 1, size: ImageSize = .size1024, user: String? = nil) async throws -> OpenAI<UrlResult> {
        return try await withCheckedThrowingContinuation { continuation in
            sendImages(with: prompt, numImages: numImages, size: size, user: user) { result in
                continuation.resume(with: result)
            }
        }
    }
}
