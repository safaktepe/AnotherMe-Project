//
//  MainViewModel.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 17.12.2022.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase
import UIKit


class MainViewModel {
    
    var uploadData  : Data?
    var dataURL     : Data?
    var imageDown   : UIImage?
    var onComplete  : ( () -> Void )?
    
    func setData(uploadData: Data) {
        self.uploadData = uploadData
    }
    
   
    
    func uploadImage(userId : String) {
        let imageRef = Storage.storage().reference().child("profile_photos").child("\(userId).jpg")
        //Storage
        guard let uploadData = uploadData else { return }
        imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if  error != nil {
                print(error?.localizedDescription ?? "Error!")
            } else {
                imageRef.downloadURL { url, error in
                    if error == nil {
                        guard let imageUrl = url?.absoluteString else { return }
                        print(imageUrl)
                        
                        // Database
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        let usernamePhotos = ["image_url" : imageUrl]
                        let values = [uid : usernamePhotos]
                        Database.database().reference().child("users").updateChildValues(values) { err, ref in
                            if let err = err {
                                print(err.localizedDescription)
                                return
                            }
                            else {
                                print("Saved succesfully!")
                            }
                        }
                    } else {
                        print(error?.localizedDescription ?? "Error!")
                    }
                }   
            }
        }
    }
    
    func getProfileImage(uid: String, completion: @escaping (Data? , Error?) -> (Void)) {
            print("now inside get profile func")
        
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot  in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let profileImageUrl = dictionary["image_url"] as? String else { return }
            guard let url  = URL(string: profileImageUrl) else { return }
            print("url returned, about to get in urlsession.")
                
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(nil, error)
                guard let data = data else { return }
                
            print("url session end, now dispatchque completion.")
                
                DispatchQueue.main.async {
                completion(data, nil)
                }
                
                }.resume()
        }
    }
}
