//
//  QiitaFollowerAndFolloweeViewModel.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/08.
//

import Foundation

class QiitaFollowerAndFolloweeViewModel {
    var userFollowersInfo : [SearchUserFollowers]?
    var userFolloweesInfo : [SearchUserFollowee]?
    var searchUserInfo : SearchUser? = nil
    var iconData: Data?
    
    func getAPISend(userId:String) async throws {
        do {
            searchUserInfo = try await GetAPI().sendUserApi(userId: "\(userId)")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    
    func getFolloweeSend(userId:String) async throws {
        do {
            userFolloweesInfo = try await GetAPI().sendFolloweesApi(userId: "\(userId)")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    
    func getFollowerSend(userId:String) async  throws{
        do {
            userFollowersInfo = try await GetAPI().sendFollowersApi(userId: "\(userId)")
        } catch Errors.decodingError {
            print("デコード失敗")
        } catch Errors.networkError(let statusCode) {
            throw Errors.networkError(statusCode)
        } catch {
            print("不明なエラー")
        }
    }
    
    func getIcon(url:String) async -> Data {
        do {
            let iconData = try await GetAPI().sendGetIconData(url: "\(url)")
            self.iconData = iconData
            return iconData
        } catch Errors.networkError(let statusCode) {
            print("通信失敗:ステータスコード\(statusCode)")
        } catch {
            print("不明なエラー")
        }
        return Data()
    }
}
