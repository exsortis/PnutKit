//
//  Message.swift
//  Yawp
//
//  Created by Paul Schifferer on 19/5/17.
//  Copyright © 2017 Pilgrimage Software. All rights reserved.
//

import Foundation


private let dateFormatter = ISO8601DateFormatter()

public struct Message {
    public var createdAt : Date
    public var id : String
    public var isDeleted : Bool
    public var isSticky : Bool
    public var source : Source
    public var replyTo : String?
    public var threadId : String
    public var user : User
    public var content : Content?
    public var raw : [Raw]
}


extension Message {
    public init?(from dict : [String : Any]) {
        guard let c = dict["created_at"] as? String,
            let createdAt = dateFormatter.date(from: c),
            let id = dict["id"] as? String,
            let isSticky = dict["is_sticky"] as? Bool,
            let s = dict["source"] as? [String : Any],
            let source = Source(from: s),
            let threadId = dict["thread_id"] as? String,
            let u = dict["user"] as? [String : Any],
            let user = User(from: u)
            else { return nil }

        self.createdAt = createdAt
        self.id = id
        self.isDeleted = dict["is_deleted"] as? Bool ?? false
        self.isSticky = isSticky
        self.source = source
        self.replyTo = dict["reply_to"] as? String
        self.threadId = threadId
        self.user = user
        self.content = Content(from: dict["content"] as? [String : Any] ?? [:])

        if let raw = dict["raw"] as? [[String : Any]] {
            self.raw = raw.flatMap { Raw(from: $0) }
        }
        else {
            self.raw = []
        }
    }

    public func toDictionary() -> NSDictionary {
        let dict : NSDictionary = [
            "created_at" : dateFormatter.string(from: createdAt),
            "id" : id,
            "is_deleted" : isDeleted,
            "is_sticky" : isSticky,
            "source" : source.toDictionary(),
            "thread_id" : threadId,
            "user" : user.toDictionary(),
            ]

        if let content = content {
            dict.setValue(content.toDictionary(), forKey: "content")
        }

        if let replyTo = replyTo {
            dict.setValue(replyTo, forKey: "reply_to")
        }

        return dict
    }
}
