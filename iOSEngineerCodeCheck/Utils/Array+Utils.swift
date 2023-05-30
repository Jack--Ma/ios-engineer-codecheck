//
//  Array+Utils.swift
//  iOSEngineerCodeCheck
//
//  Created by jackma on 2023/5/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

extension Array {
    func safeObject(at index: Int?) -> Element? {
        guard let index = index else { return nil }
        guard index >= 0, index < self.count else {
            return nil
        }
        return self[index]
    }
    
    subscript(safe index: Int?) -> Element? {
        guard let index = index else { return nil }
        guard index >= 0, index < self.count else {
            return nil
        }
        return self[index]
    }
}
