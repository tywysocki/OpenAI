# OpenAI API Client Library (Swift) 

A Swift library designed to help you interact with the OpenAI HTTP APIs. More information on the API can be found here: https://beta.openai.com/docs

## Installation 💻

To integrate the library, Swift Package Manager is your tool of choice. Add the following dependency to your Package.swift file or add it directly within Xcode.

`
.Package(url: "https://github.com/tywysocki/OpenAI.git", from: "1.0.0")
`

## Usage 👩‍💻

Import the library:

```swift
import OpenAI
```

Create an API key [here](https://platform.openai.com/account/api-keys), and include it in your configuration.

```swift
let openAI = OpenAI(authToken:"API_KEY")
```

With this library, you can take advantage of Swift concurrency. The code snippets provided below demonstrate both async/await and completion handler implementations.

### [Text Completion](https://platform.openai.com/docs/api-reference/completions)

The completions endpoint offers a broad range of applications. It presents a straightforward yet robust interface to all the models. Given a text prompt, the model will produce a text completion that aims to correspond with the given context or pattern.

#### Completion handler implementation:

```swift
openAI.sendCompletion(with: "How are you doing today") { result in // Result<OpenAIModel, OpenAIError>
    switch result {
    case .success(let success):
        print(success.choices.first?.text ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```
To implement a completion handler, you need to provide a string parameter (the prompt) and a closure that will be called with a `Result` object. If the API call is successful, the `Result` object will contain an `OpenAIModel` object, which includes an array of completion objects. Each completion object represents a possible text completion, and the generated text can be accessed via the `text` property of the first "completion" object in the array.

If the API call fails, the `Result` object will contain an `OpenAIError` object, which includes an error message retrieved from the `localizedDescription` property. This message should be printed to the console to help diagnose the issue.

#### async/await implementation:

```swift
do {
    let result = try await openAI.sendCompletion(
        with: "Got any creative names for my new dog?",
        model: .gpt3(.davinci), // optional `OpenAIModelType`
        maxTokens: 16,          // optional `Int?`
        temperature: 1          // optional `Double?`
    )
    // use result
} catch {
    // ...
}
```

The `async/await` implementation waits for the completion to be generated before continuing with the code execution. If the completion generation fails, the code will catch the error and handle it appropriately in the catch block. After the completion is generated, it will be stored in `result`, which can then be used in the code for further processing, such as displaying the generated name to the user.

For a list of supported models, check out [OpenAIModelType.swift](https://github.com/tywysocki/OpenAI/blob/master/Sources/OpenAI/Models/OpenAIModelType.swift). You can also visit the [OpenAI API Docs](https://beta.openai.com/docs/models) for additional information on the models.

### [Chat Completions](https://platform.openai.com/docs/api-reference/chat)

By utilizing OpenAI's Chat API, you can access ChatGPT (aka GPT-3.5) and GPT-4 (currently in beta) to obtain responses for chat conversations. Chat models take a series of messages as input, and return a model-generated message as output.

An example API call looks as follows:

```swift
do {
    let chat: [ChatMessage] = [
        ChatMessage(role: .system, content: "You are a helpful assistant."),
        ChatMessage(role: .user, content: "Who played in the 30th Super Bowl?"),
        ChatMessage(role: .assistant, content: "The 30th Super Bowl was played between the Dallas Cowboys and the Pittsburgh Steelers."),
        ChatMessage(role: .user, content: "Who won the game?")
    ]
                
    let result = try await openAI.sendChat(with: chat)
    // use result
} catch {
    // ...
}
```

The main input is the `chat` parameter. `chat` must be an array of `ChatMessage` objects, where each object has a `role` (either "system", "user", or "assistant") and content (the content of the message). Conversations are typically formatted with a system message first, which helps set the behavior of the assistant, and followed by alternating user and assistant messages.

The `sendChat` method supports all API parameters, except streaming message content before it is completed:

```swift
do {
    let chat: [ChatMessage] = [...]

    let result = try await openAI.sendChat(
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

### [Image Generation - DALL·E](https://platform.openai.com/docs/api-reference/images/create) 🌄

The image generations endpoint allows you to create an original image given a text prompt. Provide more deatil in the prompt for better results.

```swift
openAI.sendImages(with: "Hand drawn sketch of a Porsche 911.", numImages: 1, size: .size1024) { result in // Result<OpenAIModel, OpenAIError>
    switch result {
    case .success(let success):
        print(success.data.first?.url ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

### [Edits](https://platform.openai.com/docs/api-reference/edits) 👨🏻‍🔧

The edits endpoint can be used to edit text based on a prompt and an instruction for how to modify it.

```swift
do {
    let result = try await openAI.sendEdits(
        with: "Fix the spelling mistake.",
        model: .feature(.davinci),               // optional `OpenAIModelType`
        input: "Me name is Ty"
    )
    // use result
} catch {
    // ...
}
```

### [Moderation](https://platform.openai.com/docs/api-reference/moderations) 👮‍♂️

The moderation endpoint is a tool you can use to check whether content complies with OpenAI's usage policies.

```swift
do {
    let result = try await openAI.sendModeration(
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

Copyright (c) 2022 Tyler Wysocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
