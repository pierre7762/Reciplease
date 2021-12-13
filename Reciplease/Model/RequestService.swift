//
//  RequestServcie.swift
//  Reciplease
//
//  Created by Pierre on 26/11/2021.
//

import Foundation


enum EdamamError: Error {
    case noData, invalidResponse, undecodableData
}

final class RequestService {
    private let session: AlamoFireSession
    private let api = ApiConstant()
    
    init(session: AlamoFireSession = EdamamSession()) {
        self.session = session
    }
    
    func getData(ingredients: String,fromIndex: Int, toIndex: Int, callback: @escaping (Result<RecipesAPi, EdamamError>) -> Void) {
        guard let url = URL(string: "\(self.api.edamamBaseUrl)?q=\(ingredients)&app_id=\(self.api.edamamId)&app_key=\(self.api.edamamKey)&from=\(fromIndex)&to=\(toIndex)") else { return }
        session.request(url: url) { dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(RecipesAPi.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
            
        }
    }
}
