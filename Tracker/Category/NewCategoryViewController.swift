//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    weak var delegateDataSource: DataSourceDelegate?
    private let trackerCategoryStore = TrackerCategoryStore()
    private lazy var readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.setTitle("Готово", for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.clipsToBounds = true
        readyButton.backgroundColor = .ypGray
        readyButton.titleLabel?.font = .ypMedium_16
        readyButton.titleLabel?.textAlignment = .center
        readyButton.setTitleColor(.ypWhite, for: .normal)
        readyButton.addTarget(
            self,
            action: #selector(didReadyButton),
            for: .touchUpInside
        )
        readyButton.isEnabled = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        return readyButton
    }()
    private lazy var nameCategoryTextField: UITextField = {
        let nameCategoryTextField = UITextField()
        nameCategoryTextField.delegate = self
        nameCategoryTextField.attributedPlaceholder = NSAttributedString(string: "Введите название категории", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ypGray])
        nameCategoryTextField.backgroundColor = .ypBackground
        nameCategoryTextField.font = .ypRegular_17
        nameCategoryTextField.textColor = .ypBlack
        nameCategoryTextField.layer.cornerRadius = 16.0
        nameCategoryTextField.layer.masksToBounds = true
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameCategoryTextField.leftViewMode = .always
        nameCategoryTextField.leftView = view
        nameCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameCategoryTextField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypWhite
        self.title = "Новая категория"
        addSubviews()
        makeConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

    private func addSubviews() {
        view.addSubview(nameCategoryTextField)
        view.addSubview(readyButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didReadyButton() {
        guard let nameCategory = nameCategoryTextField.text else { return }
        trackerCategoryStore.addCategory(title: nameCategory)
        delegateDataSource?.creationEvent.categoryName = nameCategory
        self.dismiss(animated: true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if !textField.text!.isEmpty {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .ypBlack
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = .ypGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
