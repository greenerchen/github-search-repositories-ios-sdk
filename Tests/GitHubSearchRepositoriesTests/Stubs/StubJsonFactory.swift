//
//  StubJsonFactory.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/26.
//

import Foundation

enum StubJsonFactory {
    static func makeAllPropertiesJsonString() -> String {
        #"""
{
    "total_count": 2,
    "incomplete_results": false,
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
    "total_count": 2,
    "incomplete_results": false,
    "items": [
        {
            "name": "stub-1",
            "private": false,
            "description": null,
            "language": null
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
    "total_count": 2,
    "incomplete_results": false,
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
