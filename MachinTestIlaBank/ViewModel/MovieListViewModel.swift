//
//  MovieListViewModel.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import Foundation

final class MovieListViewModel {
    
    //MARK: - Variables
    
    private var arrCarouselList: [CarouselData]?
    private var arrList: [CarouselData]?
    private var currentCarouselIndex = 0
    var isSearchActive = false
    
    //Callback to reloadData
    var reloadData: ((Bool) -> Void)?
    
    //Table sections
    private enum Sections: Int, CaseIterable {
        case carousel
        case list
    }
    
    init() {
        arrCarouselList = []
        arrList = []
        
        //Get carousel array from JSONHelper
        let objHelper = JSONHelper()
        if let movieData = objHelper.decoadJSONFromFile() {
            let arrMovieData = movieData.movies ?? []
            arrCarouselList = arrMovieData
            arrList = arrCarouselList
        }
    }
}

//MARK: - Get/Set Data Handler

extension MovieListViewModel {
    
    func getCarouselList() -> [CarouselData] {
        return arrList ?? []
    }
    
    //Get array of selected carousel
    func getSelectedMovieList() -> [MovieList] {
        return arrList?[safe: currentCarouselIndex]?.movie_names ?? []
    }
    
    func getSelectedCarousel() -> String {
        let dic = arrCarouselList?[safe: currentCarouselIndex]
        return dic?.name ?? ""
    }
    
    func getSectionCarousel() -> Int {
        return Sections.carousel.rawValue
    }
    
    func getSectionList() -> Int {
        return Sections.list.rawValue
    }
    
    //MARK: - Update Data
    
    func updateIsSearchActive(_ isSearchActive: Bool) {
        self.isSearchActive = isSearchActive
        reloadData?(true)
    }
    
    func updateSelectedIndex(_ currentCarouselIndex: Int) {
        self.currentCarouselIndex = currentCarouselIndex
        reloadData?(false)
    }
    
    //MARK: - SearchMovieList Handler
    
    func searchTxt(txt : String) {
        if(txt.count > 0) {
            if let arr: [MovieList] = arrCarouselList?[safe: currentCarouselIndex]?.movie_names {
                let movieList = arr.filter({$0.name!.localizedCaseInsensitiveContains(txt)})
                arrList?[safe: currentCarouselIndex]?.movie_names = movieList
            }
        } else {
            arrList = arrCarouselList
        }
        reloadData?(true)
    }
}

//MARK: - UITableViewDelegate Handler

extension MovieListViewModel {
    
    func numberOfSections() -> Int {
        return Sections.allCases.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == Sections.carousel.rawValue {
            //Hide carousel section if search is active
            return isSearchActive ? 0 : 1
        } else {
            return getSelectedMovieList().count == 0 ? 1 : getSelectedMovieList().count
        }
    }
}
