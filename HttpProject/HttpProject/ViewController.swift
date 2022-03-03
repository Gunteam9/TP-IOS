//
//  ViewController.swift
//  HttpProject
//
//  Created by tplocal on 11/02/2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoService.todos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoViewCell;
        let todo = TodoService.todos[indexPath.row];
        
        print("here");
        cell.idLabel?.text = todo.id.description;
        cell.taskLabel?.text = todo.title;
        cell.IsCompleted?.setOn(todo.completed, animated: false);

        return cell;
    }
    
}

// Les Runtime Exception n'existe pas vraiment en swift
enum RuntimeException: Error {
    case runtimeError(String)
}

class TodoService {
    private(set) public static var todos = [JsonPlaceHolderTodoOne]();
    
    init() {
        for i in 1...10 {
            Task.init {
                let cell = await getJsonFromURL(url: "https://jsonplaceholder.typicode.com/todos/\(i)");
                TodoService.todos.append(cell as! JsonPlaceHolderTodoOne);
            }
        }
    }
    
    
    
    func getTextFromURL(url: String) async {
        let data: Data? = await executeRequest(urlString: url);
        if data != nil {
            let str = String(data: data!, encoding: .utf8);
            print("Str: ", str!);
        }
    }
    
    func getJsonFromURL(url: String) async -> Any? {
        // On execute la requête puis on print les données en brut
        let data: Data? = await executeRequest(urlString: url);
        print(String(data: data!, encoding: .utf8)!);
        if data != nil {
            let jsonDecoder = JSONDecoder();
            do {
                // On décode le Json pour le lire facilement
                let todoOne = try jsonDecoder.decode(JsonPlaceHolderTodoOne.self, from: data!);
                print(todoOne.description);
                return todoOne;
            } catch {
                print(error);
            }
        }
        return nil;
    }
    
    
    func executeRequest(urlString: String) async -> Data? {
        // Créer l'URL d'où viennent les données
        let url = URL(string: urlString);
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url!));
            let statusCode: Int = (response as? HTTPURLResponse)!.statusCode;
            // On check si la request est un succès
            guard statusCode >= 200 && statusCode < 300 else
                {
                    // Si ce n'est pas le cas, on stop le programme
                    throw RuntimeException.runtimeError("HTTP Error " + String(statusCode));
                }
            // Si c'est le cas, on return les données récupérées
            return data;
        } catch {
            print("Error: ", error);
        }
        
        return nil;
    }
}
    
class JsonPlaceHolderTodoOne: Decodable, CustomStringConvertible {
    let userId: Int;
    let id: Int;
    let title: String;
    let completed: Bool;
    
    // Equivalent du toString de Java
    public var description: String {
        return "JsonPlaceHolderTodoOne{userId: \(userId), id:\(id), title: \(title), completed: \(completed)}"}
}

