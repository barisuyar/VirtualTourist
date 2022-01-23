//
//  FlickerClient.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import Foundation

final class FlickerClient {

    @discardableResult
    class func createTask<ResponseType: Decodable>(url: URL,
                                                   responseType: ResponseType.Type,
                                                   completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }

        }
        task.resume()
        return task
    }

    class func getPhotos(latitude: Double, longitude: Double, page: Int16, completion: @escaping (FlickerResponse?, Error?) -> Void) {
        guard let url = FlickerEndpoints.getPhotos(latitude, longitude, page).url else {
            completion(nil, nil)
            return
        }
        createTask(url: url, responseType: FlickerResponse.self) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    completion(response.self, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    class func downloadPhotos(imageURL: URL, completion: @escaping (Data?, Error?) throws -> Void){
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    try? completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                try? completion(data, nil)
            }
        }.resume()
    }
}

