//
//  PhotoViewController.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation
import UIKit
import SnapKit

class PhotoViewController: UIViewController {
    private let scrollView = UIScrollView()
    
    private let backImageView = UIImageView()
    
    private let titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor( .black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    var photoImage: UIImage? {
        didSet {
            guard let image = photoImage else { return }
            backImageView.image = image
        }
    }
    
    var titleString: String? {
        didSet {
            guard let title = titleString else { return }
            titleButton.setTitle(title, for: .normal)
        }
    }
    
    var renameHandler: (() -> Void)?
    
    var id: String?
    
    private let viewModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupUI()
        bindUI()
    }
    
}

private extension PhotoViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(view)
        }
        
        view.addSubview(titleButton)
        titleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(20)
        }
    }
    
    func bindUI() {
        titleButton.addTarget(self, action: #selector(openRenameAlert), for: .touchUpInside)
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    @objc func openRenameAlert() {
        let alertController = UIAlertController(
            title: R.string.localizable.rename(),
            message: nil,
            preferredStyle: .alert)

        alertController.addTextField { [weak self] (textField) in
            textField.placeholder = self?.titleString
        }
        
        let continueAction = UIAlertAction(title: R.string.localizable.ok(), style: .default) { [weak alertController] _ in
            guard let textField = alertController?.textFields?.first else { return }
            self.viewModel.renamePhoto(id: self.id ?? "", name: textField.text ?? "")
            self.titleString = textField.text
            self.renameHandler?()
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)

        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backImageView
    }
}
