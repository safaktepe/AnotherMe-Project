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
    
    
    func createFileName() -> String {
        let fileName   = NSUUID().uuidString
        return fileName
    }
    
    func createImageReferance() -> StorageReference {
        let fileName = createFileName()
        let ref  = Storage.storage().reference().child("profile_photos").child("\(fileName).jpg")
        return ref
    }
    
    func uploadImage() {
        //Storage
        let imageRef = createImageReferance()
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
        
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot  in
            print("snapshot value = \(snapshot.value)")
            
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let profileImageUrl = dictionary["image_url"] as? String else { return }
            guard let url  = URL(string: profileImageUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(nil, error)
                guard let data = data else { return }
                DispatchQueue.main.async {
                completion(data, nil)
                }
                
                }.resume()
        }
    }
    }


/*
 Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot  in
   //  print(snapshot.value ?? "")
     print("snapshot value = \(snapshot.value)")
     guard let dictionary = snapshot.value as? [String:Any] else { return }
     guard let profileImageUrl = dictionary["image_url"] as? String else { return }
     guard let url  = URL(string: profileImageUrl) else { return }
     
     URLSession.shared.dataTask(with: url) { data, response, error in
         if error != nil {
             print("Failed to get your profile photo!")
             return
         }
         guard let data = data else { return }
         self.dataURL = data
         }.resume()
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
         print("")
     }
 }
 return dataURL
}
 */
