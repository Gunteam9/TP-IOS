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
        let data: Data? = await executeRequest(urlString: url);
        print("here1");
        print(String(data: data!, encoding: .utf8)!);
        if data != nil {
            let jsonDecoder = JSONDecoder();
            do {
                let todoOne = try jsonDecoder.decode(JsonPlaceHolderTodoOne.self, from: data!);
                print(todoOne.description);
            } catch {
                print(error);
            }
        }
    }
    
    func executeRequest(urlString: String) async -> Data? {
        // Créer l'URL d'où viennent les données
        let url = URL(string: urlString)
        // Créer une session de connexion
//        let session = URLSession(configuration: .default)
//        var res: Data?;
//        // Créer une tâche
//        let tache = session.dataTask(with: url!)
//        { (data, response, error) in
//            if error != nil {
//                print("Error: ", error!);
//                return;
//            } else {
//                if let data = data {
//                    print("here2");
//                    print(String(data: data, encoding: .utf8)!);
//                    res = data;
//                } else {
//                    print("Pas de données");
//                }
//            }
//        }
//        // Lancer la tâche
//        tache.resume()
//
//        return res;

        
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url!));
            let statusCode: Int = (response as? HTTPURLResponse)!.statusCode;
            guard statusCode >= 200 && statusCode < 300 else
                {
                throw RuntimeException.runtimeError("HTTP Error " + String(statusCode));
                }
            return data;
        } catch {
            print("Error: ", error);
        }
        
        return nil;
    }
}

enum RuntimeException: Error {
    case runtimeError(String)
}
    
class JsonPlaceHolderTodoOne: Decodable, CustomStringConvertible {
    let userId: Int;
    let id: Int;
    let title: String;
    let completed: Bool;
    
    public var description: String {
        return "JsonPlaceHolderTodoOne{userId: \(userId), id:\(id), title: \(title), completed: \(completed)}"}
}

