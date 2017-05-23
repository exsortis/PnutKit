//
//  User.swift
//  Yawp
//
//  Created by Paul Schifferer on 19/5/17.
//  Copyright © 2017 Pilgrimage Software. All rights reserved.
//

import Foundation


private let dateFormatter = ISO8601DateFormatter()

public struct User {
    public var createdAt : Date
    public var guid : String
    public var id : String
    public var locale : String
    public var timezone : String
    public var type : UserType
    public var username : String
    public var name : String?
    public var content : Content
    public var counts : Counts
    public var followsYou : Bool
    public var youBlocked : Bool
    public var youFollow : Bool
    public var youMuted : Bool
    public var youCanFollow : Bool
    public var verified : Verified?
    public var raw : [Raw]

    public struct Counts {
        public var bookmarks : Int
        public var clients : Int
        public var followers : Int
        public var following : Int
        public var posts : Int
        public var users : Int
    }
    public struct Verified {
        public var domain : String?
        public var link : URL?
    }
}


public enum UserType : String {
    case human = "human"
    case feed = "feed"
    case bot = "bot"
}


extension User {
    static let deleted = User(createdAt: Date(),
                                  guid: "",
                                  id: "",
                                  locale: "",
                                  timezone: "",
                                  type: .human,
                                  username: "",
                                  name: nil,
                                  content: Content(text: "", html: "<p/>"),
                                  counts: Counts(bookmarks: 0, clients: 0, followers: 0, following: 0, posts: 0, users: 0),
                                  followsYou: false,
                                  youBlocked: false,
                                  youFollow: false,
                                  youMuted: false,
                                  youCanFollow: false,
                                  verified: nil,
                                  raw: [])
}


extension User {
    public init?(from dict : [String : Any]) {
        guard let c = dict["created_at"] as? String,
            let createdAt = dateFormatter.date(from: c),
            let guid = dict["guid"] as? String,
            let id = dict["id"] as? String,
            let locale = dict["locale"] as? String,
            let timezone = dict["timezone"] as? String,
            let t = dict["type"] as? String,
            let type = UserType(rawValue: t),
            let username = dict["username"] as? String,
            let co = dict["content"] as? [String : Any],
            let content = Content(from: co),
            let counts = dict["counts"] as? [String : Any],
            let bookmarksCount = counts["bookmarks"] as? Int,
            let clientsCount = counts["clients"] as? Int,
            let followersCount = counts["followers"] as? Int,
            let followingCount = counts["following"] as? Int,
            let postsCount = counts["posts"] as? Int,
            let usersCount = counts["users"] as? Int,
            let followsYou = dict["follows_you"] as? Bool,
            let youBlocked = dict["you_blocked"] as? Bool,
            let youFollow = dict["you_follow"] as? Bool,
            let youMuted = dict["you_muted"] as? Bool,
            let youCanFollow = dict["you_can_follow"] as? Bool
            else { return nil }

        self.createdAt = createdAt
        self.guid = guid
        self.id = id
        self.locale = locale
        self.timezone = timezone
        self.type = type
        self.username = username
        self.name = dict["name"] as? String
        self.content = content
        self.counts = Counts(bookmarks: bookmarksCount,
                             clients: clientsCount,
                             followers: followersCount,
                             following: followingCount,
                             posts: postsCount,
                             users: usersCount)
        self.followsYou = followsYou
        self.youBlocked = youBlocked
        self.youFollow = youFollow
        self.youMuted = youMuted
        self.youCanFollow = youCanFollow

        if let verified = dict["verified"] as? [String : Any] {
            self.verified = Verified(domain: verified["domain"] as? String,
                                     link: URL(string: verified["link"] as? String ?? ""))
        }

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
            "guid" : guid,
            "id" : id,
            "locale" : locale,
            "timezone" : timezone,
            "type" : type.rawValue,
            "username" : username,
            "content" : content.toDictionary(),
            "counts" : [
                "bookmarks" : counts.bookmarks,
                "clients" : counts.clients,
                "followers" : counts.followers,
                "following" : counts.following,
                "posts" : counts.posts,
                "users" : counts.users,
            ],
            "follows_you" : followsYou,
            "you_blocked" : youBlocked,
            "you_follow" : youFollow,
            "you_muted" : youMuted,
            "you_can_follow" : youCanFollow,
            ]

        if let name = name {
            dict.setValue(name, forKey: "name")
        }

        if let verified = verified {
            let v = NSDictionary()

            if let domain = verified.domain {
                v.setValue(domain, forKey: "domain")
            }

            if let link = verified.link {
                v.setValue(link.absoluteString, forKey: "link")
            }
            
            dict.setValue(v, forKey: "verified")
        }
        
        return dict
    }
}
