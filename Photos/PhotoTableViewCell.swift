//
//  PhotoTableViewCell.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import RxSwift

final class PhotoTableViewCell: UITableViewCell {
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = .zero
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
    }
    
    func configure(with viewModel: PhotoViewModelInterface) {
        viewModel
            .title
            .drive(self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModel
            .description
            .asObservable()
            .subscribe(onNext: { [weak self] description in
                guard let self = self else { return }
                if let description = description {
                    self.descriptionLabel.text = description
                    self.labelStackView.addArrangedSubview(self.descriptionLabel)
                } else {
                    self.descriptionLabel.removeFromSuperview()
                }
            },
                       onError: nil,
                       onCompleted: nil,
                       onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.photoImageView.image = nil
        
        viewModel
            .image
            .drive(self.photoImageView.rx.image)
            .disposed(by: self.disposeBag)
        
        viewModel.downloadImage()
        self.labelStackView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
    
    private func setupConstraints() {
        self.contentView.addSubview(self.photoImageView)
        self.contentView.addSubview(self.labelStackView)
        self.labelStackView.addArrangedSubview(self.titleLabel)
        
        NSLayoutConstraint.activate([
            self.photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.photoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            self.labelStackView.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor, constant: 8.0),
            self.labelStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.labelStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.labelStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0)
        ])
        let aspectRatioConstraint = self.photoImageView.heightAnchor.constraint(equalTo: self.photoImageView.widthAnchor,
                                                                                multiplier: 1.0/2.0)
        aspectRatioConstraint.priority = .defaultHigh
        aspectRatioConstraint.isActive = true
    }
}
