//
//  ProfileHeader.swift
//  Twitter
//
//  Created by Ahmet on 22.06.2023.
//

import UIKit

class ProfileTableViewHeader: UIView {
    
    private enum SectionTabs: String{
        case tweets = "Tweets"
        case replies = "Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self {
            case .tweets:
                return 0
            case .replies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return view
    }()
    
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
                    self?.sectionStackView.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                    
                }
            }
        }
    }
    
    private var tabs: [UIButton] = ["Tweets", "Replies", "Media", "Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.tintColor = .label
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
            
        }
    
    private lazy var sectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
        
    }()
    
    private let profileFollowersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "23"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let profileFollowersTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let profileFollowingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "216"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let profileFollowingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    private let profileJoinDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "December 2009"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let profileJoinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileUserBioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "iOS Developer"
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    
    private let profileUsernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@akadircicek"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let profileDisplayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ahmet"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let profileAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "header")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(profileDisplayNameLabel)
        addSubview(profileUsernameLabel)
        addSubview(profileUserBioLabel)
        addSubview(profileJoinDateImageView)
        addSubview(profileJoinDateLabel)
        addSubview(profileFollowingCountLabel)
        addSubview(profileFollowingTextLabel)
        addSubview(profileFollowersTextLabel)
        addSubview(profileFollowersCountLabel)
        addSubview(sectionStackView)
        addSubview(indicator)
        
        configureStackButton()
        configureConstraints()
        
    }
    
    private func configureStackButton(){
        for(i ,button) in sectionStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            
            if i == selectedTab {
                button.tintColor = .label
                
            } else {
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self, action: #selector(didTapTab), for: .touchUpInside)
        }
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.tweets.rawValue:
            selectedTab = 0
        case SectionTabs.replies.rawValue:
            selectedTab = 1
        case SectionTabs.media.rawValue:
            selectedTab = 2
        case SectionTabs.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureConstraints() {
        
        for i in 0..<tabs.count {
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
            
        }
        
        let profileHeaderImageViewConstraints = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 180)
        ]
        
        let profileAvatarImageViewConstraints = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let profileDisplayNameLabelConstraints = [
            profileDisplayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            profileDisplayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 8)
        ]
        
        let profileUsernameLabelConstraints = [
            profileUsernameLabel.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor),
            profileUsernameLabel.topAnchor.constraint(equalTo: profileDisplayNameLabel.bottomAnchor)
        ]
        
        let profileUserBioLabelConstraints = [
            profileUserBioLabel.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor),
            profileUserBioLabel.topAnchor.constraint(equalTo: profileUsernameLabel.bottomAnchor, constant: 8),
            profileUserBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        let profileJoinDateImageViewConstraints = [
            profileJoinDateImageView.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor),
            profileJoinDateImageView.topAnchor.constraint(equalTo: profileUserBioLabel.bottomAnchor, constant: 8)
        ]
        
        let profileJoinDateLabelConstraints = [
            profileJoinDateLabel.leadingAnchor.constraint(equalTo: profileJoinDateImageView.trailingAnchor, constant: 5),
            profileJoinDateLabel.centerYAnchor.constraint(equalTo: profileJoinDateImageView.centerYAnchor)
        ]
        
        let profileFollowingCountLabelConstraints = [
            profileFollowingCountLabel.leadingAnchor.constraint(equalTo: profileDisplayNameLabel.leadingAnchor),
            profileFollowingCountLabel.topAnchor.constraint(equalTo: profileJoinDateImageView.bottomAnchor, constant: 8)
        ]
        
        let profileFollowingTextLabelConstraints = [
            profileFollowingTextLabel.leadingAnchor.constraint(equalTo: profileFollowingCountLabel.trailingAnchor, constant: 4),
            profileFollowingTextLabel.centerYAnchor.constraint(equalTo: profileFollowingCountLabel.centerYAnchor)
        ]

        let profileFollowersCountLabelConstraints = [
            profileFollowersCountLabel.leadingAnchor.constraint(equalTo: profileFollowingTextLabel.trailingAnchor, constant: 8),
            profileFollowersCountLabel.centerYAnchor.constraint(equalTo: profileFollowingTextLabel.centerYAnchor)
        ]

        let profileFollowersTextLabelConstraints = [
            profileFollowersTextLabel.leadingAnchor.constraint(equalTo: profileFollowersCountLabel.trailingAnchor, constant: 4),
            profileFollowersTextLabel.centerYAnchor.constraint(equalTo: profileFollowersCountLabel.centerYAnchor)
        ]
        
        let sectionStackViewConstraints = [
            sectionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStackView.topAnchor.constraint(equalTo: profileFollowingCountLabel.bottomAnchor, constant: 5),
            sectionStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[0].bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 2)
        ]
        
        NSLayoutConstraint.activate(profileUsernameLabelConstraints)
        NSLayoutConstraint.activate(profileDisplayNameLabelConstraints)
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(profileUserBioLabelConstraints)
        NSLayoutConstraint.activate(profileJoinDateImageViewConstraints)
        NSLayoutConstraint.activate(profileJoinDateLabelConstraints)
        
        NSLayoutConstraint.activate(profileFollowingCountLabelConstraints)
        NSLayoutConstraint.activate(profileFollowingTextLabelConstraints)
        NSLayoutConstraint.activate(profileFollowersCountLabelConstraints)
        NSLayoutConstraint.activate(profileFollowersTextLabelConstraints)
        
        NSLayoutConstraint.activate(sectionStackViewConstraints)
        NSLayoutConstraint.activate(indicatorConstraints)
    }
}
