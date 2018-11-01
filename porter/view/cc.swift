//
//  cc.swift
//  porter
//
//  Created by yoel jimenez del valle on 10/31/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
class Ccview
: UIView{
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("cc", owner: self, options: nil)
        contentView.frame = self.bounds
        //contentView.fixInView(self)
    }
}
