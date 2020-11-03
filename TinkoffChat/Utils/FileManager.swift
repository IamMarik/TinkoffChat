//
//  FileManager.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 10.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class FileUtils {
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func writeToDisk(data: Data?, fileName: String) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data?.write(to: url)
            return true
        } catch {
            return false
        }
    }
    
    static func readFromDisk(fileName: String) -> Data? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let data = try? Data(contentsOf: url)
        return data
    }
    
    static func fileExist(fileName: String) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
