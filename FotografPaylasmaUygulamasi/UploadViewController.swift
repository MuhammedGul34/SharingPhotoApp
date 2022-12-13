//
//  UploadViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Muhammed Gül on 23.10.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer    )
    }
    
    @objc func gorselSec(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func uploadButtonTiklandi(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            
            imageReference.putData(data) { storagemetadata, error in
                if error != nil {
                    self.hataMesajiGöster(title: "Hata!", message: error?.localizedDescription ?? "Hata aldınız,tekrar deneyin")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            if let imageUrl = imageUrl {
                                let fireStoreDatabase = Firestore.firestore()
                                
                                let fireStorePost = ["görselurl": imageUrl, "yorum": self.yorumTextfield.text!, "e-mail": Auth.auth().currentUser!.email, "tarih": FieldValue.serverTimestamp() ] as [String: Any]
                                
                                fireStoreDatabase.collection("Post").addDocument(data: fireStorePost) { error in
                                    if error != nil {
                                        self.hataMesajiGöster(title: "Hata!", message: error?.localizedDescription ?? "Hata aldınız, lütfen tekrar deneyiniz")
                                    }else {
                                        
                                        self.imageView.image = UIImage(named: "image")
                                        self.yorumTextfield.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                } }
                        }
                    }
                }
            }
        }
    }
    func hataMesajiGöster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
