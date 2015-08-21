//
//  AnimalsTableViewCell.swift
//  PamperedPets
//
//  Created by Caroline Begbie on 27/07/2015.
//  Copyright © 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class AnimalsTableViewCell: UITableViewCell {

  @IBOutlet var photoView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  
  var animal:Animal? {
    didSet {
      nameLabel.text = animal?.name
      descriptionLabel.text = animal?.description
      if let name = animal?.name {
        photoView.image = UIImage(named: name)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let image = UIImage(named: "DisclosureIndicator")
    self.accessoryView = UIImageView(image: image)
  }
}
