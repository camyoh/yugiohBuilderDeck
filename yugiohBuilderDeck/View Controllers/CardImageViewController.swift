//
//  CardImageViewController.swift
//  yugiohBuilderDeck
//
//  Created by Andres Mendieta on 10/14/21.
//

import UIKit

class CardImageViewController: UIViewController {
    @IBOutlet weak var cardImage: UIImageView!
    
    var card: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let stringUrl = card?.card_images[0].image_url {
//            let url = URL(string: stringUrl)!
//            downloadImage(from: url)
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let stringUrl = card?.card_images[0].image_url,
              let url = URL(string: stringUrl) else {
                  return
              }
        downloadImage(from: url)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.cardImage.image = UIImage(data: data)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
