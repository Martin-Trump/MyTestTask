//
//  SearchResult.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 14.12.2021.
//

import Foundation

struct ITunesSearchResult<Element: Codable>: Codable {
    let resultCount: Int
    let results: [Element]
}
