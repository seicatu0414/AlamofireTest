//
//  QiitaUserDetailViewController.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/07.
//

import SafariServices
import Foundation
import UIKit
class QiitaUserDetailViewController: UIViewController {
    
    @IBOutlet weak var userItemsTableView: UITableView!
    @IBOutlet weak var userProfileIconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followeeButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    var viewModel:QiitaUserDetailViewModel = QiitaUserDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userItemsTableView.delegate = self
        userItemsTableView.dataSource = self
        userItemsTableView.register(UINib(nibName: "UserCreateItemsCell", bundle: nil), forCellReuseIdentifier: "UserCreateItemsCell")
        // 情報を画面に反映
        if let searchUserInfo = viewModel.searchUserInfo {
            guard let profileImageURL = searchUserInfo.profileImageURL else {return}
            getIcon(url: profileImageURL)
            callItemsAPI()
            guard let followeesCount = searchUserInfo.followeesCount else {return}
            guard let followersCount = searchUserInfo.followersCount else {return}
            guard let description = searchUserInfo.description else {return}
            guard let name = searchUserInfo.name else {return}
            followeeButton.setTitle(String(followeesCount), for: .normal)
            followerButton.setTitle(String(followersCount), for: .normal)
            
            descriptionLabel.text = description
            userNameLabel.text = name
        }
        setUpNavigationBackButton()
        followeeButton.setTitleColor(UIColor(named: "StringBlack"), for: .normal)
        followerButton.setTitleColor(UIColor(named: "StringBlack"), for: .normal)
    }
    @IBAction func followeeButton(_ sender: Any) {
        callFolloweeAPI()
    }
    
    @IBAction func followerButton(_ sender: Any) {
        callFollowerAPI()
    }
    
    private func setUpNavigationBackButton() {
        // 次の画面のBackボタンを「戻る」に変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title:  "戻る",
            style:  .plain,
            target: nil,
            action: nil
        )
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "White")
    }
    // 画面を閉じる時CoreDataに書き込む
    override func viewWillDisappear(_ animated: Bool) {
        writeUserEntity()
    }
    
    
    @MainActor
    private func getIcon(url:String) {
        Task{
            let iconData = await viewModel.getIcon(url:url)
            let icon = UIImage(data: iconData) ?? UIImage(named: "NoImage")
            userProfileIconImageView.image = icon
            userProfileIconImageView.makeCircule()
        }
    }
    
    @MainActor
    private func callFolloweeAPI(){
        guard let userId = viewModel.searchUserInfo?.id else { return }
        Task {
            do {
                try await viewModel.getFolloweeSend(userId: userId)
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let qiitaFollowerAndFolloweeViewController = storyboard.instantiateViewController(withIdentifier: "QiitaFollowerAndFolloweeViewController") as! QiitaFollowerAndFolloweeViewController
                qiitaFollowerAndFolloweeViewController.viewModel.searchUserInfo = viewModel.searchUserInfo
                qiitaFollowerAndFolloweeViewController.viewModel.userFolloweesInfo = viewModel.userFolloweesInfo
                qiitaFollowerAndFolloweeViewController.defaultSelectSegment = 0
                //遷移先のViewControllerを設定
                self.navigationController?.pushViewController(qiitaFollowerAndFolloweeViewController, animated: true)
            } catch Errors.networkError(let statusCode) {
                showAlert(with: statusCode)
            }
            
        }
    }
    @MainActor
    private func callFollowerAPI(){
        guard let userId = viewModel.searchUserInfo?.id else { return }
        Task {
            do {
                try await viewModel.getFollowerSend(userId: userId)
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let qiitaFollowerAndFolloweeViewController = storyboard.instantiateViewController(withIdentifier: "QiitaFollowerAndFolloweeViewController") as! QiitaFollowerAndFolloweeViewController
                qiitaFollowerAndFolloweeViewController.viewModel.searchUserInfo = viewModel.searchUserInfo
                qiitaFollowerAndFolloweeViewController.viewModel.userFollowersInfo = viewModel.userFollowersInfo
                qiitaFollowerAndFolloweeViewController.defaultSelectSegment = 1
                //遷移先のViewControllerを設定
                self.navigationController?.pushViewController(qiitaFollowerAndFolloweeViewController, animated: true)
            } catch Errors.networkError(let statusCode) {
                showAlert(with: statusCode)
            }
        }
    }
    @MainActor
    private func callItemsAPI(){
        guard let userId = viewModel.searchUserInfo?.id else { return }
        Task {
            do {
                try await viewModel.getUserItemsSend(userId: userId)
                userItemsTableView.reloadData()
            } catch Errors.networkError(let statusCode) {
                showAlert(with: statusCode)
            }
            
        }
    }
    // ViewModelにアクセス
    private func writeUserEntity() {
        viewModel.wrightUserInfoFromCoreData()
    }
    
    @MainActor
    private func showAlert(with statusCode: Int) {
        let alert = UIAlertController(title: "Error", message: "ネットワークエラーが発生しました。 code: \(statusCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
extension QiitaUserDetailViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchedUserInfo = viewModel.searchUserItemsInfo else {
            return 0
        }
        return searchedUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serchItemsInfo = viewModel.searchUserItemsInfo else {
            return UITableViewCell()
        }
        
        let cellInfo = serchItemsInfo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCreateItemsCell", for: indexPath) as! UserCreateItemsCell
        cell.initCell(title: cellInfo.title!, createDate: cellInfo.createdAt!, tags: cellInfo.tags!, LGTM: cellInfo.likesCount!)
        return cell
    }
}

extension QiitaUserDetailViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlStr = viewModel.searchUserItemsInfo![indexPath.row].url else { return }
        // 表示したいURLを作成
        if let url = URL(string: urlStr) {
            // SFSafariViewControllerを初期化
            let safariViewController = SFSafariViewController(url: url)
            // SFSafariViewControllerを表示
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
