//
//  DaySelectingViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 24.05.2023.
//

import UIKit
import CoreData

class DaySelectingViewController: UIViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
    
    fileprivate func setGoals() {
        //MARK: - Delete
        let deleteFetch   = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }

        //MARK: - Objects
        let goalNumber1 = Goal(context: self.context)
        goalNumber1.title = "goal1".localized()
        goalNumber1.id = 0
        goalNumber1.isCompleted = false
        
        let goalNumber2 = Goal(context: self.context)
        goalNumber2.title = "goal2".localized()
        goalNumber2.id = 1
        goalNumber2.isCompleted = false

        
        let goalNumber3 = Goal(context: self.context)
        goalNumber3.title = "goal3".localized()
        goalNumber3.id = 2
        goalNumber3.isCompleted = false
        
        
        let goalNumber4 = Goal(context: self.context)
        goalNumber4.title = "goal4".localized()
        goalNumber4.id = 3
        goalNumber4.isCompleted = false
        
        let goalNumber5 = Goal(context: self.context)
        goalNumber5.title = "goal5".localized()
        goalNumber5.id = 4
        goalNumber5.isCompleted = false
        
        let goalNumber6 = Goal(context: self.context)
        goalNumber6.title = "goal6".localized()
        goalNumber6.id = 5
        goalNumber6.isCompleted = false
        
        let goalNumber7 = Goal(context: self.context)
        goalNumber7.title = "goal7".localized()
        goalNumber7.id = 6
        goalNumber7.isCompleted = false
        
        //MARK: - Save new objects.
        do {
            try self.context.save()
        }
        catch {
            print("error! data couldnt be saved!")
        }
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
        startButton.setTitle("next".localize(), for: .normal)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        startButton.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)

        //Title Label.
        backgroundView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.text = "fromday".localized()
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
        
        dayLabel.text = "day".localized()
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
        setGoals()
        
        // MARK: - Take current time
        let currentDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: ((dayCounter) * (-1) + 1), to: currentDate)
        
        // MARK: -  If there are already data, delete them.
        let deleteFetch     = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        let deleteRequest   = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
        
        // MARK: - Save it.
        let saveMin       = Time(context: self.context)
        saveMin.startDate = startDate
        saveMin.lastDate  = startDate
        do {
            try self.context.save()
           } catch {
            print("error! time couldnt be saved!")
         }
        UserDefaults.standard.hasOnboarded = true
        performSegue(withIdentifier: "toMainApp", sender: nil)
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
        dayLabel.text = dayCounter == 1 ? "day".localize() : "days".localize()
    }
    
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
