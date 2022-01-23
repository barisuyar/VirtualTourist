//
//  FlickerPage.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

struct FlickerPage: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [FlickerPhoto]
}
