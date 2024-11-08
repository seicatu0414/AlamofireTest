//
//  QiitaFollowerAndFolloweeViewController.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/08.
//

import Foundation
import UIKit

class QiitaFollowerAndFolloweeViewController: UIViewController {
    
    @IBOutlet weak var followeeOrFollowerTableView: UITableView!
    @IBOutlet weak var followeeOrFollowerSegmentedControl: UISegmentedControl!
    var viewModel:QiitaFollowerAndFolloweeViewModel = QiitaFollowerAndFolloweeViewModel()
    var defaultSelectSegment:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBackButton()
        followeeOrFollowerSegmentedControl.selectedSegmentIndex = defaultSelectSegment
        followeeOrFollowerTableView.delegate = self
        followeeOrFollowerTableView.dataSource = self
        followeeOrFollowerTableView.register(UINib(nibName: "UserFolloweeCell", bundle: nil), forCellReuseIdentifier: "UserFolloweeCell")
        followeeOrFollowerTableView.register(UINib(nibName: "UserFollowerCell", bundle: nil), forCellReuseIdentifier: "UserFollowerCell")
    }
    
    @IBAction func segmentCanged(_ sender: Any) {
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            callFolloweeAPI()
        case 1:
            callFollowerAPI()
        default:
            callFollowerAPI()
        }
    }
    
    @MainActor
    private func callFollowerAPI(){
        guard let userId = viewModel.searchUserInfo?.id else { return }
        Task {
            do {
                try await viewModel.getFollowerSend(userId: userId)
                followeeOrFollowerTableView.reloadData()
            } catch Errors.networkError(let statusCode) {
                showAlert(with: statusCode)
            }
            
        }
    }
    @MainActor
    private func callFolloweeAPI(){
        guard let userId = viewModel.searchUserInfo?.id else { return }
        Task {
            do {
                try await viewModel.getFolloweeSend(userId: userId)
                followeeOrFollowerTableView.reloadData()
            } catch Errors.networkError(let statusCode) {
                showAlert(with: statusCode)
            }
            
        }
    }
    // ViewModelにアクセス
    @MainActor
    private func callUserAPI(uerId:String){
        Task{
            do {
                try await viewModel.getAPISend(userId: uerId)
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)//遷移先のStoryboardを設定
                let userDetailViewController = storyboard.instantiateViewController(withIdentifier: "userDetailViewController") as! QiitaUserDetailViewController
                userDetailViewController.viewModel.searchUserInfo = viewModel.searchUserInfo
                //遷移先のViewControllerを設定
                self.navigationController?.pushViewController(userDetailViewController, animated: true)
            } catch Errors.networkError(let statusCode) {
                showAlert(with: statusCode)
            }
            
        }
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
    @MainActor
    private func showAlert(with statusCode: Int) {
        let alert = UIAlertController(title: "Error", message: "ネットワークエラーが発生しました。 code: \(statusCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension QiitaFollowerAndFolloweeViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch followeeOrFollowerSegmentedControl.selectedSegmentIndex {
        case 0:
            guard let followeesInfo = viewModel.userFolloweesInfo else {
                return UITableViewCell()
            }
            
            let cellInfo = followeesInfo[indexPath.row]
            let userFolloweeCell = tableView.dequeueReusableCell(withIdentifier: "UserFolloweeCell", for: indexPath) as! UserFolloweeCell
            userFolloweeCell.cellInit(profileImageUrl: cellInfo.profileImageURL,
                                      userName: cellInfo.name,
                                      followeesCount: cellInfo.followeesCount,
                                      followersCount: cellInfo.followersCount,
                                      userId: cellInfo.id)
            return userFolloweeCell
        case 1:
            guard let followersInfo = viewModel.userFollowersInfo else {
                return UITableViewCell()
            }
            
            let cellInfo = followersInfo[indexPath.row]
            let userFollowerCell = tableView.dequeueReusableCell(withIdentifier: "UserFollowerCell", for: indexPath) as! UserFollowerCell
            userFollowerCell.cellInit(profileImageUrl: cellInfo.profileImageURL,
                                      userName: cellInfo.name,
                                      followeesCount: cellInfo.followeesCount,
                                      followersCount: cellInfo.followersCount,
                                      userId: cellInfo.id)
            
            // cellBの設定
            return userFollowerCell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch followeeOrFollowerSegmentedControl.selectedSegmentIndex {
        case 0:
            guard let searchedUserInfo = viewModel.userFolloweesInfo else {
                return 0
            }
            return searchedUserInfo.count
        case 1:
            guard let searchedUserInfo = viewModel.userFollowersInfo else {
                return 0
            }
            return searchedUserInfo.count
        default:
            return 0
        }
    }
}

extension QiitaFollowerAndFolloweeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch followeeOrFollowerSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.cellForRow(at: indexPath) as! UserFolloweeCell
            let userId = cell.userId
            callUserAPI(uerId: userId)
        case 1:
            // 選択したセルを取得
            let cell = tableView.cellForRow(at: indexPath) as! UserFollowerCell
            let userId = cell.userId
            callUserAPI(uerId: userId)
        default:
            break
        }
    }
    
}

