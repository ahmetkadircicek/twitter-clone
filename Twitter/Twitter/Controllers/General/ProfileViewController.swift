//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ahmet on 22.06.2023.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = true
    private var viewModel = ProfileViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 400))
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        bindViews()
        
        configureConstraints()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retreiveUser()
    }
    
    private func bindViews() {
        viewModel.$user.sink {[weak self] user in
            guard let user = user else { return }
            self?.headerView.profileDisplayNameLabel.text = user.displayName
            self?.headerView.profileUsernameLabel.text = "@\(user.username.lowercased())"
            self?.headerView.profileFollowingCountLabel.text = "\(user.followingCount)"
            self?.headerView.profileFollowersCountLabel.text = "\(user.followersCount)"
            self?.headerView.profileUserBioLabel.text = user.bio
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.profileJoinDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with: user.createdOn) ?? "Joined Dec 2009")"
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints(){
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 50 : 25)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as?
                TweetTableViewCell else {
            return UITableViewCell()
            
        }
            
        cell.selectionStyle = .none
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition >= 0 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0.9
            } completion: { _ in }
                
        } else if  yPosition < 0 && isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
}
