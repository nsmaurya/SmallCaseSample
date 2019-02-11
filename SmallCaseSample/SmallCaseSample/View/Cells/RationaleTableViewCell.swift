//
//  RationaleTableViewCell.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import UIKit

class RationaleTableViewCell: UITableViewCell {

    @IBOutlet weak var rationaleLabel: UILabel!
    @IBOutlet weak var rationaleValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(rationaleValue: String?) {
        if rationaleValue != nil {
            self.rationaleValueLabel.text = rationaleValue
            self.rationaleLabel.isHidden = false
            self.rationaleValueLabel.isHidden = false
        } else {
            self.rationaleLabel.isHidden = true
            self.rationaleValueLabel.isHidden = true
        }
    }
}
