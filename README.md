# SwiftUI_AlamofireExample
- Alamofire (5.0.0)


```
    static func fetchData<T: Decodable>(url: String, method: HTTPMethod,
                                        parameters: Parameters?,
                                        headers: HTTPHeaders?,
                                        encoding: URLEncoding) -> AnyPublisher<DataResponse<T, AFError>, Never> {
        return AF.request(url,
                         method: .get,
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
                         method: .get,
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
                         method: .get,
                         parameters: parameters,
                         encoding: encoding,
                         headers: headers)
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

```
