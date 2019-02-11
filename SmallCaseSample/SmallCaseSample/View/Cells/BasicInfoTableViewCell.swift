//
//  BasicInfoTableViewCell.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import UIKit

class BasicInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var monthlyReturnValueLabel: UILabel!
    @IBOutlet weak var yearlyReturnValueLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var indexValueLabel: UILabel!
    @IBOutlet weak var monthlyReturnLabel: UILabel!
    @IBOutlet weak var yearlyReturnLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailImageView.layer.cornerRadius = 5.0
    }
    
    func configureCell(indexValue: String?, yearlyReturnValue: String?, monthlyReturnValue: String?) {
        //setting data
        if indexValue != nil {
            self.indexValueLabel.text = indexValue
            self.indexValueLabel.isHidden = false
            self.indexLabel.isHidden = false
        } else {
            self.indexValueLabel.isHidden = true
            self.indexLabel.isHidden = true
        }
        if yearlyReturnValue != nil {
            self.yearlyReturnValueLabel.text = yearlyReturnValue
            self.yearlyReturnValueLabel.isHidden = false
            self.yearlyReturnLabel.isHidden = false
        } else {
            self.yearlyReturnValueLabel.isHidden = true
            self.yearlyReturnLabel.isHidden = true
        }
        if monthlyReturnValue != nil {
            self.monthlyReturnValueLabel.text = monthlyReturnValue
            self.monthlyReturnLabel.isHidden = false
            self.monthlyReturnValueLabel.isHidden = false
        } else {
            self.monthlyReturnLabel.isHidden = true
            self.monthlyReturnValueLabel.isHidden = true
        }
    }
}
