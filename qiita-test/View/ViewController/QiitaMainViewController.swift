//
//  QiitaMainViewController.swift
//  qiita-test
//
//  Created by yamaguchi kohei on 2024/11/01.
//
import UIKit
import Foundation

class QiitaMainViewController: UIViewController {
    
    @IBOutlet weak var SeachedUserTableView: UITableView!
    @IBOutlet weak var userIdTextField: UITextField!
    var viewModel:QiitaMainViewModel = QiitaMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SeachedUserTableView.delegate = self
        SeachedUserTableView.dataSource = self
        SeachedUserTableView.register(UINib(nibName: "SearchedUserCell", bundle: nil), forCellReuseIdentifier: "SearchedUserCell")
        readUserEntity()
        setUpNavigationBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readUserEntity()
    }
    
    @IBAction func UserSearchButton(_ sender: Any) {
        guard let userId = userIdTextField.text else {
            return
        }
        callUserAPI(uerId: userId)
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
    
    @MainActor
    private func showAlert(with statusCode: Int) {
        let alert = UIAlertController(title: "Error", message: "ネットワークエラーが発生しました。 code: \(statusCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    // ViewModelにアクセス
    
    private func readUserEntity() {
        viewModel.readUserInfoFromCoreData()
        SeachedUserTableView.reloadData()
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
}

extension QiitaMainViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchedUserInfo = viewModel.searchedUserInfo else {
            return 0
        }
        return searchedUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serchedUserInfo = viewModel.searchedUserInfo else {
            return UITableViewCell()
        }
        
        let cellInfo = serchedUserInfo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedUserCell", for: indexPath) as! SearchedUserCell
        cell.cellInit(profileImageData: cellInfo.profileImageData,
                      userName: cellInfo.name,
                      followeesCount: cellInfo.followeesCount,
                      followersCount: cellInfo.followersCount,
                      userId: cellInfo.id)
        return cell
    }
}

extension QiitaMainViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルを取得
        let cell = tableView.cellForRow(at: indexPath) as! SearchedUserCell
        let userId = cell.userId
        callUserAPI(uerId:userId)
    }
}
