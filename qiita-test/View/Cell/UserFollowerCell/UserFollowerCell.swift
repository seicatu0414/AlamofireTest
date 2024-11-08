//
//  UserFollowerCell.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/08.
//

import Foundation
import UIKit

class UserFollowerCell:UITableViewCell {
    
    @IBOutlet weak var followerUserIConImageView: UIImageView!
    @IBOutlet weak var followerUserNaameLabel: UILabel!
    @IBOutlet weak var followerFollowersCountLabel: UILabel!
    @IBOutlet weak var folllowersFolloweeCountLabel: UILabel!
    let viewModel:UserFollowerCellViewModel = UserFollowerCellViewModel()
    
    var userId:String = ""
    func cellInit(profileImageUrl: String?,
                  userName: String?,
                  followeesCount: Int?,
                  followersCount: Int?,
                  userId:String?) {
        // データがないときはNoImageを返す
        let image:UIImage = UIImage(named: "NoImage")!
        followerUserIConImageView.image = image
        if let profileImageUrl = profileImageUrl {
            getIcon(url: profileImageUrl)
        }
        guard let userName = userName else { return }
        guard let followeesCount = followeesCount else { return }
        guard let followersCount = followersCount else { return }
        guard let userId = userId else { return }
        self.followerUserIConImageView.image = image
        // ImageViewを丸くする
        self.followerUserIConImageView.makeCircule()
        self.followerUserNaameLabel.text = userName
        self.folllowersFolloweeCountLabel.text = String(followeesCount)
        self.folllowersFolloweeCountLabel.text = String(followersCount)
        self.userId = userId
    }
    @MainActor
    private func getIcon(url:String) {
        Task{
            let iconData = await viewModel.getIcon(url:url)
            let icon = UIImage(data: iconData) ?? UIImage(named: "NoImage")
            followerUserIConImageView.image = icon
        }
    }
}
