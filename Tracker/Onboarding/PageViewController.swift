//
//  PageViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 27.07.2023.
//

import UIKit

final class PageViewController: UIViewController {
    private let backgroundImage: UIImage
    private let titlePage: String
    
    lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = titlePage
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .center
        titleLabel.font = .ypBold_32
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("Вот это технологии!", for: .normal)
        startButton.layer.cornerRadius = 16
        startButton.clipsToBounds = true
        startButton.backgroundColor = .ypBlack
        startButton.titleLabel?.font = .ypMedium_16
        startButton.titleLabel?.textAlignment = .center
        startButton.setTitleColor(.ypWhite, for: .normal)
        startButton.addTarget(
            self,
            action: #selector(didStartButton),
            for: .touchUpInside
        )
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    init(backgroundImage: UIImage, titlePage: String) {
        self.backgroundImage = backgroundImage
        self.titlePage = titlePage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(startButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -160),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didStartButton() {
        let tabBarController = TabBarController()
        UIApplication.shared.windows.first?.rootViewController = tabBarController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
