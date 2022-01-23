//
//  FlickerResponse.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

struct FlickerResponse: Codable {

    let photos: FlickerPage
    let status: String

    enum CodingKeys: String, CodingKey {
        case photos = "photos"
        case status = "stat"
    }
}
