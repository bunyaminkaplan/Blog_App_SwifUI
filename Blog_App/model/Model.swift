//
//  model.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 21.05.2024.
//

import Foundation

struct tracker_object: Codable {
    let id: Int
    let requestOwner, requestReceiver: String
    let still: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case requestOwner = "request_owner"
        case requestReceiver = "request_receiver"
        case still
    }
}

struct suggest_object: Codable {
    let id: Int
    let username: String
    }

struct current_user_object: Codable {
    let username: String
    }

struct aio_object: Codable {
    let id: Int
    let specs: Specs
    let addedAt: String
    let generatedCode: Int
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, specs
        case addedAt = "added_at"
        case generatedCode = "generated_code"
        case image
    }
}

struct Specs: Codable {
    let id: Int
    let whoPushed, title, index: String
    let likeCount: Int
    let addedAt: String
    let imageAdded: Bool
    let generatedCode: Int

    enum CodingKeys: String, CodingKey {
        case id
        case whoPushed = "who_pushed"
        case title, index
        case likeCount = "like_count"
        case addedAt = "added_at"
        case imageAdded = "image_added"
        case generatedCode = "generated_code"
    }
}

struct imagePostResponseJson: Codable {
    let id: Int
    let addedAt: String
    let localURL: JSONNull?
    let currentUserUsername: String
    let generatedCode: Int
    let uploadedURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case addedAt = "added_at"
        case localURL = "local_url"
        case currentUserUsername = "current_user_username"
        case generatedCode = "generated_code"
        case uploadedURL = "uploaded_url"
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

struct userPostResponseJson: Codable {
    let id: Int
    let whoPushed, title, index: String
    let likeCount: Int
    let addedAt: String
    let imageAdded: Bool
    let generatedCode: Int

    enum CodingKeys: String, CodingKey {
        case id
        case whoPushed = "who_pushed"
        case title, index
        case likeCount = "like_count"
        case addedAt = "added_at"
        case imageAdded = "image_added"
        case generatedCode = "generated_code"
    }
}

struct aioResponseJson: Codable {
   
        let id: Int
        let addedAt: String
        let generatedCode, specs, image: Int

        enum CodingKeys: String, CodingKey {
            case id
            case addedAt = "added_at"
            case generatedCode = "generated_code"
            case specs, image
        }
    }

struct Welcome: Codable {
    let id: Int
    let addedAt: String
    let generatedCode, specs, image: Int

    enum CodingKeys: String, CodingKey {
        case id
        case addedAt = "added_at"
        case generatedCode = "generated_code"
        case specs, image
    }
}


