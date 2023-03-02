# OpenAI API Client Library (Swift)  🏫

This library will allow you to access the OpenAI HTTP API's. Read the [APdocs](https://beta.openai.com/docs) for additional information.


## Installing OpenAI  💻

Use Swift Package Manager to integrate the library by adding the following dependency in your Package.swift file:

`.Package(url: "https://github.com/TyWysocki/OpenAI.git", majorVersion: 1)`


## Usage 👨‍💻

Import the module into your application.

`import OpenAI`

Set your API token after creating one [here](https://beta.openai.com/account/api-keys).

`let openAPI = OpenAISwift(authToken:"TOKEN")`

Create a call to the completions API to pass in a text prompt.

```swift
openAPI.sendCompletion(with: "Example") { result in // Result<OpenAIModel, OpenAIError>
    // switch on result to get the response or error
}
```
The API will return an `OpenAPI` object that contains the corresponding text items.

Different models can be specified and used for completions. The `sendCompletion` method defaults to the `text-davinci-003` model.

```swift
openAPI.sendCompletion(with: "Example", model: .gpt3(.ada)) { result in // Result<OpenAIModel, OpenAIError>
    // switch on result to get the response or error
}
...
```
Use Swift’s async/await syntax to fetch completions.

```swift
do {
    let result = try await openAPI.sendCompletion(with: "Example")
} catch {
    print(error.localizedDescription)
}
```

## License  📃

The MIT License (MIT)

Copyright (c) 2022 Tyler Wysocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
