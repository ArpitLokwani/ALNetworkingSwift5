//
//  CustomCell.swift
//  ALNetworking
//
//  Created by Arpit Lokwani on 29/04/20.
//  Copyright © 2020 Arpit Lokwani. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var descriptionLabele: UILabel!
    @IBOutlet weak var imageSection: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
