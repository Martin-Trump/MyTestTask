//
//  SearchPresenter.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 14.12.2021.
//

import Foundation
import UIKit

protocol SearchViewInput: AnyObject {
    
    var searchResults: [ITunesApp] {get set}
    
    func showError(error: Error)
    func showNoResults()
    func hideNoResults()
}

protocol SearchViewOutput: AnyObject {
    func viewDidSearch(with query: String)
    func viewDidSelect(app: ITunesApp)
}

class SearchPresenter {
    
    weak var viewInput: (UIViewController & SearchViewInput)?
    private let searchService = SearchService()
    
    private func requestApp(with query: String) {
        self.searchService.getApps(forQuery: query) { [weak self] result in
            guard let self = self else { return }
            result
                .withValue { apps in
                    guard !apps.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchResults = apps
                }
                .withError { (error) in
                    self.viewInput?.showError(error: error)
                }
        }
    }
    
    private func openAppDetails(with app: ITunesApp) {
        let appDetailViewController = AppDetailViewController(app: app)
        viewInput?.navigationController?.pushViewController(appDetailViewController, animated: true)
    }
    
    
}

extension SearchPresenter: SearchViewOutput {
    func viewDidSearch(with query: String) {
        requestApp(with: query)
    }
    
    func viewDidSelect(app: ITunesApp) {
        openAppDetails(with: app)
    }
    
    
}
