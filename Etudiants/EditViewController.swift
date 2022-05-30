//
//  EditViewController.swift
//  tp-etudiants
//
//  Created by Lahcen Belouaddane on 5/29/22.
//  Copyright © 2022 Lahcen Belouaddane. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var etudiant: NSManagedObject?

    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var dateNaissancePicker: UIDatePicker!
    @IBOutlet weak var photo: UIImageView!
    
    
    @IBAction func modifierEtudiant(_ sender: Any) {
        etudiant?.setValue(nomField.text, forKey: "nom")
        etudiant?.setValue(prenomField.text, forKey: "prenom")
        etudiant?.setValue(dateNaissancePicker.date, forKey: "dateNaissance")
        etudiant?.setValue(photo.image?.pngData(), forKey: "photo")
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomField.text = etudiant?.value(forKey:"nom") as! String
        prenomField.text = etudiant?.value(forKey: "prenom") as! String
        dateNaissancePicker.date = etudiant?.value(forKey: "dateNaissance") as! Date
        photo.image = UIImage(data: etudiant?.value(forKey: "photo") as! Data)
    }
}
