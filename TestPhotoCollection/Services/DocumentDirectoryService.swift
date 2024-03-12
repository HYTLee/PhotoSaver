//
//  DocumentDirectoryService.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation
import UIKit

class DocumentDirectoryService {

    func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileURL
        }
        return nil
    }

     func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
    
    func removeImageFromDocumentDirectory(fileName: String) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        }
        catch {
            print(error)
        }
    }
}
