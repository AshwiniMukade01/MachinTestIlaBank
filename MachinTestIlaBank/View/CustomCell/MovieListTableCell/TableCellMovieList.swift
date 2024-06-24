//
//  TableCellMovieList.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import UIKit

class TableCellMovieList: UITableViewCell {
    
    //MARK: - @IBOutlet & Variables
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    
    var movieData: MovieList?  {
        didSet {
            setupCell()
        }
    }
    
    //MARK: - Custom Function
    
    private func setupCell() {
        lblName.text = movieData?.name ?? ""
        
        if let imgName = movieData?.image {
            iconImgView.image = UIImage(named: imgName)
        } else {
            iconImgView.image = nil
        }
    }
}
