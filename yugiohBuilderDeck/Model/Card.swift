//
//  Card.swift
//  yugiohBuilderDeck
//
//  Created by Andres Mendieta on 10/13/21.
//

import Foundation
import UIKit


struct Card: Codable {
    let name: String
    let id: Int
    let card_images: [CardImage]
    
}

struct CardImage: Codable {
    let image_url: String
    let image_url_small: String
}

extension Card: CustomStringConvertible {
    var description: String {
        return "\nname: \(name)\nid: \(id)\n"
    }
}
