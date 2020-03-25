//
//  NoteTableViewCell.swift
//  Note-Taking App
//
//  Created by fana fili on 3/22/20.
//  Copyright © 2020 fana fili. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowVIEW: UIView!

    @IBOutlet weak var noteNameLabel: UILabel!
    
    @IBOutlet weak var noteDescriptionLabel: UILabel!

    @IBOutlet weak var noteImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowVIEW.layer.shadowColor = UIColor(red:0/255.0,green:0/255.0,blue:0/255.0,alpha: 1.0).cgColor
        shadowVIEW.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowVIEW.layer.shadowRadius = 1.5
        shadowVIEW.layer.shadowOpacity = 0.2
        shadowVIEW.layer.cornerRadius = 2
        noteImageView.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(note: Note){
        self.noteNameLabel.text = note.noteName?.uppercased()
        self.noteDescriptionLabel.text = note.noteDescription
        self.noteImageView.image = UIImage(data: note.noteImage! as Data)
    }
}
