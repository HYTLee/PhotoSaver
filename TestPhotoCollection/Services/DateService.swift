//
//  DateService.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation

class DateService {
    
    func getNumberOfTodayPhotos(photos: [PhotoModel]) -> Int {
        var numberOfTodayPhotos = 0
        for photo in photos {
            if Calendar.current.isDateInToday(photo.creationDate) {
                numberOfTodayPhotos += 1
            }
        }
        return numberOfTodayPhotos
    }
    
    
    func createStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}
