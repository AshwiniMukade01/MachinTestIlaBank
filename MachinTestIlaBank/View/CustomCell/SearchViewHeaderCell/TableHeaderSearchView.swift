//
//  TableHeaderSearchView.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import UIKit

class TableHeaderSearchView: UITableViewHeaderFooterView {
    
    //MARK: - @IBOutlet & Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearchActive: Bool = false {
        didSet {
            searchBar.searchTextField.text = isSearchActive ? searchBar.searchTextField.text : ""
        }
    }
    
    var searchText = "" {
        didSet {
            searchBar.searchTextField.placeholder = "search \(searchText) movies"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.searchTextField.backgroundColor = .clear
    }
}
