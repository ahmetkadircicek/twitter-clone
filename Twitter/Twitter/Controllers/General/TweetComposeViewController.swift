//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Ahmet on 29.06.2023.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    
    private var viewModel = TweetComposeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .white
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        return button
    }()
    
    private let tweetContentTextView: UITextView = {
       
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's happening"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapToCancel))
        tweetContentTextView.delegate = self
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        
        configureConstraints()
        bindViews()
    }
    
    @objc private func didTapToTweet() {
        viewModel.dispatchTweet()
    }
    
    private func configureConstraints() {
        let tweetButtonConstaints = [
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tweetButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let tweetContentTextViewConstraints = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetContentTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -10)
            
        ]
        
        NSLayoutConstraint.activate(tweetContentTextViewConstraints)
        NSLayoutConstraint.activate(tweetButtonConstaints)
    }
    
    private func bindViews() {
        viewModel.$isValidToTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = true
        } .store(in: &subscriptions)
        
        viewModel.$shouldDismissComposer.sink { [weak self]success in
            if success {
                self?.dismiss(animated: true)
            }
            
        }
        .store(in: &subscriptions)
    }
    
    @objc private func didTapToCancel() {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
    }
}

extension TweetComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}
