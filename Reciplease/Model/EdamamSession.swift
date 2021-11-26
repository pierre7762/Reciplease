//
//  EdamamSession.swift
//  Reciplease
//
//  Created by Pierre on 26/11/2021.
//

import Foundation
import Alamofire

protocol AlamoFireSession {
    func request(url: URL, callback: @escaping (AFDataResponse<Any>) -> Void)
}

final class EdamamSession: AlamoFireSession {
    func request(url: URL, callback: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url).responseJSON { DataResponse in
            callback(DataResponse)
        }
    }
}
