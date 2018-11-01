//
//  cardsTableViewCell.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 10/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class cardsTableViewCell: UITableViewCell {
	@IBOutlet weak var visaNumber: UILabel!
	@IBOutlet weak var visaExp: UILabel!
	@IBOutlet weak var visaView: UIView!
	@IBOutlet weak var visaImagen: UIImageView!
	@IBOutlet weak var selectButton:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
