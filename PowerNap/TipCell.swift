//
//  TipCell.swift
//  PowerNap
//
//  Created by Sandeep Raghunandhan on 3/28/17.
//  Copyright © 2017 Sandeep Raghunandhan. All rights reserved.
//

import UIKit

class TipCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    var tip: Tip! {
        didSet {
            if let descriptionEntry = tip.textDescription {
                descriptionLabel.text = descriptionEntry
            }
            if let sourceEntry = tip.source {
                sourceLabel.text = sourceEntry
            }
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5;
    }
 
}
