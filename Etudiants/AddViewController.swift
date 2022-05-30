//
//  AddViewController.swift
//  tp-etudiants
//
//  Created by Lahcen Belouaddane on 5/29/22.
//  Copyright © 2022 Lahcen Belouaddane. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var dateNaissancePicker: UIDatePicker!
    @IBOutlet weak var photo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ajouterEtudiant(_ sender: Any) {
        if nomField.text!.isEmpty || prenomField.text!.isEmpty {
            let alert = UIAlertController(title: "Erreur", message: "SVP Completé les informations", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK...", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Etudiant", in: managedContext!)!
        
        let etudiant = NSManagedObject(entity: entity, insertInto: managedContext)
    
        etudiant.setValue(nomField.text, forKey: "nom")
        etudiant.setValue(prenomField.text, forKey: "prenom")
        etudiant.setValue(dateNaissancePicker.date, forKey: "dateNaissance")
        etudiant.setValue(photo.image?.pngData(), forKey: "photo")
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Error \(error), \(error.userInfo)")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            photo?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate  = self
        picker.sourceType = .photoLibrary
        present(picker,animated: true)
    }
}
