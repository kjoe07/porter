//
//  chatsCell.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 24/8/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
protocol avatarCell{
	var avatar: UIImageView! { get set }
}
protocol imagenCell {
	var imagen: UIImageView! { get set }
}
class outgoingText: UITableViewCell,avatarCell {
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var name: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	override func prepareForReuse() {
		contentView.layer.sublayers?.removeLast()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
		self.avatar.clipsToBounds = true
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}
class incomingText: UITableViewCell,avatarCell {
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var name: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	override func prepareForReuse() {
		//contentView.layer.sublayers?.removeAll()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
		self.avatar.clipsToBounds = true
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
}
class incomingImage: UITableViewCell,avatarCell, imagenCell  {
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var imagen: UIImageView!
	@IBOutlet weak var name: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
		self.avatar.clipsToBounds = true
	}
	override func prepareForReuse() {
		contentView.layer.sublayers?.removeLast()
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}
class outGoingImage: UITableViewCell,avatarCell, imagenCell  {
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var imagen: UIImageView!
	@IBOutlet weak var name: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
		self.avatar.clipsToBounds = true
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}
