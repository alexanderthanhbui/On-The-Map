//
//  CustomTableViewCell.swift
//  On The Map
//
//  Created by Hayne Park on 11/10/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var customImage: UIImageView!
    @IBOutlet weak var customLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
