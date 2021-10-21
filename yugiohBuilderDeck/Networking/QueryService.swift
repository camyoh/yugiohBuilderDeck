//
//  QueryService.swift
//  yugiohBuilderDeck
//
//  Created by Andres Mendieta on 10/13/21.
//

import Foundation

class QueryService {
    
    // MARK: - Constants
    
    let defaultSession = URLSession(configuration: .default)
    
    // MARK: - Variables And Properties
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
//    var cards: [Card] = []
    var decoder = JSONDecoder()
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Card]?, String) -> Void
    
    // MARK: - Internal Methods
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://db.ygoprodeck.com/api/v7/cardinfo.php") {
            urlComponents.query = "fname=\(searchTerm)"
            
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    self?.errorMessage += "DataTask error: \(error.localizedDescription)\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    
                    DispatchQueue.main.async {
                        completion(self?.updateSearchResults(data), self?.errorMessage ?? "")
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    private func updateSearchResults(_ data: Data) -> [Card] {
//        var response: JSONDictionary?
        
//        cards.removeAll()
        
//        do {
//            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
//        } catch let parseError as NSError {
//            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
//            return
//        }
//
//        guard let array = response!["data"] as? [JSONDictionary] else {
//            errorMessage += "Dictionary does not contain results key\n"
//            return
//        }
//        cards = try! JSONDecoder().decode([Card].self, from: JSONSerialization.data(withJSONObject: array))
//
        do {
            return try decoder.decode(DataResponse.self, from: data).data
        } catch {
            return []
        }
    }
    
}


private struct DataResponse: Codable {
    let data: [Card]
}
