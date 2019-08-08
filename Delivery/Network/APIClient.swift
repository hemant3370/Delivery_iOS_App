import Moya

struct APIClient<Model: Decodable> {
    static func request<API: TargetType>(provider: MoyaProvider<API>, apiRequest: API, completionHandler: @escaping (Result<Model, Error>) -> Void) {
        provider.request(apiRequest, completion: { (response) in
            switch response {
            case .success(let res):
                do {
                    let model: Model = try JSONDecoder().decode(Model.self, from: res.data)
                    completionHandler(.success(model))
                } catch let error {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}
