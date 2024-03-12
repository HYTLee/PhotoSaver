//
//  PhotoModel.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation
import RealmSwift

class PhotoModel: Object {
    @Persisted var id: String
    @Persisted var creationDate: Date
    @Persisted var title: String
}

