//
//  GetStartedViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 2.02.2023.
//

import UIKit
import Lottie
import CoreData


class GetStartedViewController: UIViewController, UITextFieldDelegate {
    
    /* This viewController is actually used as many different viewController. Instead of creating
     custom viewController for every page on onboarding, i added all views together, and hide or showed the ones
     i need for each page.*/

    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //MARK: - All Views & Variables
    let collectionView: UICollectionView = {
        let layout         = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        layout.estimatedItemSize       = .zero
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let backgroundView          = UIView()
    let descriptionLabel        = UILabel()
    let textLabel               = UILabel()
    let titleLabel              = UILabel()
    let dayNumberLabel          = UILabel()
    let dayLabel                = UILabel()
    let nextButton              = UIButton()
    let dayLabelStackView       = UIStackView()
    let stackView               = UIStackView()
    let textField               = UITextField()
    let pickerView              = UIPickerView()
    var bgViewTopConstraint     : NSLayoutConstraint?
    var bgViewStretchConstraint : NSLayoutConstraint?
    var selectedIndexPath       : IndexPath?
    var titleTexts              : [String] = [""]
    var ages                    : [String] = [""]
    var dayCounter              = 1
    var currentPage             = 1
    var pageControl             = 0
    var animationView           : LottieAnimationView!
    var userName                : String = ""
    var userAge                 : String = ""

    let goalsText          = ["Read 10 min everyday" , "Visualize of future you!", "Drink 3 L water everyday", "Go for running 30 min", "Take photo of your body", "Share this on İnstangram to put pressure on yourself"]

    
    let isThisViewHidden = [
       ["textField": true,
        "titleLabel": true,
        "collectionView": false,
        "animationView": false,
        "descriptionLabel": false,
        "nextBtn": false,
        "stackView": false,
        "pickerView": false,
        "dayLabelStackView": false,
       ],
       
       ["textField": false,
        "titleLabel": true,
        "collectionView": false,
        "animationView": true,
        "descriptionLabel": true,
        "nextBtn": true,
        "stackView": false,
        "pickerView": false,
        "dayLabelStackView": false,
       ],
       
       ["textField": false,
        "titleLabel": true,
        "collectionView": true,
        "animationView": false,
        "descriptionLabel": false,
        "nextBtn": false,
        "stackView": false,
        "pickerView": false,
        "dayLabelStackView": false,
       ],
       
       ["textField": false,
        "titleLabel": true,
        "collectionView": false,
        "animationView": false,
        "descriptionLabel": false,
        "nextBtn": true,
        "stackView": true,
        "pickerView": false,
        "dayLabelStackView": false,
       ],
       
       ["textField": false,
        "titleLabel": true,
        "collectionView": false,
        "animationView": false,
        "descriptionLabel": false,
        "nextBtn": true,
        "stackView": false,
        "pickerView": true,
        "dayLabelStackView": true,
       ]
   ]
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setVariable()
        setupAllViewsAndConstraints()
        setupFirstLoadUI()
        observeKeyboard()
    }
    
    
    //MARK: - Functions
    fileprivate func setupAllViewsAndConstraints() {
        nextButton.layer.cornerRadius = 20
        backgroundView.layer.cornerRadius = 20
        hideKeyboardWhenTappedAround()
        // Permenant Views //
        
        view.addSubview(backgroundView)
        view.addSubview(nextButton)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints     = false
        
        backgroundView.backgroundColor = .white
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = .blue
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bgViewTopConstraint     = backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        bgViewStretchConstraint = backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)

        bgViewTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nextButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
        
        
        // : - First View //
        
        // Label
        titleLabel.numberOfLines = 0
        titleLabel.text = "What is your name?"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5

        
        // Textfield
        textField.placeholder = "Name"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let placeholder = NSMutableAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let placeholderBounds = placeholder.boundingRect(with: CGSize(width: textField.frame.width, height: textField.frame.height), options: .usesLineFragmentOrigin, context: nil)
        textField.delegate = self

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding.left, height: placeholderBounds.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.attributedPlaceholder = placeholder
        textField.autocorrectionType = .no
        
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints  = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalTo: nextButton.heightAnchor, multiplier: 2),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 96),
            textField.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.83),
            textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
        
        // : - Second View //

        
        // Description Label
        descriptionLabel.numberOfLines  = 0
        descriptionLabel.text           = "We will work together to make you the best version of yourself?"
        descriptionLabel.textAlignment  = .center
        descriptionLabel.font           = UIFont.systemFont(ofSize: 20, weight: .semibold)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5

        
        //Animation View
        animationView                = .init(name: "77000-man-graph")
        animationView.frame          = backgroundView.frame
        animationView.contentMode    = .scaleToFill
        animationView.loopMode       = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
        
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(animationView)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints    = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 64),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -16),
            
            animationView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            animationView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            animationView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            animationView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            animationView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.6),
            animationView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        // : - Third View //

        // Collection View
        backgroundView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.translatesAutoresizingMaskIntoConstraints          = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: GetStartedCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GetStartedCollectionViewCell.identifier)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
        
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16)
        ])
        
        
        // : - Fourth View //

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        for index in 1...6 {
          let label = UILabel()
          label.text = "\(index) - \(goalsText[index - 1])"
          label.numberOfLines = 0
          label.backgroundColor = .white
          label.adjustsFontSizeToFitWidth = true
          label.minimumScaleFactor = 0.5
 
          stackView.addArrangedSubview(label)
        }
            backgroundView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
        
            NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:  titleLabel.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.6)
        ])
        
        // : - Fifth View //
            
        dayNumberLabel.text = "1"
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
    
        pickerView.delegate   = self
        pickerView.dataSource = self

        dayLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabelStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dayLabelStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: dayLabelStackView.bottomAnchor, constant: 16),
            pickerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            pickerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32)
        ])
            
            
        
    }
    
    
    
    fileprivate func setupFirstLoadUI() {
        let currentPageInfo        = isThisViewHidden[currentPage - 1]
        setButtonUI(myButton: nextButton, isEnable: !currentPageInfo["nextBtn"]!)
        textField.isHidden         = !currentPageInfo["textField"]!
        titleLabel.isHidden        = !currentPageInfo["titleLabel"]!
        collectionView.isHidden    = !currentPageInfo["collectionView"]!
        animationView.isHidden     = !currentPageInfo["animationView"]!
        descriptionLabel.isHidden  = !currentPageInfo["descriptionLabel"]!
        stackView.isHidden         = !currentPageInfo["stackView"]!
        dayLabelStackView.isHidden = !currentPageInfo["dayLabelStackView"]!
        pickerView.isHidden        = !currentPageInfo["pickerView"]!
    }
    
    fileprivate func hideOrShowAnimation(myView: UIView, hidden: Bool) {
        /* All views added top of each other. With the help of this functions,
        / we can set which one should be visible each time to create a single viewcontroller,
        that looks like multiple viewcontroller.  */
        if hidden == true {
            UIView.animate(withDuration: 1, animations: {
                myView.alpha = 0
            }) { (finished) in
                myView.isHidden = finished
            }
        } else {
            myView.alpha = 0
            myView.isHidden = false
            UIView.animate(withDuration: 1) {
                myView.alpha = 1
            }
        }
    }
    
    fileprivate func fadeOutBackgroundColor(fadeOut: Bool) {
        /* Makes next button's background fade out by decrasing alpha value depanding on if its
         clickable or not. */
        if fadeOut == true {
            UIView.transition(with: nextButton, duration: 0.5, options: .curveEaseInOut, animations: {
                self.nextButton.backgroundColor = .systemBlue
                self.nextButton.alpha = 0.5
            })
        } else {
            UIView.transition(with: nextButton, duration: 0.5, options: .curveEaseInOut, animations: {
                self.nextButton.backgroundColor = .systemBlue
                self.nextButton.alpha = 1
            })
        }
    }
    
    fileprivate func setVariable() {
        ages = ["15-24", "25-34" , "35-44", "45-54", "55+", "Prefer not to say"]
    }
    
    fileprivate func setButtonUI(myButton: UIButton, isEnable: Bool) {
        if isEnable == true {
                 nextButton.isUserInteractionEnabled = false
                 fadeOutBackgroundColor(fadeOut: true)
        } else {
              nextButton.isUserInteractionEnabled = true
            fadeOutBackgroundColor(fadeOut: false)
        }
    }
    
    fileprivate func saveUserValues(userName: String, userAge: String) {
        let saveUser  = User(context: self.context)
        saveUser.name = userName
        saveUser.age  = userAge
        do {
            try self.context.save()
        } catch {
            print("error! user couldnt be saved!")
        }
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        bgViewTopConstraint?.isActive = false
        bgViewStretchConstraint?.isActive = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bgViewStretchConstraint?.isActive = false
        bgViewTopConstraint?.isActive = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            }
    }

    
    
    
    
    @objc func nextButtonClicked(_ sender: Any) {
        let textFieldInputName : String = "\(String(describing: textField.text))."

        titleTexts = ["What is your name?", "Hi \(textFieldInputName),", "What is your age?", "Here are the 6 rules that you must follow!", "From which day do you want to start?"]

        let currentPageInfo = isThisViewHidden[currentPage]
        hideOrShowAnimation(myView: textField,         hidden: !currentPageInfo["textField"]!)
        hideOrShowAnimation(myView: titleLabel,        hidden: !currentPageInfo["titleLabel"]!)
        hideOrShowAnimation(myView: collectionView,    hidden: !currentPageInfo["collectionView"]!)
        hideOrShowAnimation(myView: animationView,     hidden: !currentPageInfo["animationView"]!)
        hideOrShowAnimation(myView: descriptionLabel,  hidden: !currentPageInfo["descriptionLabel"]!)
        hideOrShowAnimation(myView: stackView,         hidden: !currentPageInfo["stackView"]!)
        hideOrShowAnimation(myView: dayLabelStackView, hidden: !currentPageInfo["dayLabelStackView"]!)
        hideOrShowAnimation(myView: pickerView,        hidden: !currentPageInfo["pickerView"]!)
        
        setButtonUI(myButton: nextButton,            isEnable: !currentPageInfo["nextBtn"]!)
        
        UIView.transition(with: titleLabel, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.titleLabel.text = self.titleTexts[self.currentPage]
            self.titleLabel.alpha = 1
        }, completion: nil)

        currentPage += 1
        if currentPage == isThisViewHidden.count {
            currentPage = 0
            print("username is : \(userName)")
            saveUserValues(userName: userName, userAge: userAge)
        }
        print(currentPage)
    }
    
  }

 // MARK:  -  CollectionView
extension GetStartedViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GetStartedCollectionViewCell.identifier, for: indexPath) as! GetStartedCollectionViewCell
        cell.cellAgeLabel.text = ages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = collectionView.frame.width
        let height = ((collectionView.frame.height)  - 50) / 6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
                   let prevSelectedCell = collectionView.cellForItem(at: selectedIndexPath) as! GetStartedCollectionViewCell
                prevSelectedCell.cellBackgroundView.backgroundColor = .systemGray6
                prevSelectedCell.cellAgeLabel.textColor = .black
                prevSelectedCell.cellBackgroundView.layer.borderWidth = 0
               }
               selectedIndexPath = indexPath
               let selectedCell = collectionView.cellForItem(at: indexPath) as! GetStartedCollectionViewCell
        
        UIView.transition(with: selectedCell.cellBackgroundView, duration: 0.5, options: .curveEaseInOut, animations: {
            selectedCell.cellBackgroundView.backgroundColor = UIColor(named: "selectedBlue")
            selectedCell.cellBackgroundView.layer.borderColor = UIColor(named: "blueBorder")?.cgColor
            selectedCell.cellBackgroundView.layer.borderWidth = 2.5
            self.userAge = selectedCell.cellAgeLabel.text ?? ""
            })
         fadeOutBackgroundColor(fadeOut: false)
         nextButton.isUserInteractionEnabled = true
    }
}

// MARK:  - Other Extensions
extension GetStartedViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(GetStartedViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension GetStartedViewController : UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            if !text.isEmpty{
                nextButton.isUserInteractionEnabled = true
                print(text)
                userName = text
                fadeOutBackgroundColor(fadeOut: false)
            } else {
                nextButton.isUserInteractionEnabled = false
                fadeOutBackgroundColor(fadeOut: true)
            }
            return true
        }
}

    extension GetStartedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            dayNumberLabel.text = "\(dayCounter)"
            dayLabel.text = dayCounter == 1 ? "day" : "days"
        }
        
    }
