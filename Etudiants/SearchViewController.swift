//
//  SearchViewController.swift
//  tp-etudiants
//
//  Created by Lahcen Belouaddane on 5/29/22.
//  Copyright © 2022 Lahcen Belouaddane. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    var etudiants: [NSManagedObject] = []
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func search(_ sender: Any) {
        if searchField.text!.isEmpty {
            let alert = UIAlertController(title: "Erreur", message: "SVP veuillez remplir le champ de recherche", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "D'accord", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Etudiant")
        let pred1 = NSPredicate(format: "nom CONTAINS[c] %@", searchField.text as! CVarArg)
        let pred2 = NSPredicate(format: "prenom CONTAINS[c] %@", searchField.text as! CVarArg)
        request.predicate = NSCompoundPredicate.init(type: .or, subpredicates: [pred1, pred2])
        
        do {
            let result = try managedContext?.fetch(request)
            
            if !result!.isEmpty {
                etudiants = result!
                tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Pas de resulat", message: "Pas de resulat", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK...", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func fetchEtudiants() -> Void {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Etudiant")

        do {
            etudiants = try managedContext?.fetch(fetchRequest) as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Error \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = tableView.indexPathForSelectedRow else { return }
        let etudiant = etudiants[index.row]
        
        if segue.identifier == "edit-segue2", let editView = segue.destination as? EditViewController {
            editView.etudiant = etudiant
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: EtudiantTableViewCell2 = tableView.dequeueReusableCell(withIdentifier: "etudiant-cell2", for: indexPath) as! EtudiantTableViewCell2
        let etudiant = etudiants[indexPath.row]
            
        cell.nomLabel.text = etudiant.value(forKey: "nom")! as? String
        cell.prenomLabel.text = etudiant.value(forKey: "prenom") as? String
        cell.dateNaissanceLabel.text = formatter.string(from: etudiant.value(forKey: "dateNaissance") as! Date)
        cell.photo.image = UIImage(data: etudiant.value(forKey: "photo") as! Data)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return etudiants.count
    }
}
