//
//  CollectionCellImage.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import UIKit

class CollectionCellImage: UICollectionViewCell {
    
    //MARK: - @IBOutlet & Variables
    
    @IBOutlet weak var imgView: UIImageView!
    
    var strImage: String?  {
        didSet {
            setupCell()
        }
    }
    
    //MARK: - Custom Function
    
    private func setupCell() {
        let name = strImage ?? ""
        imgView.image = UIImage(named: name)
    }
}
