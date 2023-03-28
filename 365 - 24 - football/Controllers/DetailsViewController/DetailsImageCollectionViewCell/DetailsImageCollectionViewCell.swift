//
//  DetailsImageCollectionViewCell.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/20/23.
//

import UIKit

class DetailsImageCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureImage(URLString: String) {
        if let url = URL(string: URLString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.detailImageView.image = image
                        }
                    }
                }
            }
        }
    }

}
