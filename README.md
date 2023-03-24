# OpenAI API Client Library (Swift)

This library will enable you to access the OpenAI HTTP APIs. The full API documentation can be found [here.](https://beta.openai.com/docs)

## Library Installation 💻

Use Swift Package Manager to integrate the library by adding the following dependency in the `Package.swift` file:

`.Package(url: "https://github.com/tywysocki/OpenAI.git", majorVersion: 1)`

## Usage 👨‍💻

First, import the framework to your application:

`import OpenAI`

Next, [generate an API key](https://platform.openai.com/account/api-keys) and add it to your configuration:

`let openAI = OpenAI(authToken: "TOKEN")`

This framework supports Swift concurrency; you can use Swift’s async/await syntax to fetch completions.

### [Completions](https://platform.openai.com/docs/api-reference/completions)

Predict completions for input text. This returns an `OpenAI` object containing the completions:

```swift
openAI.sendCompletion(with: "Hello") { result in // Result<OpenAIModel, OpenAIError>
    switch result {
    case .success(let success):
        print(success.choices.first?.text ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```

There are other API parameters that are also supported:

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

You can look at [OpenAIModelType.swift](https://github.com/tywysocki/OpenAI/blob/master/Sources/OpenAI/Models/OpenAIModelType.swift) for a list of supported models or [OpenAI API Documentation](https://beta.openai.com/docs/models) for additional information on the models.

### [Chat](https://platform.openai.com/docs/api-reference/chat)

Get responses to chat conversations through ChatGPT (aka GPT-3.5) & GPT-4 (beta).

Chat models take a series of messages as input, and return a model-generated message as output. An example API call looks as follows:

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

All API parameters are supported:

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
        logitBias: nil                 // optional `[Int: Double]?`
    )
    // use result
} catch {
    // ...
}
```

### [Image Generation with DALL·E](https://platform.openai.com/docs/api-reference/images/create)

The image generations endpoint allows you to create an original image given a text prompt.

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

### [Edits](https://platform.openai.com/docs/api-reference/edits) 

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

## License  📃

The MIT License (MIT)

Copyright (c) 2022 Tyler Wysocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
