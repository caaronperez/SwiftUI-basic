import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = TodoViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Tap the 'Execute' button to fetch")
                    .padding([.leading, .trailing], 16)
                    .padding(.top, 50)
                Button(action: {
                    fetchTodos()
                }) {
                    Text("Execute")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding()

                List(viewModel.todos, id: \.id) { todo in
                    TodoRow(todo: todo)
                }
            }
            .padding([.leading, .trailing], 0)
            .navigationTitle("Example of AWS")
        }
    }

    func fetchTodos() {
        viewModel.fetchTodos { result in
            switch result {
            case .success:
                print("Todos fetched successfully")
            case .failure(let error):
                print("Failed to fetch todos: \(error.localizedDescription)")
            }
        }
    }
}

struct TodoRow: View {
    var todo: Todo

    var body: some View {
        HStack {
            Text(todo.name)
                .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
