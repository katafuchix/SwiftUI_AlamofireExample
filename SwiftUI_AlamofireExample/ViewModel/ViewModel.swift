//
//  ViewModel.swift
//  SwiftUI_AlamofireExample
//
//  Created by cano on 2023/05/12.
//

import Foundation
import Combine
import Alamofire

class ViewModel: ObservableObject {
    
    // MARK: - Input
    @Published var searchWord: String = ""
    
    // MARK: - Output
    @Published private(set) var result: [Cocktail] = []
    @Published var isSearching = false
    @Published var error: AFError?
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private let client = HttpClient()
    
    init() {
      $searchWord
        .dropFirst()
        .filter { $0 != "" }
        .compactMap { $0 }
        .debounce(for: 0.8, scheduler: DispatchQueue.main)
        /*.handleEvents(receiveSubscription: { [weak self] value in  // 初期入力 Drop などを捉えてしまう
          self?.isSearching = true
        })*/
        .handleEvents(receiveOutput: { [weak self] value in // 入力系はこっちがいい
          self?.isSearching = true
        })
        .map { searchTerm -> AnyPublisher<DataResponse<CocktailSearchResult, AFError>, Never> in
          self.isSearching = true
            return HttpClient.fetchData(url: "https://www.thecocktaildb.com/api/json/v1/1/search.php", method: .get, parameters: ["s": searchTerm] , headers: nil, encoding: URLEncoding.default)
        }
        .switchToLatest()
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self]  ret in
            if let value = ret.value {
                self?.result = value.drinks
            }
            if let error = ret.error {
                self?.error = error
            }
          self?.isSearching = false
        })
        .store(in: &cancellables)
    }
    
    /*
     init 以外で行うならこんなふうに
     
     .fetchData(url: url)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.error = error
            }
        }, receiveValue: { [weak self] value in
            self?.data = value
        })
    */
    
    //@Published var data: Data?
    //@Published var decodedData: CocktailSearchResult?
    
    /*func fetchData() {
        let parameters: [String: Any] = [
            "s": "Blue"
        ]
        
        client.fetchData(url: "https://www.thecocktaildb.com/api/json/v1/1/search.php", method: .get, parameters: parameters, headers: nil, encoding: URLEncoding.default){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.data = result
                    print(result)
                    self.decodeData()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func decodeData() {
        guard let data = data else {
            self.decodedData = nil
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(CocktailSearchResult.self, from: data)
            self.decodedData = decodedData
        } catch {
            print("Decoding error: \(error)")
            self.decodedData = nil
        }
    }
     */
}


/*
class APIManager {
    static func fetchData<T: Decodable>(url: URL) -> AnyPublisher<T, AFError> {
        return AF.request(url)
            .publishDecodable(type: T.self)
            .value()
            .eraseToAnyPublisher()
    }
}

class ViewModelTest: ObservableObject {
    @Published var data: [Cocktail]?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData(url: URL) {
        APIManager.fetchData(url: url)
            .sink(receiveCompletion: { completion in
                // Handle completion if needed
            }, receiveValue: { [weak self] (value: [Cocktail]) in
                //if let users = value as? [Cocktail] {
                    self?.data = value
                //}
            })
            .store(in: &cancellables)
    }
}
*/
/*
class APIManager {
    static var cancellables = Set<AnyCancellable>()
    
    static func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url)
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
}

class ViewModelTest: ObservableObject {
    @Published var data: CocktailSearchResult = CocktailSearchResult(drinks: [])
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        let url = URL(string: "https://api.example.com/users")!
        APIManager.fetchData(url: url) { (result: Result<CocktailSearchResult , Error>) in
            switch result {
            case .success(let ret):
                self.data = ret
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
*/
/*
class ContentViewModel<T: Decodable>: ObservableObject {
    @Published var data: T?

    let client = HttpClient()
    
    static func createViewModel(url: String) -> ContentViewModel<T> {
        let viewModel = ContentViewModel<T>()
        viewModel.fetchData()
        return viewModel
    }

    private func fetchData() {
        let parameters: [String: Any] = [
            "s": "Blue"
        ]
        client.fetchDataT(url: "https://www.thecocktaildb.com/api/json/v1/1/search.php", method: .get, parameters: parameters, headers: nil, encoding: URLEncoding.default) { (result: Result<T, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseData):
                    self.data = responseData
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
*/
 
/*
class APIManager {
    static func fetchData<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url)
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
}

class ContentViewModel<T: Decodable>: ObservableObject {
    @Published var data: T?

    static func createViewModel(url: String) -> ContentViewModel<T> {
        let viewModel = ContentViewModel<T>()
        viewModel.fetchData(url: url)
        return viewModel
    }

    private func fetchData(url: String) {
        APIManager.fetchData(url: url) { (result: Result<T, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseData):
                    self.data = responseData
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
*/
