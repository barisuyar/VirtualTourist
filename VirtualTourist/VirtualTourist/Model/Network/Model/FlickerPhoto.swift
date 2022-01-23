//
//  FlickerPhoto.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

struct FlickerPhoto: Codable {
    let id : String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
