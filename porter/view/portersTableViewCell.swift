//
//  portersTableViewCell.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 8/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class portersTableViewCell: UITableViewCell {
	@IBOutlet weak var origen: UILabel!
	@IBOutlet weak var destino: UILabel!
	@IBOutlet weak var fecha: UILabel!
	@IBOutlet weak var tipo: UILabel!
	@IBOutlet weak var precio:UILabel!
	@IBOutlet weak var ico: UIImageView!
	@IBOutlet weak var status: UILabel!
	@IBOutlet weak var border: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBOutlet weak var tipoServicio: UILabel!
}
