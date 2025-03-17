//
//  NetworkHelper.swift
//  TheMovieDB
//
//  Created by Kamal Abdullayev on 19.02.25.
//

import Foundation
import Alamofire

enum EncodingType {
    case url
    case json
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    private let baseURL = "https://api.themoviedb.org/3"
    let imageBaseURL = "https://image.tmdb.org/t/p/original"
    let header: HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNTU3MWRhYTJmYjIzMTljYjQwZjdkMWMxNWNjMGIwNSIsIm5iZiI6MTcyNDM1NTM2OC40OTcsInN1YiI6IjY2Yzc5MzI4NGZhODI1MTAzZGIyZTcyMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.-IUzFlm-3iPjHcbFYFKR7mSbFLrAW9YnqDb3-1KPYms"]
    
    func configureURL(endpoint: String) -> String{
        return baseURL + "/" + endpoint
    }
}
