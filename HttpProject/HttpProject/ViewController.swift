//
//  ViewController.swift
//  HttpProject
//
//  Created by tplocal on 11/02/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.init {
            await getTextFromURL(url: "https://eddbali.net/files/texte.txt");
            // Un autre URL que la météo pour éviter de créer un compte sur un site random
            await getJsonFromURL(url: "https://jsonplaceholder.typicode.com/todos/1");
        }
        
    }
    
    func getTextFromURL(url: String) async {
        let data: Data? = await executeRequest(urlString: url);
        if data != nil {
            let str = String(data: data!, encoding: .utf8);
            print("Str: ", str!);
        }
    }
    
    func getJsonFromURL(url: String) async {
        // On execute la requête puis on print les données en brut
        let data: Data? = await executeRequest(urlString: url);
        print(String(data: data!, encoding: .utf8)!);
        if data != nil {
            let jsonDecoder = JSONDecoder();
            do {
                // On décode le Json pour le lire facilement
                let todoOne = try jsonDecoder.decode(JsonPlaceHolderTodoOne.self, from: data!);
                print(todoOne.description);
            } catch {
                print(error);
            }
        }
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

// Les Runtime Exception n'existe pas vraiment en swift
enum RuntimeException: Error {
    case runtimeError(String)
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

