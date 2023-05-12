# SwiftUI_AlamofireExample
- Alamofire (5.7.1)


```
- method: リクエストのHTTPメソッドを指定します。
- parameters: リクエストのパラメータを指定します。
- headers: リクエストのヘッダーを指定します。
- encoding: リクエストのエンコーディング方式を指定します。
- AF.requestメソッドにこれらの引数を渡してリクエストを送信します。

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

```
