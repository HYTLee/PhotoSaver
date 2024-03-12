//
//  PhotoCell.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    private let photoImageView = UIImageView()
    
    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var photoImage: UIImage? {
        didSet {
            guard let image = photoImage else { return }
            photoImageView.image = image
        }
    }
    
    var photoTitle: String? {
        didSet {
            guard let text = photoTitle else { return }
            photoTitleLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

private extension PhotoCell {
    func setupUI() {
        contentView.addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.leading.centerY.equalToSuperview()
        }
        
        contentView.addSubview(photoTitleLabel)
        photoTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(photoImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
}
