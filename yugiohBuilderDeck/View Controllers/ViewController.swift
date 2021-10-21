//
//  ViewController.swift
//  yugiohBuilderDeck
//
//  Created by Andres Mendieta on 10/13/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    let queryService = QueryService()
    let loader = ImageLoader()
    var selectedCard: Card?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables And Properties
    
    var cards: [Card] = []
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    // MARK: - Internal Methods
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
//                self?.cardImage.image = UIImage(data: data)
            }
        }
    }
}

// MARK: - Search Bar Delegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] cards, errorMessage in
            if cards != nil {
                self?.cards = cards ?? []
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: \(errorMessage)")
            }
        }
    }
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cards[indexPath.row].name
        content.image = UIImage(named: "backOfCard")
        
        if let stringUrl = cards[indexPath.row].card_images.first?.image_url_small,
           let url = URL(string: stringUrl) {
            downloadImage(from: url) { image in
                if image != nil {
                    content.image = image
                    cell.contentConfiguration = content
                }
            }
        }
        
        
//        if let imageUrl = URL(string: cards[indexPath.row].card_images[0].image_url_small) {
//            let token = loader.loadImage(imageUrl) { result in
//                do {
//                    let image = try result.get()
//
//                    DispatchQueue.main.async {
//                        content.image = image
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
        
        

//        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
//        var imageData: Data
//        let imageUrlString = cards[indexPath.row].card_images[0].image_url
//        if let imageUrl = URL(string: imageUrlString) {
//            imageData = Data(contentsOf: imageUrl)
//        }
        
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
        performSegue(withIdentifier: "CardImageViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardImageViewController" {
            let cardImageViewController = segue.destination as? CardImageViewController
            cardImageViewController?.card = selectedCard
        }
    }
}


// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}
