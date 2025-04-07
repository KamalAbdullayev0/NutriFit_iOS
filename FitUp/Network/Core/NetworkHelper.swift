//
//  NetworkHelper.swift
//  TheMovieDB
//
//  Created by Kamal Abdullayev on 19.02.25.
//
import Alamofire

class NetworkHelper {
    static let shared = NetworkHelper()
    
    let baseURL = "https://nutrifit-w91f.onrender.com/"
    
    var headers: HTTPHeaders {
        print("[NetworkHelper] Generating headers")
        var headers: HTTPHeaders = []
        if let token = AuthManager.shared.accessToken {
            print("[NetworkHelper] Adding Authorization header")
            headers["Authorization"] = "Bearer \(token)"
        } else {
            print("[NetworkHelper] No access token available")
        }
        return headers
    }
}
