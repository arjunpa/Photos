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
    
    private enum Constants {
        static let estimatedRowHeight: CGFloat = 80.0
        static let listBackgroundColorHex = "#F2F2F7"
    }
    
    var listViewModel: PhotoListViewModelInterface?
    
    private let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    
    private let photoListView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //https://github.com/RxSwiftCommunity/RxDataSources/issues/331
        self.setupBindings()
        self.listViewModel?.fetchPhotos(ignoreCache: false)
    }
    
    private func setupView() {
        self.view.addSubview(self.photoListView)
        NSLayoutConstraint.activate([
            self.photoListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.photoListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.photoListView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        self.photoListView.refreshControl = self.refreshControl
        self.photoListView.separatorStyle = .none
        self.photoListView.backgroundColor = UIColor(hexString: Constants.listBackgroundColorHex)
    }
    
    private func setupBindings() {
        guard let viewModel = self.listViewModel else { return }
        
        viewModel
            .photoViewModel
            .drive(self.photoListView.rx.items(cellIdentifier: PhotoTableViewCell.reuseIdentifier,
                                          cellType: PhotoTableViewCell.self)) { (_, photoViewModel, cell) in
                                            cell.configure(with: photoViewModel)
        }
        .disposed(by: self.disposeBag)
        
        self
            .photoListView
            .rx
            .didEndDisplayingCell
            .subscribe(onNext: { (_, indexPath) in
                viewModel.cancelDownload(at: indexPath.row)
        },             onError: nil,
                       onCompleted: nil,
                       onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        viewModel
            .title
            .drive(self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        
        viewModel
            .isLoading
            .map({ !$0 })
            .drive(self.refreshControl.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self
            .refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe { [weak self] _ in
                self?.listViewModel?.fetchPhotos(ignoreCache: true)
            }
            .disposed(by: self.disposeBag)
        
        viewModel
            .isLoading
            .drive(onNext: { [weak self] isLoading in
                guard !isLoading else {
                    self?.refreshControl.beginRefreshing()
                    return
                }
                self?.refreshControl.endRefreshing()
            },
                   onCompleted: nil,
                   onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        viewModel
            .error
            .drive(onNext: { [weak self] error in
                guard let error = error else { return }
                self?.handleError(error: error)
            },
                    onCompleted: nil,
                    onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    private func handleError(error: LocalizedError) {
        let alertController = UIAlertController(title: error.title,
                                                message: error.body,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK_TITLE".localized,
                                        style: .default,
                                        handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
