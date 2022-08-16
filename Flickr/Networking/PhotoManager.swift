//
//  PhotoManager.swift
//  Flickr
//
//  Created by Himanshu Lahoti on 30/06/22.
//

import Foundation
protocol PhotoManagerDelegate {
    func fetchedImages(imageData : [Photo])
    func didFailWithError(error: Error)
}

struct PhotoManager{
    var delegate: PhotoManagerDelegate?
    
    func fetchImage(imageText:String,pageCount : Int)  {
        let urlString = Constants.apiUrl+"&safe_search=\(pageCount)" + "&text=\(imageText)"
        print(urlString)
        performRequest(requestString: urlString)
    }
    
    func performRequest(requestString:String){
        if let dataUrl = URL(string: requestString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: dataUrl) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(FlickrPhotos.self,from:safeData)
                        
                        let decodedImages = (decodedData.photos)?.photo
                        if let imageArray = decodedImages{
                            delegate?.fetchedImages(imageData: imageArray)
                        }
                    } catch  {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
}

