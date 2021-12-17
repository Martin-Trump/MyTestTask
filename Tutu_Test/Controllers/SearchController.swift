//
//  ViewController.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 13.12.2021.
//

import UIKit

class SearchController: UIViewController {
    
   private var plus: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return button
    }()
   
    private let presenter: SearchViewOutput

    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private let searchService = SearchService()
    
    var searchResults = [ITunesApp]() {
        didSet {
            searchView.tableView.isHidden = false
            searchView.tableView.reloadData()
            searchView.searchBar.resignFirstResponder()
            writeRes(searchRes: self.searchResults)
        }
    }
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    init(presenter: SearchViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchView.searchBar.delegate = self
        self.searchView.tableView.register(AppCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
        plus.addTarget(self, action: #selector(res), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: plus)
    }

    @objc private func res() {
           readRes()
    }
}

//MARK: - UITableViewDataSource
extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? AppCell else {
            return dequeuedCell
        }
        let app = self.searchResults[indexPath.row]
        let cellModel = AppCellModelFactory.cellModel(from: app)
        cell.configure(with: cellModel)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let app = searchResults[indexPath.row]
        let appDetaillViewController = AppDetailViewController(app: app)
        appDetaillViewController.app = app
        presenter.viewDidSelect(app: app)
    }
}

//MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        self.presenter.viewDidSearch(with: query)
    }
}

extension SearchController: SearchViewInput {
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription) Нажмите плюс", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoResults() {
        self.searchView.emptyResultView.isHidden = false
    }
    
    func hideNoResults() {
        self.searchView.emptyResultView.isHidden = true
    }
   
    private func writeRes(searchRes: Array<ITunesApp>) {
          do {
              let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("search.json")
              print(fileURL.path)
              try JSONEncoder().encode(searchRes).write(to:fileURL)
          } catch {
              print(error)
          }
      }
    
    private func readRes() {
          do {
              let fileURL = try FileManager.default
                  .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                  .appendingPathComponent("search.json")

              let data = try Data(contentsOf: fileURL)
              let readRes = try JSONDecoder().decode([ITunesApp].self, from: data)
              self.searchResults = readRes
          } catch {
              print(error)
          }
      }
}

