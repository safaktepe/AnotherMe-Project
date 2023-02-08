//
//  GetStartedViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 2.02.2023.
//

import UIKit

class GetStartedViewController: UIViewController, UITextFieldDelegate {

    //MARK: - All Views & Variables
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        layout.estimatedItemSize = .zero
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    @IBOutlet weak var backgroundView  : UIView!
    @IBOutlet weak var nextButton      : UIButton!
    let titleLabel         = UILabel()
    let textField          = UITextField()
    let imageView          = UIImageView()
    let descriptionLabel   = UILabel()
    var currentPage        = 1
    let textLabel          = UILabel()
    var selectedIndexPath  : IndexPath?
    var pageControl        : Int = 0
    
    let isThisViewHidden = [
       ["textField": true,
        "label": true,
        "collectionView": false,
        "imageView": false,
        "descriptionLabel": false,
        "nextBtn": false
       ],
       
       ["textField": false,
        "label": true,
        "collectionView": false,
        "imageView": true,
        "descriptionLabel": true,
        "nextBtn": true
       ],
       
       ["textField": false,
        "label": true,
        "collectionView": true,
        "imageView": false,
        "descriptionLabel": false,
        "nextBtn": false
       ]
   ]
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllViewsAndConstraints()
        setupFirstLoadUI()
        textField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: - Functions
    fileprivate func setupAllViewsAndConstraints() {
        nextButton.layer.cornerRadius        = 20
        backgroundView.layer.cornerRadius = 20
        
        // : - First View //
        
        // Label
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "What is your name?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        // Textfield
        textField.placeholder = "Name"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let placeholder = NSMutableAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let placeholderBounds = placeholder.boundingRect(with: CGSize(width: textField.frame.width, height: textField.frame.height), options: .usesLineFragmentOrigin, context: nil)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding.left, height: placeholderBounds.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.attributedPlaceholder = placeholder
        textField.autocorrectionType = .no
        
        backgroundView.addSubview(label)
        backgroundView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 120),
            textField.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.83),
            textField.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.08)
        ])
        
        // : - Second View //

        
        // Description Label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "We will work together to make you the best version of yourself?"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        // ImageView
        imageView.image       = UIImage(named: "article")
        imageView.contentMode = .scaleToFill
        
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(imageView)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints        = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: label.topAnchor, constant: 64),
            descriptionLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.6),
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        // : - Third View //

        // Collection View
        backgroundView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        label.translatesAutoresizingMaskIntoConstraints          = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: GetStartedCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GetStartedCollectionViewCell.identifier)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
        
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16)
        ])
    }
    
    fileprivate func setupFirstLoadUI() {
        let currentPageInfo       = isThisViewHidden[currentPage - 1]
        setButtonUI(myButton: nextButton, isEnable: !currentPageInfo["nextBtn"]!)
        textField.isHidden        = !currentPageInfo["textField"]!
        titleLabel.isHidden       = !currentPageInfo["label"]!
        collectionView.isHidden   = !currentPageInfo["collectionView"]!
        imageView.isHidden        = !currentPageInfo["imageView"]!
        descriptionLabel.isHidden = !currentPageInfo["descriptionLabel"]!
    }
    
    fileprivate func hideOrShowAnimation(myView: UIView, hidden: Bool) {
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
    
    fileprivate func setButtonUI(myButton: UIButton, isEnable: Bool) {
        if isEnable == true {
                 nextButton.isUserInteractionEnabled = false
                 nextButton.backgroundColor = .yellow
        } else {
              nextButton.isUserInteractionEnabled = true
              nextButton.backgroundColor = .systemBlue
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        let currentPageInfo = isThisViewHidden[currentPage]
        hideOrShowAnimation(myView: textField, hidden: !currentPageInfo["textField"]!)
        hideOrShowAnimation(myView: titleLabel, hidden: !currentPageInfo["label"]!)
        hideOrShowAnimation(myView: collectionView, hidden: !currentPageInfo["collectionView"]!)
        hideOrShowAnimation(myView: imageView, hidden: !currentPageInfo["imageView"]!)
        hideOrShowAnimation(myView: descriptionLabel, hidden: !currentPageInfo["descriptionLabel"]!)
        setButtonUI(myButton: nextButton, isEnable: !currentPageInfo["nextBtn"]!)
        currentPage += 1
        if currentPage == isThisViewHidden.count {
            currentPage = 0
        }
    }
    
  }

 // MARK:  -  CollectionView
extension GetStartedViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GetStartedCollectionViewCell.identifier, for: indexPath) as! GetStartedCollectionViewCell
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
               }
               selectedIndexPath = indexPath
               let selectedCell = collectionView.cellForItem(at: indexPath) as! GetStartedCollectionViewCell
        
        UIView.transition(with: selectedCell.cellBackgroundView, duration: 0.5, options: .curveEaseInOut, animations: {
            selectedCell.cellBackgroundView.backgroundColor = .blue
            selectedCell.cellAgeLabel.textColor             = .white
            })
        
        UIView.transition(with: nextButton, duration: 0.7, options: .curveEaseInOut, animations: {
            self.nextButton.backgroundColor = .systemBlue
            
        })
        
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
                UIView.transition(with: nextButton, duration: 0.7, options: .curveEaseInOut, animations: {
                  self.nextButton.backgroundColor = .systemBlue
                })
            } else {
                nextButton.isUserInteractionEnabled = false
                nextButton.alpha = 0.5
            }
            return true
        }
}

