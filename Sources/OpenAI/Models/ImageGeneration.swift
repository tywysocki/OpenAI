//
//  ImageGeneration.swift
//  
//
//  Created by Tyler Wysocki on 03-20-2023.
//

import Foundation

struct ImageGeneration: Encodable {
    let prompt: String
    let n: Int
    let size: ImageSize
    let user: String?
}

public enum ImageSize: String, Codable {
    case size1024 = "1024x1024"
    case size512 = "512x512"
    case size256 = "256x256"
}
