//
//  Creatures.swift
//  Catch 'em All
//
//  Created by Joshua Chang  on 11/30/21.
//

import Foundation

class Creatures {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
    
    var count = 0
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    var creatureArray: [Creature] = []
    
    func getData(completed: @escaping () -> ()) {
        print("We are accessing the url \(urlString)")
        
        // create a url
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a url from \(urlString)")
            return
        }
        
        // create a session
        let session = URLSession.shared
        
        // get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                print("😎 Here is what was returned \(returned)")
                self.creatureArray = self.creatureArray + returned.results
                self.urlString = returned.next ?? ""
                self.count = returned.count
            } catch {
                print("😡 JSON ERROR: thrown when we tried to decode from Returned.self with data")
            }
            completed()
        }
        
        task.resume()
    }
}
