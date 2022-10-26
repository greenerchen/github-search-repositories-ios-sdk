//
//  StubJsonFactory.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/26.
//

import Foundation

enum StubJsonFactory {
    static func makeFullRequirePropertiesJsonString() -> String {
        return """
{
    \"items\": [
        {
            \"name\": \"stub-1\",
            \"private\": false,
            \"description\": \"stub description 1\",
            \"language\": \"Kotlin\"
        },
        {
            \"name\": \"stub-2\",
            \"private\": true,
            \"description\": \"stub description 2\",
            \"language\": \"Java\"
        }
    ]
}
""".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    static func makePartialRequirePropertiesJsonString() -> String {
        return """
{
    \"items\": [
        {
            \"name\": \"stub-1\",
            \"private\": null,
            \"description\": \"stub description 1\",
            \"language\": \"Kotlin\"
        },
        {
            \"name\": \"stub-2\",
            \"private\": true,
            \"language\": \"Java\"
        }
    ]
}
""".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    static func makeInvalidJsonString() -> String {
        return """
{
    \"items\": [
        {
            \"name\": \"stub-1\",
            \"private\": null,
            \"description\": \"stub description 1\",
            \"language\": \"Kotlin\"
        },
        {
            \"name\": \"stub-2\",
            \"private\": true,
            \"language\": \"Java\"
        }
}
""".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
