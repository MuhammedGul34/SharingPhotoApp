//
//  ViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Muhammed Gül on 23.10.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextfield.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextfield.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesajı(titleInput: "hata!", messageInput: error?.localizedDescription ?? "Hata Aldınız, lütfen tekrar deneyiniz.")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            self.hataMesajı(titleInput: "Hata!", messageInput: "E-mail ve Parola giriniz")
        }
    }
    
    @IBAction func kayitOlTilklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextfield.text != ""{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextfield.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesajı(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız, Tekrar deneyin.")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            //kayıt olma işlemi
        } else {
            hataMesajı(titleInput: "Hata!", messageInput: "E-mail ve Parola giriniz.")
        }
    }
    
    func hataMesajı(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

