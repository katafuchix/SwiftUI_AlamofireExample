//
//  HttpClient.swift
//  SwiftUI_AlamofireExample
//
//  Created by cano on 2023/05/12.
//

import Foundation
import Combine
import Alamofire

class HttpClient {
    
    /*
     method: リクエストのHTTPメソッドを指定します。
     parameters: リクエストのパラメータを指定します。
     headers: リクエストのヘッダーを指定します。
     encoding: リクエストのエンコーディング方式を指定します。
     AF.requestメソッドにこれらの引数を渡してリクエストを送信します。
     */
    static func fetchData<T: Decodable>(url: String, method: HTTPMethod,
                                        parameters: Parameters?,
                                        headers: HTTPHeaders?,
                                        encoding: URLEncoding) -> AnyPublisher<DataResponse<T, AFError>, Never> {
        return AF.request(url,
                         method: method,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers)
            .publishDecodable(type: T.self)
            .eraseToAnyPublisher()
    }
    
    static func fetchData<T: Decodable>(url: String, method: HTTPMethod,
                                        parameters: Parameters?,
                                        headers: HTTPHeaders?,
                                        encoding: URLEncoding) -> AnyPublisher<T, AFError> {
        return AF.request(url,
                         method: method,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers)
            .publishDecodable(type: T.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func fetchData<T: Decodable>(url: String, method: HTTPMethod,
                                        parameters: Parameters?,
                                        headers: HTTPHeaders?,
                                        encoding: URLEncoding) -> AnyPublisher<T, Error> {
        return AF.request(url,
                         method: method,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers)
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod,
                                        parameters: [String: Any]?,
                                        headers: HTTPHeaders?,
                                        encoding: URLEncoding,
                                        completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
            .validate()
            .publishDecodable(type: T.self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { value in
                completion(.success(value))
            })
            .store(in: &cancellables)
    }
    
    /*
    func fetchData(url: String, method: HTTPMethod,
                                 parameters: [String: Any]?,
                                 headers: HTTPHeaders?,
                                 encoding: URLEncoding,
                                 completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchDataT<T: Decodable>(url: String, method: HTTPMethod,
                                        parameters: [String: Any]?,
                                        headers: HTTPHeaders?,
                                        encoding: URLEncoding,
                                        completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    */
    
}
