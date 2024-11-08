//
//  UserFolloweeCell.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/08.
//

import Foundation
import UIKit

class UserFolloweeCell:UITableViewCell {
    
    @IBOutlet weak var followeeIconImageView: UIImageView!
    @IBOutlet weak var followeeNameLabel: UILabel!
    @IBOutlet weak var followeeFollowersCountLabel: UILabel!
    @IBOutlet weak var followeeFolloweesCountLabel: UILabel!
    let viewModel = UserFolloweeCellViewModel()
    
    var userId:String = ""
    func cellInit(profileImageUrl: String?,
                  userName: String?,
                  followeesCount: Int?,
                  followersCount: Int?,
                  userId:String?) {
        // データがないときはNoImageを返す
        let image:UIImage = UIImage(named: "NoImage")!
        followeeIconImageView.image = image
        if let profileImageUrl = profileImageUrl {
            getIcon(url: profileImageUrl)
        }
        guard let userName = userName else { return }
        guard let followeesCount = followeesCount else { return }
        guard let followersCount = followersCount else { return }
        guard let userId = userId else { return }
        self.followeeNameLabel.text = userName
        self.followeeFolloweesCountLabel.text = String(followeesCount)
        self.followeeFollowersCountLabel.text = String(followersCount)
        self.userId = userId
    }
    @MainActor
    private func getIcon(url:String) {
        Task{
            let iconData = await viewModel.getIcon(url:url)
            let icon = UIImage(data: iconData) ?? UIImage(named: "NoImage")
            followeeIconImageView.image = icon
            followeeIconImageView.makeCircule()
        }
    }
}
