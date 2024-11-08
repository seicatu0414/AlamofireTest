//
//  APIStructs.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/01.
//

import Foundation

// https://qiita.com/api/v2/users/user_id
// ユーザー検索
struct SearchUser: Decodable {
    let description: String?
    let facebookID: String?
    let followeesCount: Int?
    let followersCount: Int?
    let githubLoginName: String?
    let id: String?
    let itemsCount: Int?
    let linkedinID: String?
    let location: String?
    let name: String?
    let organization: String?
    let permanentID: Int?
    let profileImageURL: String?
    let teamOnly: Bool?
    let twitterScreenName: String?
    let websiteURL: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case facebookID = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinID = "linkedin_id"
        case location, name, organization
        case permanentID = "permanent_id"
        case profileImageURL = "profile_image_url"
        case teamOnly = "team_only"
        case twitterScreenName = "twitter_screen_name"
        case websiteURL = "website_url"
    }
    // APIデコード用init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID) ?? ""
        self.followeesCount = try container.decodeIfPresent(Int.self, forKey: .followeesCount)
        self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        // テストしたらここにnullが入ってきたのでStringはnull考慮
        self.githubLoginName = try container.decodeIfPresent(String.self, forKey: .githubLoginName) ?? ""
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
        self.linkedinID = try container.decodeIfPresent(String.self, forKey: .linkedinID) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.organization = try container.decodeIfPresent(String.self, forKey: .organization) ?? ""
        self.permanentID = try container.decodeIfPresent(Int.self, forKey: .permanentID)
        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL) ?? ""
        self.teamOnly = try container.decodeIfPresent(Bool.self, forKey: .teamOnly)
        self.twitterScreenName = try container.decodeIfPresent(String.self, forKey: .twitterScreenName) ?? ""
        self.websiteURL = try container.decodeIfPresent(String.self, forKey: .websiteURL) ?? ""
    }
}

// https://qiita.com/api/v2/users/user_id/items
// 選択したユーザーのアイテム群
struct SearchUserItems: Decodable {
    let renderedBody, body: String?
    let coediting: Bool?
    let commentsCount: Int?
    let createdAt: String?
    let group: Group?
    let id: String?
    let likesCount: Int?
    let searchUserItemsStructPrivate: Bool?
    let reactionsCount: Int?
    let stocksCount: Int?
    let tags: [Tag]?
    let title: String?
    let updatedAt: String?
    let url: String?
    let user: UserInfo?
    let pageViewsCount: Int?
    let teamMembership: TeamMembership?
    let organizationURLName: String?
    let slide: Bool?
    
    enum CodingKeys: String, CodingKey {
        case renderedBody = "rendered_body"
        case body, coediting
        case commentsCount = "comments_count"
        case createdAt = "created_at"
        case group, id
        case likesCount = "likes_count"
        case searchUserItemsStructPrivate = "private"
        case reactionsCount = "reactions_count"
        case stocksCount = "stocks_count"
        case tags, title
        case updatedAt = "updated_at"
        case url, user
        case pageViewsCount = "page_views_count"
        case teamMembership = "team_membership"
        case organizationURLName = "organization_url_name"
        case slide
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.renderedBody = try container.decodeIfPresent(String.self, forKey: .renderedBody) ?? ""
        self.body = try container.decodeIfPresent(String.self, forKey: .body) ?? ""
        self.coediting = try container.decodeIfPresent(Bool.self, forKey: .coediting)
        self.commentsCount = try container.decodeIfPresent(Int.self, forKey: .commentsCount)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.group = try container.decodeIfPresent(Group.self, forKey: .group)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.likesCount = try container.decodeIfPresent(Int.self, forKey: .likesCount)
        self.searchUserItemsStructPrivate = try container.decodeIfPresent(Bool.self, forKey: .searchUserItemsStructPrivate)
        self.reactionsCount = try container.decodeIfPresent(Int.self, forKey: .reactionsCount)
        self.stocksCount = try container.decodeIfPresent(Int.self, forKey: .stocksCount)
        self.tags = try container.decodeIfPresent([Tag].self, forKey: .tags)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.user = try container.decodeIfPresent(UserInfo.self, forKey: .user)
        self.pageViewsCount = try container.decodeIfPresent(Int.self, forKey: .pageViewsCount)
        self.teamMembership = try container.decodeIfPresent(TeamMembership.self, forKey: .teamMembership)
        self.organizationURLName = try container.decodeIfPresent(String.self, forKey: .organizationURLName) ?? ""
        self.slide = try container.decodeIfPresent(Bool.self, forKey: .slide)
    }
}

// https://qiita.com/api/v2/users/user_id/items
// MARK: - Group
struct Group: Decodable {
    let createdAt: Date?
    let description: String?
    let name: String?
    let groupPrivate: Bool?
    let updatedAt: Date?
    let urlName: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case description
        case name
        case groupPrivate = "private"
        case updatedAt = "updated_at"
        case urlName = "url_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.groupPrivate = try container.decodeIfPresent(Bool.self, forKey: .groupPrivate)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.urlName = try container.decodeIfPresent(String.self, forKey: .urlName)
    }
}

// https://qiita.com/api/v2/users/user_id/items
// MARK: - Tag
struct Tag: Decodable {
    let name: String?
    let versions: [String]?
    
    enum CodingKeys: CodingKey {
        case name
        case versions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.versions = try container.decodeIfPresent([String].self, forKey: .versions)
    }
}

// https://qiita.com/api/v2/users/user_id/items
// MARK: - TeamMembership
struct TeamMembership: Decodable {
    let name: String
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

// https://qiita.com/api/v2/users/user_id/items
// MARK: - User
struct UserInfo: Decodable {
    let description:String?
    let facebookID: String?
    let followeesCount:Int?
    let followersCount: Int?
    let githubLoginName: String?
    let id: String?
    let itemsCount: Int?
    let linkedinID: String?
    let location: String?
    let name: String?
    let organization: String?
    let permanentID: Int?
    let profileImageURL: String?
    let teamOnly: Bool?
    let twitterScreenName: String?
    let websiteURL: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case facebookID = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinID = "linkedin_id"
        case location, name, organization
        case permanentID = "permanent_id"
        case profileImageURL = "profile_image_url"
        case teamOnly = "team_only"
        case twitterScreenName = "twitter_screen_name"
        case websiteURL = "website_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID)
        self.followeesCount = try container.decodeIfPresent(Int.self, forKey: .followeesCount)
        self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.githubLoginName = try container.decodeIfPresent(String.self, forKey: .githubLoginName)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
        self.linkedinID = try container.decodeIfPresent(String.self, forKey: .linkedinID)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.organization = try container.decodeIfPresent(String.self, forKey: .organization)
        self.permanentID = try container.decodeIfPresent(Int.self, forKey: .permanentID)
        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        self.teamOnly = try container.decodeIfPresent(Bool.self, forKey: .teamOnly)
        self.twitterScreenName = try container.decodeIfPresent(String.self, forKey: .twitterScreenName)
        self.websiteURL = try container.decodeIfPresent(String.self, forKey: .websiteURL)
    }
}

// https://qiita.com/api/v2/users/:user_id/followees
// followしている
struct SearchUserFollowee: Decodable {
    let description:String?
    let facebookID: String?
    let followeesCount:Int?
    let followersCount: Int?
    let githubLoginName: String?
    let id: String?
    let itemsCount: Int?
    let linkedinID: String?
    let location: String?
    let name: String?
    let organization: String?
    let permanentID: Int?
    let profileImageURL: String?
    let teamOnly: Bool?
    let twitterScreenName: String?
    let websiteURL: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case facebookID = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinID = "linkedin_id"
        case location, name, organization
        case permanentID = "permanent_id"
        case profileImageURL = "profile_image_url"
        case teamOnly = "team_only"
        case twitterScreenName = "twitter_screen_name"
        case websiteURL = "website_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID)
        self.followeesCount = try container.decodeIfPresent(Int.self, forKey: .followeesCount)
        self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.githubLoginName = try container.decodeIfPresent(String.self, forKey: .githubLoginName)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
        self.linkedinID = try container.decodeIfPresent(String.self, forKey: .linkedinID)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.organization = try container.decodeIfPresent(String.self, forKey: .organization)
        self.permanentID = try container.decodeIfPresent(Int.self, forKey: .permanentID)
        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        self.teamOnly = try container.decodeIfPresent(Bool.self, forKey: .teamOnly)
        self.twitterScreenName = try container.decodeIfPresent(String.self, forKey: .twitterScreenName)
        self.websiteURL = try container.decodeIfPresent(String.self, forKey: .websiteURL)
    }
}

// https://qiita.com/api/v2/users/:user_id/followers
// Followerしてる
struct SearchUserFollowers: Decodable {
    let description:String?
    let facebookID: String?
    let followeesCount: Int?
    let followersCount: Int?
    let githubLoginName:String?
    let id: String?
    let itemsCount: Int?
    let linkedinID: String?
    let location: String?
    let name: String?
    let organization: String?
    let permanentID: Int?
    let profileImageURL: String?
    let teamOnly: Bool?
    let twitterScreenName: String?
    let websiteURL: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case facebookID = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinID = "linkedin_id"
        case location, name, organization
        case permanentID = "permanent_id"
        case profileImageURL = "profile_image_url"
        case teamOnly = "team_only"
        case twitterScreenName = "twitter_screen_name"
        case websiteURL = "website_url"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID)
        self.followeesCount = try container.decodeIfPresent(Int.self, forKey: .followeesCount)
        self.followersCount = try container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.githubLoginName = try container.decodeIfPresent(String.self, forKey: .githubLoginName)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.itemsCount = try container.decodeIfPresent(Int.self, forKey: .itemsCount)
        self.linkedinID = try container.decodeIfPresent(String.self, forKey: .linkedinID)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.organization = try container.decodeIfPresent(String.self, forKey: .organization)
        self.permanentID = try container.decodeIfPresent(Int.self, forKey: .permanentID)
        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        self.teamOnly = try container.decodeIfPresent(Bool.self, forKey: .teamOnly)
        self.twitterScreenName = try container.decodeIfPresent(String.self, forKey: .twitterScreenName)
        self.websiteURL = try container.decodeIfPresent(String.self, forKey: .websiteURL)
    }
}

