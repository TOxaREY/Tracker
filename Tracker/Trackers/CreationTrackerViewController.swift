//
//  CreationTrackerViewController..swift
//  Tracker
//
//  Created by Anton Reynikov on 18.05.2023.
//

import UIKit

final class CreationTrackerViewController: UIViewController {
    weak var delegateTrackers: TrackersViewControllerDelegate?
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.setTitle(
            NSLocalizedString(
                "habit.title",
                comment: "Title habit button"
            ),
            for: .normal
        )
        habitButton.layer.cornerRadius = 16
        habitButton.clipsToBounds = true
        habitButton.backgroundColor = .ypBlack
        habitButton.titleLabel?.font = .ypMedium_16
        habitButton.titleLabel?.textAlignment = .center
        habitButton.setTitleColor(.ypWhite, for: .normal)
        habitButton.addTarget(
            self,
            action: #selector(didTapHabitButton),
            for: .touchUpInside
        )
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        return habitButton
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.setTitle(
            NSLocalizedString(
                "irregularEvent.title",
                comment: "Title irregular event button"
            ),
            for: .normal
        )
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.clipsToBounds = true
        irregularEventButton.backgroundColor = .ypBlack
        irregularEventButton.titleLabel?.font = .ypMedium_16
        irregularEventButton.titleLabel?.textAlignment = .center
        irregularEventButton.setTitleColor(.ypWhite, for: .normal)
        irregularEventButton.addTarget(
            self,
            action: #selector(didIrregularEventButton),
            for: .touchUpInside
        )
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypWhite
        self.title = NSLocalizedString(
            "creationTracker.title",
            comment: "Creation tracker title"
        )
        self.navigationItem.hidesBackButton = true
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -8),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 8),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapHabitButton() {
        weak var pvc = self.presentingViewController
        
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let creationHabitVC = CreationHabitViewController()
            creationHabitVC.delegateTrackers = self.delegateTrackers
            let navVC = UINavigationController(rootViewController: creationHabitVC)
            navVC.modalPresentationStyle = .automatic
            pvc?.present(navVC, animated: true)
        }
    }
    
    @objc private func didIrregularEventButton() {
        weak var pvc = self.presentingViewController
        
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let creationIrregularEventVC = CreationIrregularEventViewController()
            creationIrregularEventVC.delegateTrackers = self.delegateTrackers
            let navVC = UINavigationController(rootViewController: creationIrregularEventVC)
            navVC.modalPresentationStyle = .automatic
            pvc?.present(navVC, animated: true)
        }
    }
}
