//
//  GetAPI.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/01.
//

import Foundation
import Alamofire

class GetAPI {
    // https://qiita.com/api/v2/users/user_id
    // User情報に紐づくAPIにGetする
    func sendUserApi(userId: String) async throws -> SearchUser {
        // URL作成
        let urlStr = Urls.MainUrl.rawValue + userId
        let responseData = try await AlamoFireRequest(urlStr: urlStr, interceptor: .retryPolicy)
        let decoder = JSONDecoder()
        do {
            let searchUser = try decoder.decode(SearchUser.self, from: responseData)
            return searchUser
        } catch {
            throw Errors.decodingError
        }
    }
    
    // https://qiita.com/api/v2/users/user_id/items
    // User情報に紐づくItemsAPIにGetする
    func sendUserItemsApi(userId: String) async throws -> [SearchUserItems] {
        // URL作成
        let urlStr = Urls.MainUrl.rawValue + userId + Urls.Items.rawValue
        let responseData = try await AlamoFireRequest(urlStr: urlStr, interceptor: .retryPolicy)
        let decoder = JSONDecoder()
        do {
            let searchUserItems = try decoder.decode([SearchUserItems].self, from: responseData)
            return searchUserItems
        } catch {
            throw Errors.decodingError
        }
    }
    
    // https://qiita.com/api/v2/users/:user_id/followees
    // FolloweeAPIをGetする
    func sendFolloweesApi(userId: String) async throws -> [SearchUserFollowee] {
        // URL作成
        let urlStr = Urls.MainUrl.rawValue + userId + Urls.Followees.rawValue
        let responseData = try await AlamoFireRequest(urlStr: urlStr, interceptor: .retryPolicy)
        let decoder = JSONDecoder()
        do {
            let followees = try decoder.decode([SearchUserFollowee].self, from: responseData)
            return followees
        } catch {
            throw Errors.decodingError
        }
    }
    
    // https://qiita.com/api/v2/users/:user_id/followers
    // FollowerAPIをGetする
    func sendFollowersApi(userId: String) async throws -> [SearchUserFollowers] {
        // URL作成
        let urlStr = Urls.MainUrl.rawValue + userId + Urls.Followers.rawValue
        let responseData = try await AlamoFireRequest(urlStr: urlStr, interceptor: .retryPolicy)
        let decoder = JSONDecoder()
        do {
            let followers = try decoder.decode([SearchUserFollowers].self, from: responseData)
            return followers
        } catch {
            throw Errors.decodingError
        }
    }
    // アイコンの取得
    func sendGetIconData(url: String) async throws -> Data {
        let responseData = try await AlamoFireRequest(urlStr: url, interceptor: .retryPolicy)
        return responseData
        
    }
    
    private func AlamoFireRequest(urlStr: String, interceptor: RetryPolicy) async throws -> Data {
        let request = AF.request(urlStr, interceptor: interceptor)
        let response = await request.serializingDecodable(SearchUser.self).response
        
        // ステータスコードを取得
        guard let statusCode = response.response?.statusCode else {
            throw Errors.networkError(0)
        }
        
        if statusCode != 200 {
            throw Errors.networkError(statusCode)
        }
        
        // レスポンスデータを取得
        guard let responseData = response.data else {
            throw Errors.networkError(statusCode)
        }
        
        return responseData
    }
    
}
