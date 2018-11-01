//
//  userTableViewCell.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 7/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class userTableViewCell: UITableViewCell {
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
