# OpenAI API Client Library (Swift)

A Swift-based tool used to interact with the OpenAI HTTP APIs. You can access the complete API docs here:

https://beta.openai.com/docs

## Installation

To integrate the library, Swift Package Manager is your tool of choice. Add the following dependency to the Package.swift file.

```swift
.Package(url: "https://github.com/tywysocki/OpenAI.git", from: "1.0.0")
```

## Usage

Import the library:

```swift
import OpenAI
```
Create an API key [here](https://platform.openai.com/account/api-keys), and include it in your configuration.

```swift
let client = OpenAI(authToken:"API_KEY")
```

With this library, you can take advantage of Swift concurrency. The code snippets provided below demonstrate both async/await and completion handler implementations.

### [Completions Endpoint](https://platform.openai.com/docs/api-reference/completions)

Use the `client.sendCompletion` method to send a request to the completions endpoint of the API. All you need to do is provide the desired text prompt as input, and the model will generate a text completion that is intended to match the context or pattern you provided. Keep in mind that the model's success generally depends on the complexity of the task and [quality of your prompt](https://platform.openai.com/docs/guides/completion/prompt-design).

#### Completion handler:

```swift
client.sendCompletion(with: "How are you doing today") { result in // Result<OpenAIModel, OpenAIError>
    switch result {
    case .success(let success):
        print(success.choices.first?.text ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

#### async/await:

```swift
do {
    let result = try await client.sendCompletion(
        with: "",
        model: .gpt3(.davinci), // optional `OpenAIModelType`
        maxTokens: 16,          // optional `Int?`
        temperature: 1          // optional `Double?`
    )
    // use result
} catch {
    // ...
}
```

For a list of supported models, refer to [OpenAIModelType.swift](https://github.com/tywysocki/OpenAI/blob/master/Sources/OpenAI/Models/OpenAIModelType.swift). For detailed information about these models, refer to the [OpenAI API Docs]().

### [ChatGPT](https://platform.openai.com/docs/api-reference/chat)

Access ChatGPT (aka GPT-3.5) and GPT-4 (beta) using the `client.sendChat` method. The chat models require a series of messages as input, and produce a model-generated message as output. Each element in the `chat` array is a `ChatMessage` object, containing a `role` (either "system", "user", or "assistant") and `content` (the message content). Typically, conversations begin with a system message (which establishes the behavior of the assistant) followed by alternating user and assistant messages.

#### Example API call:

```swift
do {
    let chat: [ChatMessage] = [
        ChatMessage(role: .system, content: "You are a helpful assistant."),
        ChatMessage(role: .user, content: "Who played in the 30th Super Bowl?"),
        ChatMessage(role: .assistant, content: "The 30th Super Bowl was played between the Dallas Cowboys and the Pittsburgh Steelers."),
        ChatMessage(role: .user, content: "Who won the game?")
    ]
                
    let result = try await client.sendChat(with: chat)
    // use result
} catch {
    // ...
}
```

This library supports all API parameters, except for streaming message content that has not been completed yet.

```swift
do {
    let chat: [ChatMessage] = [...]

    let result = try await client.sendChat(
        with: chat,
        model: .chat(.chatgpt),         // optional `OpenAIModelType`
        user: nil,                      // optional `String?`
        temperature: 1,                 // optional `Double?`
        topProbabilityMass: 1,          // optional `Double?`
        choices: 1,                     // optional `Int?`
        stop: nil,                      // optional `[String]?`
        maxTokens: nil,                 // optional `Int?`
        presencePenalty: nil,           // optional `Double?`
        frequencyPenalty: nil,          // optional `Double?`
        logitBias: nil                  // optional `[Int: Double]?`
    )
    // use result
} catch {
    // ...
}
```

### [Images (DALL·E)](https://platform.openai.com/docs/api-reference/images/create)

To generate an original image based on a text prompt, use the `client.sendImages` method. For better results, provide a detailed text prompt.

```swift
client.sendImages(with: "Hand drawn sketch of a Porsche 911.", numImages: 1, size: .size1024) { result in // Result<OpenAIModel, OpenAIError>
    switch result {
    case .success(let success):
        print(success.data.first?.url ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

### [Edits Endpoint](https://platform.openai.com/docs/api-reference/edits)

To edit text based on a prompt and a modification instruction, use `client.sendEdits`. The method takes a prompt and a modification instruction as input and returns an edited version of the prompt as output.

```swift
do {
    let result = try await client.sendEdits(
        with: "Fix the spelling mistake.",
        model: .feature(.davinci),               // optional `OpenAIModelType`
        input: "Me name is Ty"
    )
    // use result
} catch {
    // ...
}
```

### [Embeddings Endpoint](https://platform.openai.com/docs/guides/embeddings)

To obtain a vector representation of a text string, make a request to the embeddings endpoint with `client.sendEmbeddings`. The method returns a vector representation of the text string that can be easily consumed by machine learning models and algorithms. For more information and use cases, refer to the [API documentation](https://platform.openai.com/docs/guides/embeddings/use-cases).

```swift
do {
    let result = try await client.sendEmbeddings(
        with: "The service was great and the clerk..."
    )
    // use result
} catch {
    // ...
}
```

### [Moderation Endpoint](https://platform.openai.com/docs/api-reference/moderations)

The moderation endpoint is a tool you can use to check whether content complies with OpenAI's usage policies. To obtain a classification for a piece of text, send a request to the moderation endpoint with the `client.sendModeration` method.

```swift
do {
    let result = try await client.sendModeration(
        with: "Unmoderated text",
        model: .moderation(.latest)     // optional `OpenAIModelType`
    )
    // use result
} catch {
    // ...
}
```

## License

The MIT License (MIT)

Copyright (c) 2022 - 2023 Tyler Wysocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
