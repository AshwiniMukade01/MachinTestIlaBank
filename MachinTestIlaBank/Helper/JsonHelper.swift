//
//  JSONHelper.swift
//  MachineTestIlaBank
//
//  Created by Ashwini Mukade on 24/06/24.
//

import UIKit

struct JSONHelper {
    
    func decoadJSONFromFile() -> (MovieData?) {
        guard let url = Bundle.main.url(forResource: "MovieFile", withExtension: "json") else { return nil }
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        if let mainData = decodeData(data: data) {
            return mainData
        }
        return nil
    }
    
    private func decodeData( data: Data) -> MovieData? {
        guard let jsonData = try? JSONDecoder().decode(MovieData.self, from: data) else { return nil }
        return jsonData
    }
}
