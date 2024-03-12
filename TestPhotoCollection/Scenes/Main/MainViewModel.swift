//
//  MainViewModel.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 11.03.24.
//

import Foundation
import UIKit

class MainViewModel {
    
    private let databaseService = DatabaseService()
    private let documentDirectoryService = DocumentDirectoryService()
    private let dateService = DateService()
    
    func savePhoto(image: UIImage) {
        let uuid = UUID().uuidString
        let date = Date()
        let numberOfPhoto = dateService.getNumberOfTodayPhotos(photos: Array(databaseService.readAllPhotoData())) + 1
        let photoTitle = "\(dateService.createStringFromDate(date: date)) (\(numberOfPhoto))"
        _ = documentDirectoryService.saveImageInDocumentDirectory(image: image, fileName: uuid)
        databaseService.addPhotoData(id: uuid, title: photoTitle, date: date)
    }
    
    func getAllSavedPhotos() -> [PhotoModel] {
        let photos = databaseService.readAllPhotoData()
        let sortedArray = Array(photos).sorted { first, second in
            first.creationDate.compare(second.creationDate) == .orderedDescending
        }
        return sortedArray
    }
    
    func getImageFromDocumets(id: String) -> UIImage {
        let image = documentDirectoryService.loadImageFromDocumentDirectory(fileName: id) ?? UIImage()
        return image
    }
    
    func setGridLayoutState(_ isGrid: Bool) {
        UserDefaultsManager.shared.setIsGridLayout(type: isGrid)
    }
    
    func readIsGridLayout() -> Bool {
        let val = UserDefaultsManager.shared.readIsGridLayout()
        return val
    }
    
    func deletePhoto(id: String) {
        documentDirectoryService.removeImageFromDocumentDirectory(fileName: id)
        databaseService.deletePhoto(id: id)
    }
}
