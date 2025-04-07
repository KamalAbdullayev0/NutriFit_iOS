//
//  NetworkManager.swift
//  NetworkingURLSession
//
//  Created by Kamal Abdullayev on 19.02.25.
//
import Alamofire

//class NetworkManager {
//    func request<T: Codable>(path: String,
//                             model: T.Type,
//                             method: HTTPMethod = .get,
//                             params: Parameters? = nil,
//                             encodingType: EncodingType = .url,
////                             header: HTTPHeaders? = nil,
//                             completion: @escaping((T?, String?) -> Void)) {
//        AF.request(path,
//                   method: method,
//                   parameters: params,
//                   encoding: encodingType == .url ? URLEncoding.default : JSONEncoding.default,
//                   headers: NetworkHelper.shared.header).responseDecodable(of: model.self) { response in
//            switch response.result {
//            case .success(let data):
//                completion(data, nil)
//            case .failure(let error):
//                completion(nil, error.localizedDescription)
//            }
//        }
//    }
//}
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        print("[NetworkManager] Initialized network manager")
    }
    
    func request<T: Codable>(
        endpoint: Endpoint,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encodingType: EncodingType = .url
    ) async throws -> T {
        let fullURL = "\(NetworkHelper.shared.baseURL)\(endpoint.rawValue)"
        print("[NetworkManager] Starting request to \(fullURL)")
        print("[NetworkManager] Method: \(method.rawValue)")
        print("[NetworkManager] Parameters: \(parameters ?? [:])")
        print("[NetworkManager] Encoding: \(encodingType)")
        print("[NetworkManager] Headers: \(NetworkHelper.shared.headers)")
        
        let request = AF.request(
            fullURL,
            method: method,
            parameters: parameters,
            encoding: encodingType == .url ? URLEncoding.default : JSONEncoding.default,
            headers: NetworkHelper.shared.headers
        )
        
        do {
            print("[NetworkManager] Sending request...")
            let response = try await request
                .validate()
                .serializingDecodable(T.self)
                .value
            
            print("[NetworkManager] Request succeeded")
            print("[NetworkManager] Response: \(response)")
            return response
        } catch {
            print("[NetworkManager] Request failed: \(error.localizedDescription)")
            
            if let decodingError = error as? DecodingError {
                print("[NetworkManager] Decoding error: \(decodingError)")
                throw NetworkError.decodingError
            }
            
            guard let afError = error.asAFError else {
                print("[NetworkManager] Unknown error type")
                throw NetworkError.invalidResponse
            }
            
            if let statusCode = afError.responseCode {
                print("[NetworkManager] HTTP Status Code: \(statusCode)")
                switch statusCode {
                case 401:
                    print("[NetworkManager] Detected 401 Unauthorized")
                    print("[NetworkManager] Attempting token refresh...")
                    let refreshSuccess = try await refreshToken()
                    
                    if refreshSuccess {
                        print("[NetworkManager] Token refresh successful, retrying original request")
                        return try await self.request(
                            endpoint: endpoint,
                            method: method,
                            parameters: parameters,
                            encodingType: encodingType
                        )
                    } else {
                        print("[NetworkManager] Token refresh failed")
                        throw NetworkError.unauthorized
                    }
                default:
                    print("[NetworkManager] Server error: \(afError.errorDescription ?? "Unknown error")")
                    throw NetworkError.requestFailed(
                        statusCode: statusCode,
                        message: afError.errorDescription
                    )
                }
            } else {
                print("[NetworkManager] Network error: \(afError.localizedDescription)")
                throw NetworkError.invalidResponse
            }
        }
    }
    
    private func refreshToken() async throws -> Bool {
        print("[NetworkManager] Starting token refresh process")
        
        guard let refreshToken = AuthManager.shared.refreshToken else {
            print("[NetworkManager] No refresh token available")
            return false
        }
        
        print("[NetworkManager] Found refresh token: \(refreshToken.prefix(4))...")
        let parameters: Parameters = ["refresh_token": refreshToken]
        
        do {
            print("[NetworkManager] Sending refresh token request")
            let response = try await AF.request(
                "\(NetworkHelper.shared.baseURL)/auth/refresh-token",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .validate()
            .serializingDecodable(RefreshTokenResponse.self)
            .value
            
            print("[NetworkManager] Received new access token: \(response.accessToken.prefix(4))...")
            AuthManager.shared.accessToken = response.accessToken
            return true
        } catch {
            print("[NetworkManager] Refresh token failed: \(error.localizedDescription)")
            return false
        }
    }
}


//final class NetworkManager {
//    static let shared = NetworkManager()
//    
//    private init() {
//        print("[NetworkManager] Initialized network manager")
//    }
//
//    func request<T: Decodable>(
//        endpoint: Endpoint,
//        method: HTTPMethod = .get,
//        parameters: Parameters? = nil,
//        encodingType: EncodingType = .url
//    ) async throws -> T {
//        let fullURL = "\(NetworkHelper.shared.baseURL)/\(endpoint.rawValue)"
//        print("[NetworkManager] Starting request to \(fullURL)")
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            let request = AF.request(
//                fullURL,
//                method: method,
//                parameters: parameters,
//                encoding: encodingType == .url ? URLEncoding.default : JSONEncoding.default,
//                headers: NetworkHelper.shared.headers
//            )
//
//            request.validate().responseDecodable(of: T.self) { response in
//                switch response.result {
//                case .success(let data):
//                    print("[NetworkManager] Request succeeded")
//                    print("[NetworkManager] Response: \(data)")
//                    continuation.resume(returning: data)
//                    
//                case .failure(let error):
//                    print("[NetworkManager] Request failed: \(error.localizedDescription)")
//
//                    if let afError = error.asAFError,
//                       afError.responseCode == 401 {
//                        Task {
//                            let refreshSuccess = try await self.refreshToken()
//                            if refreshSuccess {
//                                do {
//                                    let retryData: T = try await self.request(
//                                        endpoint: endpoint,
//                                        method: method,
//                                        parameters: parameters,
//                                        encodingType: encodingType
//                                    )
//                                    continuation.resume(returning: retryData)
//                                } catch {
//                                    continuation.resume(throwing: NetworkError.unauthorized)
//                                }
//                            } else {
//                                continuation.resume(throwing: NetworkError.unauthorized)
//                            }
//                        }
//                    } else if let decodingError = error.asAFError?.underlyingError as? DecodingError {
//                        print("[NetworkManager] Decoding error: \(decodingError)")
//                        continuation.resume(throwing: NetworkError.decodingError)
//                    } else {
//                        continuation.resume(throwing: NetworkError.requestFailed(
//                            statusCode: error.asAFError?.responseCode,
//                            message: error.localizedDescription
//                        ))
//                    }
//                }
//            }
//        }
//    }
//    
//    private func refreshToken() async throws -> Bool {
//        print("[NetworkManager] Starting token refresh process")
//        
//        guard let refreshToken = AuthManager.shared.refreshToken else {
//            print("[NetworkManager] No refresh token available")
//            return false
//        }
//
//        let parameters: Parameters = ["refresh_token": refreshToken]
//
//        return try await withCheckedThrowingContinuation { continuation in
//            AF.request(
//                "\(NetworkHelper.shared.baseURL)/auth/refresh-token",
//                method: .post,
//                parameters: parameters,
//                encoding: JSONEncoding.default
//            )
//            .validate()
//            .responseDecodable(of: RefreshTokenResponse.self) { response in
//                switch response.result {
//                case .success(let tokenResponse):
//                    AuthManager.shared.accessToken = tokenResponse.accessToken
//                    print("[NetworkManager] Token refreshed")
//                    continuation.resume(returning: true)
//                case .failure(let error):
//                    print("[NetworkManager] Refresh token failed: \(error.localizedDescription)")
//                    continuation.resume(returning: false)
//                }
//            }
//        }
//    }
//}
