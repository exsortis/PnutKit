//
//  Client.swift
//  Yawp
//
//  Created by Paul Schifferer on 19/5/17.
//  Copyright © 2017 Pilgrimage Software. All rights reserved.
//

import Foundation


private let dateFormatter = ISO8601DateFormatter()

public struct Client {
    public var createdAt : Date
    public var createdBy : User
    public var id : String
    public var link : URL
    public var name : String
    public var posts : Int
    public var content : [Content]
}


extension Client {
    public init?(from dict : [String : Any]) {
        guard let createdAtStr = dict["created_at"] as? String,
            let createdAt = dateFormatter.date(from: createdAtStr),
            let createdBy = User(from: dict["created_by"] as? [String : Any] ?? [:]),
            let id = dict["id"] as? String,
            let linkStr = dict["link"] as? String,
            let link = URL(string: linkStr),
            let name = dict["name"] as? String,
            let posts = dict["posts"] as? Int
            else { return nil }

        self.createdAt = createdAt
        self.createdBy = createdBy
        self.id = id
        self.link = link
        self.name = name
        self.posts = posts
        self.content = []
    }

    public func toDictionary() -> NSDictionary {
        let dict : NSDictionary = [
            "created_at" : dateFormatter.string(from: createdAt),
            "created_by" : createdBy.toDictionary(),
            "id" : id,
            "link" : link.absoluteString,
            "name" : name,
            "posts" : posts,
            "content" : content.map { $0.toDictionary() },
            ]
        return dict
    }
}
