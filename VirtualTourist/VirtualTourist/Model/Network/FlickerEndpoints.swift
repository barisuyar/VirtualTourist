//
//  FlickerEndpoints.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import Foundation

enum FlickerEndpoints {

    case getPhotos(Double, Double, Int16)

    var url: URL? {
        switch self {
        case .getPhotos(let latitude, let longitude, let page):
            return createPhotosUrl(latitude: latitude, longitude: longitude, page: page)
        }
    }

    private var getPhotosBaseUrlComponent: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.flickr.com"
        urlComponents.path = "/services/rest/"
        return urlComponents
    }
    
    private func createPhotosUrl(latitude: Double, longitude: Double, page: Int16) -> URL? {
        var urlComponents = getPhotosBaseUrlComponent
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "038fb6b77ba1f9d6dc1370974fa45c52"),
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        return urlComponents.url
    }
}
