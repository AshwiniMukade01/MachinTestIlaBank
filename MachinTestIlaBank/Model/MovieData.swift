//
//  MainData.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import Foundation

struct MovieData : Codable {
    let movies: [CarouselData]?
}

struct CarouselData : Codable {
    let name : String?
    let image : String?
    var movie_names : [MovieList]?
}

struct MovieList : Codable {
    let name : String?
    let image : String?
}
