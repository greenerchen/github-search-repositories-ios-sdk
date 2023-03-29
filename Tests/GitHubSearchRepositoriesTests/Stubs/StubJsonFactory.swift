//
//  StubJsonFactory.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/26.
//

import Foundation

enum StubJsonFactory {
    static func makeFullRequirePropertiesJsonString() -> String {
        #"""
{
    "items": [
        {
            "name": "stub-1",
            "private": false,
            "description": "stub description 1",
            "language": "Kotlin"
        },
        {
            "name": "stub-2",
            "private": true,
            "description": "stub description 2",
            "language": "Java"
        }
    ]
}
"""#
    }
    
    static func makePartialRequirePropertiesJsonString() -> String {
        #"""
{
    "items": [
        {
            "name": "stub-1",
            "private": null,
            "description": "stub description 1",
            "language": "Kotlin"
        },
        {
            "name": "stub-2",
            "private": true,
            "language": "Java"
        }
    ]
}
"""#
    }
    
    static func makeInvalidJsonString() -> String {
        #"""
{
    "items": [
        {
            "name": "stub-1",
            "private": null,
            "description": "stub description 1",
            "language": "Kotlin"
        },
        {
            "name": "stub-2",
            "private": true,
            "language": "Java"
        }
}
"""#
    }
}
