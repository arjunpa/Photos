//
//  PhotoListViewController.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class PhotoListViewController: UIViewController {
    
    var listViewModel: PhotoListViewModelInterface?
    
    private let disposeBag = DisposeBag()
    
    private let photoListView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        return tableView
    }()
    
    init(with viewModel: PhotoListViewModelInterface) {
        self.listViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.listViewModel?.fetchPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //https://github.com/RxSwiftCommunity/RxDataSources/issues/331
        self.setupBindings()
    }
    
    private func setupView() {
        self.view.addSubview(self.photoListView)
        NSLayoutConstraint.activate([
            self.photoListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.photoListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.photoListView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        self.listViewModel?.photoViewModel
        .drive(photoListView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { (_, photoViewModel, cell) in
            cell.textLabel?.text = photoViewModel.title
            cell.detailTextLabel?.text = photoViewModel.description
        }.disposed(by: self.disposeBag)
    }
}
