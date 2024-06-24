//
//  MovieListVC.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import UIKit

class MovieListVC: UIViewController {
    
    //MARK: - @IBOutlet & Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = MovieListViewModel()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOnce()
    }
    
    //MARK: - Custom Function
    
    private func loadOnce() {
        viewModel.reloadData = {[weak self] animates in
            self?.reloadTable(animate: animates)
        }
        setupTable()
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: CellIdentifire.TableCellCarousel, bundle: nil), forCellReuseIdentifier: CellIdentifire.TableCellCarousel)
        tableView.register(UINib(nibName: CellIdentifire.TableCellMovieList, bundle: nil), forCellReuseIdentifier: CellIdentifire.TableCellMovieList)
        tableView.register(UINib(nibName: CellIdentifire.TableHeaderSearchView, bundle: nil), forHeaderFooterViewReuseIdentifier: CellIdentifire.TableHeaderSearchView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Remove section header blank space
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        reloadTable()
    }
    
    private func reloadTable(animate: Bool = false) {
        if animate {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.tableView.reloadData()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


//MARK: - UITableViewDataSource

extension MovieListVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let sectionCarousel = viewModel.getSectionCarousel()
        
        //Setup carousel section cell
        if section == sectionCarousel {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.TableCellCarousel, for: indexPath) as! TableCellCarousel
            cell.arrCarouselList = viewModel.getCarouselList()
            cell.selectedCarouselHandler = { [weak self] index in
                self?.viewModel.updateSelectedIndex(index)
            }
            return cell
        } else {
            let arr = viewModel.getSelectedMovieList()
            let count = arr.count
            
            //Setup no data cell if arr count is 0
            if count == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.noDataCell) {
                    cell.textLabel?.textAlignment = .center
                    let strNoData = "No Data Found for \(viewModel.getSelectedCarousel())"
                    cell.textLabel?.text = strNoData
                    return cell
                }
            }
            
            //Setup Movie list section cell
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.TableCellMovieList, for: indexPath) as! TableCellMovieList
            let arrList = viewModel.getSelectedMovieList()
            let index = indexPath.row
            cell.movieData = arrList[safe: index]
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension MovieListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == viewModel.getSectionList() {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellIdentifire.TableHeaderSearchView) as! TableHeaderSearchView
            header.searchBar.delegate = self
            header.isSearchActive = viewModel.isSearchActive
            header.searchText = viewModel.getSelectedCarousel()
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == viewModel.getSectionList() {
            return 60
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == viewModel.getSectionCarousel() {
            return UIScreen.main.bounds.size.height * 0.3
        }
        return UITableView.automaticDimension
    }
}



// MARK: - UISearchBarDelegate -

extension MovieListVC : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.updateIsSearchActive(true)
        //show cancel button when editing started
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            searchBar.showsCancelButton = true
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Do not allow space as first charater
        if text == " " && range.location == 0 {
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchMovieListText: String) {
        viewModel.searchTxt(txt: searchMovieListText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchTxt(txt: "")
        viewModel.updateIsSearchActive(false)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //hide cancel button when editing ended
        if !viewModel.isSearchActive {
            searchBar.showsCancelButton = false
        }
    }
}

