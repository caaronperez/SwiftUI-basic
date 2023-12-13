import Foundation

class TodoViewModel: ObservableObject {
    @Published var todos = [Todo]()

    func fetchTodos(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://your-api-id.execute-api.your-region.amazonaws.com") else {
            print("Invalid API endpoint URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching todos: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedTodos = try decoder.decode([Todo].self, from: data)

                DispatchQueue.main.async {
                    self.todos = decodedTodos
                    completion(.success(()))
                }
            } catch {
                print("Error decoding todos: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
