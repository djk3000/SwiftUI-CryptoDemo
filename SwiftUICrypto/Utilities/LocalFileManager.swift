//
//  LocalFileManager.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/9.
//

import Foundation
import SwiftUI

class LocalFileManager{
    static let instance = LocalFileManager()
    let folderName = "coin_images"
    private init(){ }
    
    private func createFolderIfNeed(){
        guard let url = getFolderPath() else { return }
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                print("create folder success")
            } catch let error {
                print("create folder error \(error)")
            }
        }
    }
    
    private func getFolderPath() -> URL?{
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String) -> URL?{
        guard let folder = getFolderPath() else {
            return nil
        }
        return folder.appendingPathComponent(key + ".png")
    }
    
    func saveImage(key: String, value: UIImage){
        //create folder
        createFolderIfNeed()
        
        guard
            let data = value.pngData(),
            let url = getImagePath(key: key) else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("add image cache error \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage?{
        guard
            let url = getImagePath(key: name),
            FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}
