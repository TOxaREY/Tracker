//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Anton Reynikov on 19.05.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    weak var delegateDataSource: DataSourceDelegate?
    private var nameCategoryTextField: UITextField?
    private var readyButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Новая категория"
        configureViews()
        addSubviews()
        makeConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private func configureViews() {
        self.view.backgroundColor = .ypWhite
        
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
        self.nameCategoryTextField = nameCategoryTextField
        
        let readyButton = UIButton()
        readyButton.setTitle("Готово", for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.clipsToBounds = true
        readyButton.backgroundColor = .ypGray
        readyButton.titleLabel?.font = .ypMedium_16
        readyButton.titleLabel?.textAlignment = .center
        readyButton.setTitleColor(.ypWhite, for: .normal)
        readyButton.addTarget(self, action: #selector(didReadyButton), for: .touchUpInside)
        readyButton.isEnabled = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        self.readyButton = readyButton
    }
    
    private func addSubviews() {
        view.addSubview(nameCategoryTextField ?? UITextField())
        view.addSubview(readyButton ?? UIButton())
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            nameCategoryTextField!.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategoryTextField!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameCategoryTextField!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            readyButton!.heightAnchor.constraint(equalToConstant: 60),
            readyButton!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didReadyButton() {
        delegateDataSource?.creationEvent.categoryArray.append((title: nameCategoryTextField!.text!, isChecked: true))
        if delegateDataSource?.creationEvent.categoryArray.count != 1 {
            for i in 0...delegateDataSource!.creationEvent.categoryArray.count - 2 {
                delegateDataSource?.creationEvent.categoryArray[i].isChecked = false
            }
        }
        delegateDataSource?.setDataSource()
        self.dismiss(animated: true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text != "" {
            readyButton?.isEnabled = true
            readyButton?.backgroundColor = .ypBlack
        } else {
            readyButton?.isEnabled = false
            readyButton?.backgroundColor = .ypGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
