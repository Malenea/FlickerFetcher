//
//  APIHandler.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 20/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import Foundation

final class APIHandler {

    // Singleton
    static let shared = APIHandler()

    // Control variables
    private let apiKey = "409c210c52dc34ed07fcc512b82e859b"

    func getPhotosUrls(for photographer: Photographers, forPage page: Int = 1, completion: @escaping ([Photo])->()) {
        let properties = [
            "&user_id=\(photographer.rawValue)",
            "&page=\(page)",
            "&per_page=20",
            "&extras=url_-,url_z"
        ]

        request(method: "flickr.people.getPhotos", properties: properties) { object in
            DispatchQueue.global().async {
                let photos = object.value(forKeyPath: "photos.photo") as? [NSDictionary]
                let returnPhotos = photos?.map({ Photo(dictionary: $0) }).filter({ $0 != nil }) as? [Photo] ?? []
                DispatchQueue.main.async {
                    completion(returnPhotos)
                }
            }
        }
    }

    func getPhotoComments(for photo: Photo, completion: @escaping ([PhotoComment])->()) {
        let properties = ["&photo_id=\(photo.id)"]

        request(method: "flickr.photos.comments.getList", properties: properties) { object in
            DispatchQueue.global().async {
                let comments = object.value(forKeyPath: "comments.comment") as? [NSDictionary]
                let returnComments = comments?.map({ PhotoComment(dictionary: $0) }).filter({ $0 != nil }) as? [PhotoComment] ?? []
                DispatchQueue.main.async {
                    completion(returnComments)
                }
            }
        }
    }

    private func request(method: String, properties: [String], completion: @escaping (NSDictionary)->()) {
        let baseURL = "https://api.flickr.com/services/rest/?"
        let methodString = "&method=\(method)"
        let apiString = "&api_key=\(apiKey)"
        let formatString = "&format=json"
        let parameterString = properties.reduce("", { $0 + $1})

        let urlString = baseURL + methodString + apiString + formatString + parameterString

        guard let requestURL = URL(string: urlString) else {return}

        _ = CachedRequest.request(url: requestURL) { data, isCached in
            if let data = data, let jsonDictionary = self.processJSON(data: data) {
                completion(jsonDictionary)
            }
        }
    }

    private func processJSON(data: Data) -> NSDictionary? {
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        guard let jsonString = dataString? .replacingOccurrences(of: "jsonFlickrApi(", with: "") .replacingOccurrences(of: ")", with: "").data(using: .utf8) else { return nil }
        do {
            let result = try JSONSerialization.jsonObject(with: jsonString, options: .mutableContainers)
            return result as? NSDictionary
        } catch {
            print(error)
        }
        return nil
    }

}

fileprivate extension Photo {

    init?(dictionary: NSDictionary) {
        guard let idString = dictionary.value(forKeyPath:"id") as? String, let nameString = dictionary.value(forKeyPath:"title") as? String, let originalString = dictionary.value(forKeyPath:"url_z") as? String ?? dictionary.value(forKeyPath:"url_-") as? String, let url = URL(string: originalString) else {return nil}

        self.id = idString
        self.name = nameString
        self.url = url
    }

}

fileprivate extension PhotoComment {
    init?(dictionary: NSDictionary) {
        guard
            let idString = dictionary.value(forKeyPath:"id") as? String,
            let authorString = dictionary.value(forKeyPath:"authorname") as? String,
            let commentString = dictionary.value(forKeyPath:"_content") as? String
            else { return nil }

        self.id = idString
        self.author = authorString
        self.comment = commentString
    }
}
