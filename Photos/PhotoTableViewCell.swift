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
    
    private enum Constants {
        static let containerInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let stackViewSpacing: CGFloat = 16.0
        static let backgroundColorHex = "#F2F2F7"
        static let cornerRadius: CGFloat = 14.0
        static let titleFont = UIFont.boldSystemFont(ofSize: 17.0)
        static let imageViewWidthMultiplier: CGFloat = 0.2
        static let imageViewAspectRatioMultiplier: CGFloat = 0.6
        
        static let eightSpacing: CGFloat = 8.0
        static let twelveSpacing: CGFloat = 12.0
        
        static let imageViewMaxHeight: CGFloat = 150
    }
    
    private let containerView: ContainerView = {
        let containerView = ContainerView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.stackViewSpacing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.font = Constants.titleFont
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
    
    private var needsSetupConstraints = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        if self.needsSetupConstraints {
            self.setupConstraints()
            self.needsSetupConstraints = !self.needsSetupConstraints
        }
        
        super.updateConstraints()
    }
    
    private func configureUI() {
        self.contentView.backgroundColor = UIColor(hexString: Constants.backgroundColorHex)
        self.containerView.cornerRadius = Constants.cornerRadius
        self.photoImageView.layer.cornerRadius = Constants.cornerRadius
        self.photoImageView.clipsToBounds = true
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
                self.descriptionLabel.text = description
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
    
    private func setupConstraints() {
        
        self.contentView.addSubview(self.containerView, insets: Constants.containerInsets)
        self.containerView.addSubview(self.photoImageView)
        self.containerView.addSubview(self.labelStackView)
        self.labelStackView.addArrangedSubview(self.titleLabel)
        self.labelStackView.addArrangedSubview(self.descriptionLabel)
        
        NSLayoutConstraint.activate([
            self.photoImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                         constant: Constants.eightSpacing),
            self.photoImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                     constant: Constants.eightSpacing),
            self.labelStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                     constant: Constants.twelveSpacing),
            self.labelStackView.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor,
                                                         constant: Constants.eightSpacing),
            self.containerView.trailingAnchor.constraint(equalTo: self.labelStackView.trailingAnchor,
                                                         constant: Constants.eightSpacing),
            self.containerView.bottomAnchor.constraint(equalTo: self.labelStackView.bottomAnchor,
                                                       constant: Constants.eightSpacing),
            self.photoImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,
                                                       multiplier: Constants.imageViewWidthMultiplier),
            self.photoImageView.heightAnchor.constraint(equalTo: self.photoImageView.widthAnchor,
                                                        multiplier: Constants.imageViewAspectRatioMultiplier),
            
            /* Because of the width relationship, the imageView might grow too much on phones with larger width, so set the maximum height for the imageView. */
            self.photoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.imageViewMaxHeight)
        ])
    }
}
