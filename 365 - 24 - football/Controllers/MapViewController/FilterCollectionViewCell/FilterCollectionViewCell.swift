//
//  FilterCollectionViewCell.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/9/23.
//

import Foundation
import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    
    // MARK: - Public funcs
    func configure(text: String) {
        filterLabel.text = text
    }
}
