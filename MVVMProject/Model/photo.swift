//
//  photo.swift
//  MVVMProject
//
//  Created by EasonLin on 2021/2/22.
//

import Foundation
struct Photos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let title: String
    let thumbnailUrl: String
}
