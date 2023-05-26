//
//  DaySelectingViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 24.05.2023.
//

import UIKit

class DaySelectingViewController: UIViewController {

    let dayLabel                = UILabel()
    let titleLabel              = UILabel()
    let dayNumberLabel          = UILabel()
    let dayLabelStackView       = UIStackView()
    let pickerView              = UIPickerView()
    var dayCounter              = 1
    let backgroundView          = UIView()
    let startButton             = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    fileprivate func setViews() {
        //Default view.
        view.addSubview(backgroundView)
        view.addSubview(startButton)
        view.backgroundColor = .systemGray6

        //Background view.
        backgroundView.layer.cornerRadius = 20
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white

        //Start Button.
        startButton.translatesAutoresizingMaskIntoConstraints     = false
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 20
        startButton.isEnabled = true
        startButton.setTitle("Next", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        startButton.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)

        //Title Label.
        backgroundView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.text = "From which day do you want to start?"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5

        //Day labels
        dayNumberLabel.text = "1."
        dayNumberLabel.textColor = .black
        dayNumberLabel.font    = UIFont.systemFont(ofSize: 40, weight: .semibold)
        dayLabelStackView.addArrangedSubview(dayNumberLabel)
        
        dayLabel.text = "day"
        dayLabel.textColor = .black
        dayLabel.font.withSize(20)
        dayLabelStackView.addArrangedSubview(dayLabel)
            
        dayLabelStackView.axis = .horizontal
        dayLabelStackView.alignment = .firstBaseline
        dayLabelStackView.distribution = .equalSpacing
        dayLabelStackView.spacing = 6
        
        backgroundView.addSubview(dayLabelStackView)
        backgroundView.addSubview(pickerView)

        //Picker view.
        pickerView.delegate   = self
        pickerView.dataSource = self

        dayLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints        = false
        titleLabel.translatesAutoresizingMaskIntoConstraints        = false

        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),

            dayLabelStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            dayLabelStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            pickerView.topAnchor.constraint(equalTo: dayLabelStackView.bottomAnchor, constant: 16),
            pickerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

    }
    
    
    @objc func startButtonClicked(_ sender: Any) {
        print("clicked")
    }
    
    
}


extension DaySelectingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 74
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayCounter = row + 1
        dayNumberLabel.text = "\(dayCounter)."
        dayLabel.text = dayCounter == 1 ? "day" : "days"
    }
    
}
