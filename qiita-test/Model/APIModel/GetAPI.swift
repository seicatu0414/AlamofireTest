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
    func sendUserApi(userId: String, apiType: Urls) async throws -> SearchUser {
        // URL作成
        var urlStr = Urls.MainUrl.rawValue + userId
        switch apiType {
        case.Items:
            urlStr = urlStr + Urls.Items.rawValue
        case .Followers:
            urlStr = urlStr + Urls.Followers.rawValue
        case .Followees:
            urlStr = urlStr + Urls.Followees.rawValue
        // 入る予定なし
        case .MainUrl:
            break
        }

        // Alamofireを使用してリクエストを作成
        let request = AF.request(urlStr, interceptor: .retryPolicy)
        
        // リクエストのレスポンスを待機して取得
        let response = await request.serializingDecodable(SearchUser.self).response
        // 失敗ならステータスコード返す
        guard let responseData = response.data else { throw Errors.networkError(response.response?.statusCode ?? 0) }
        let decoder = JSONDecoder()
        let searchUser = try decoder.decode(SearchUser.self, from: responseData)
        return searchUser
    }
}
