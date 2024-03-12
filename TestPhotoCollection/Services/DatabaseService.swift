//
//  DatabaseService.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//


import Foundation
import RealmSwift

class DatabaseService {
    var token: NotificationToken?
    
    let configuration = Realm.Configuration(schemaVersion: 1)
    var realm: Realm
    
    init(token: NotificationToken? = nil) {
        self.token = token
        realm = try! Realm(configuration: configuration)
    }
    
    func addPhotoData(id: String, title: String, date: Date) {
        let photo = PhotoModel()
        photo.id = id
        photo.title = title
        photo.creationDate = date
        try! realm.write {
               realm.add(photo)
        }
    }
    
    func readAllPhotoData() -> Results<PhotoModel> {
        let data = realm.objects(PhotoModel.self)
        return data
    }
    
    func deletePhoto(id: String) {
        let photos = readAllPhotoData()
        let photoToDelete = Array(photos).first {
            $0.id == id
        }
        guard let photo = photoToDelete else { return }
        try! realm.write {
            realm.delete(photo)
        }
    }

    func renamePhoto(id: String, newTitle: String) {
        let photos = readAllPhotoData()
        let photoToRename = Array(photos).first {
            $0.id == id
        }
        guard let photo = photoToRename else { return }
        try! realm.write {
            photo.title = newTitle
        }
    }
 }

