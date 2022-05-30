//
//  ViewController.swift
//  test
//
//  Created by Lahcen Belouaddane on 5/27/22.
//  Copyright © 2022 Lahcen Belouaddane. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate
let managedContext = appDelegate?.persistentContainer.viewContext
let formatter = DateFormatter()

class ViewController: UIViewController {
    var etudiants: [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let attrs = [
          NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        UINavigationBar.appearance().largeTitleTextAttributes = attrs
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func clearDB() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Etudiant")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext?.execute(deleteRequest)

        } catch let error as NSError {
            print("Error \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchEtudiants()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = tableView.indexPathForSelectedRow else { return }
        let etudiant = etudiants[index.row]
        
        if segue.identifier == "edit-segue", let editView = segue.destination as? EditViewController {
            editView.etudiant = etudiant
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
}

extension ViewController: UITableViewDataSource {
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchEtudiants()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: EtudiantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "etudiant-cell", for: indexPath) as! EtudiantTableViewCell
        let etudiant = etudiants[indexPath.row]
            
        cell.nomLabel.text = etudiant.value(forKey: "nom")! as? String
        cell.prenomLabel.text = etudiant.value(forKey: "prenom") as? String
        cell.dateNaissanceLabel.text = formatter.string(from: etudiant.value(forKey: "dateNaissance") as! Date)
        cell.photo.image = UIImage(data: etudiant.value(forKey: "photo") as! Data)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let etudiant = etudiants[indexPath.row]
            managedContext?.delete(etudiant)
            
            self.etudiants.remove(at: indexPath.row)
            do {
                try  managedContext?.save()
                  
            
              } catch {
                  let saveError = error as NSError
                  print(saveError)
              }
            
            self.fetchEtudiants()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return etudiants.count
    }
}

