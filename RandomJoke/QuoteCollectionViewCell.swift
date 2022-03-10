//
//  QuoteCollectionViewCell.swift
//  RandomJoke
//
//  Created by Павел Богданов on 10.03.2022.
//

import UIKit

class QuoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var quoteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ quote: String) {
        quoteLabel.text = quote
        layer.masksToBounds = true
        layer.cornerRadius = 15
    }

}
