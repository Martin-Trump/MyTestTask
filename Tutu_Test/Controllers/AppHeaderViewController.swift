//
//  AppHeaderViewController.swift
//  Tutu_Test
//
//  Created by Павел Шатунов on 15.12.2021.
//

import Foundation
import UIKit

class AppDetailHeaderViewController: UIViewController {
    
    private let app: ITunesApp
    private let imageDownloader = ImageDownloader()
    
    private var appDetailHeaderView: AppDetailHeaderView {
        return self.view as! AppDetailHeaderView
    }
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = AppDetailHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillData()
    }
    
    private func fillData() {
        downloadImage()
        
        appDetailHeaderView.titleLabel.text = app.appName
        appDetailHeaderView.subTitleLabel.text = app.company
        appDetailHeaderView.ratingLabel.text = app.averageRating.flatMap { "\($0)" }
    }
    
    private func downloadImage() {
        guard let url = app.iconUrl else { return }
        
        imageDownloader.getImage(fromUrl: url) { [weak self] (image, error) in
            guard let self = self else { return }
            
            if error == nil {
                DispatchQueue.main.async {
                    self.appDetailHeaderView.imageView.image = image
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    

}

