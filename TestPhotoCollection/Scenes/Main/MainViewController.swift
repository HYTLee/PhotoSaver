//
//  MainViewController.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 11.03.24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    private let toolBarView: UIView = UIView()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        return button
    }()
    
    private let layoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.layout(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = R.color.mainTitle()
        label.text = R.string.localizable.mainTitle()
        label.textAlignment = .center
        return label
    }()
    
    private var collectionView: UICollectionView?
    private let viewModel = MainViewModel()
    
    private var isGrid = false
    
    private var allSavedPhotos: [PhotoModel] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allSavedPhotos = viewModel.getAllSavedPhotos()
    }
}

private extension MainViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(toolBarView)
        toolBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.height.equalTo(44)
        }
        
        toolBarView.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(44)
        }
        
        toolBarView.addSubview(layoutButton)
        layoutButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        toolBarView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        if let collection = collectionView {
            view.addSubview(collection)
            collection.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
                make.top.equalTo(toolBarView.snp.bottom)
            }
        }
    }
    
    func bindUI() {
        setupLongGestureRecognizerOnCollection()
        cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        layoutButton.addTarget(self, action: #selector(changeLayout), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        setupInitialLayout()
        var layout = isGrid ? gridCollectionLayout() : listCollectionLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView?.allowsMultipleSelection = false
        collectionView?.backgroundColor = .white
    }
    
    @objc func changeLayout() {
        isGrid = !isGrid
        viewModel.setGridLayoutState(isGrid)
        collectionView?.startInteractiveTransition(to: isGrid ? gridCollectionLayout() : listCollectionLayout(), completion: nil)
        collectionView?.finishInteractiveTransition()
        layoutButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.layoutButton.isEnabled = true
        }
    }
    
    @objc func openCamera() {
        let cameraViewController = UIImagePickerController()
        cameraViewController.delegate = self
        cameraViewController.sourceType = UIImagePickerController.SourceType.camera
        cameraViewController.modalPresentationStyle = .fullScreen
        present(cameraViewController, animated: true, completion: nil)
    }
    
    func listCollectionLayout() -> UICollectionViewFlowLayout {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionFlowLayout.itemSize = CGSize(width: view.frame.width - 32, height: 100)
        return collectionFlowLayout
    }
    
    func gridCollectionLayout() -> UICollectionViewFlowLayout {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionFlowLayout.itemSize = CGSize(width: (view.frame.width - 48) / 2 , height: 100)
        return collectionFlowLayout
    }
    
    func setupInitialLayout() {
        isGrid = viewModel.readIsGridLayout()
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) { return }
        let location = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: location) {
            openDeleteAlert(photoId: allSavedPhotos[indexPath.row].id)
        }
    }
    
    func openDeleteAlert(photoId: String) {
        let deleteAlert = UIAlertController(title: R.string.localizable.warning(), message: R.string.localizable.warningDescr(), preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.viewModel.deletePhoto(id: photoId)
            if let photos = self?.viewModel.getAllSavedPhotos() {
                self?.allSavedPhotos = photos
            }
        }))

        deleteAlert.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel ))

        present(deleteAlert, animated: true, completion: nil)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            viewModel.savePhoto(image: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSavedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoTitle = allSavedPhotos[indexPath.row].title
        cell.photoImage = viewModel.getImageFromDocumets(id: allSavedPhotos[indexPath.row].id)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController()
        photoViewController.id = allSavedPhotos[indexPath.row].id
        photoViewController.photoImage = viewModel.getImageFromDocumets(id: allSavedPhotos[indexPath.row].id)
        photoViewController.titleString = allSavedPhotos[indexPath.row].title
        photoViewController.renameHandler = { [weak self] in
            self?.allSavedPhotos = self?.viewModel.getAllSavedPhotos() ?? []
        }
        present(photoViewController, animated: true)
    }
}
