//
//  EtudiantTableViewCell.swift
//  tp-etudiants
//
//  Created by Lahcen Belouaddane on 5/28/22.
//  Copyright © 2022 Lahcen Belouaddane. All rights reserved.
//

import UIKit

class EtudiantTableViewCell: UITableViewCell {

    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var prenomLabel: UILabel!
    @IBOutlet weak var dateNaissanceLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = photo.frame.size.width / 2
        photo.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
