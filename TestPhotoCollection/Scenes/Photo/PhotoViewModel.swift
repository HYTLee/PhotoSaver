//
//  PhotoViewModel.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation

class PhotoViewModel {
    
    private let databaseService = DatabaseService()
    
    func renamePhoto(id: String, name: String) {
        databaseService.renamePhoto(id: id, newTitle: name)
    }
}
