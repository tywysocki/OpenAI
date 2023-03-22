# OpenAI API Client Library (Swift)  

This library will allow you to access the OpenAI HTTP APIs. You can read the [full API docs](https://beta.openai.com/docs) for additional information.

## Installing OpenAI  💻

Add the following dependency in your Package.swift file (use Swift Package Manager):

`.Package(url:"https://github.com/tywysocki/OpenAI.git", majorVersion: 1)`

## Usage 👨‍💻

Import the module into your application.

`import OpenAI`

Set your API token after creating one [here](https://beta.openai.com/account/api-keys).

`let openAPI = OpenAI(authToken:"TOKEN")`

Create a call to the completions API, passing in a text prompt.

```swift
openAI.sendCompletion(with: "Hello, how are you today?", maxTokens: 100) { result in // Result<OpenAI, OpenAIError>
    switch result {
    case .success(let success):
        print(success.choices.first?.text ?? "")
    case .failure(let failure):
        print(failure.localizedDescription)
    }
}
```
The API will return an `OpenAPI` object that contains the corresponding text items.

You can specify different models to use for the completions (The `sendCompletion` method defaults to the `text-davinci-003` model).

```swift
openAI.sendCompletion(with: "A random emoji", model: .gpt3(.ada)) { result in // Result<OpenAI, OpenAIError>
    // switch on result to get the response or error
}
```
See [OpenAIModelType.swift](https://github.com/tywysocki/OpenAI/blob/master/Sources/OpenAI/Models/OpenAIModelType.swift) for a list of supported models and the [OpenAI API Documentation](https://beta.openai.com/docs/models) for more information on the models.

OpenAI supports Swift concurrency, you can use Swift’s async/await syntax to fetch completions.

```swift
do {
    let result = try await openAI.sendCompletion(with: "A random emoji")
} catch {
    print(error.localizedDescription)
}
```

The latest `gpt-3.5-turbo` model is also available: 

```swift
func chat() async {
    do {
        let chat: [ChatMessage] = [
            ChatMessage(role: .system, content: "You are a helpful assistant."),
            ChatMessage(role: .user, content: "What teams played in the 30th Superbowl?"),
            ChatMessage(role: .assistant, content: "The Dallas Cowboys played the Pittsburgh Steelers in the 30th Superbowl."),
            ChatMessage(role: .user, content: "Who won?")
        ]
                    
        let result = try await openAI.sendChat(with: chat)
        
        print(result.choices.first?.message?.content ?? "Nothing")
    } catch {
        print("Something went wrong")
    }
}
```

## License  📃

The MIT License (MIT)

Copyright (c) 2022 Tyler Wysocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
