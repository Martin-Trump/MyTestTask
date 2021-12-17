//
//  SearchBuilder.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 14.12.2021.
//

import Foundation
import UIKit

class SearchBuilder {
    static func build() -> (UIViewController & SearchViewInput) {
        let presenter = SearchPresenter()
        let viewController = SearchController(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
        
    }
}
