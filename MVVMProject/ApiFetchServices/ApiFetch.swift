//
//  ApiFetch.swift
//  MVVMProject
//
//  Created by EasonLin on 2021/2/22.
//

import Foundation
import Alamofire

class APIFetch {
    func fetchImgList( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: Error? )->() ) {

        AF.request("https://jsonplaceholder.typicode.com/photos")
                    .responseData { response in
           guard let data = response.data else { return }
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let photos = try! decoder.decode([Photo].self, from: data)
          complete( true, photos, nil )
        }
    }
}
 
