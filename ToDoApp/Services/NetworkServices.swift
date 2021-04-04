//
//  NetworkServices.swift
//  ToDoApp
//
//  Created by Fernando Carneiro on 29/12/20.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    let URL_BASE = "http://192.168.0.15:3003"
    let URL_ADD_TODO = "/add"
    let session = URLSession(configuration: .default)
    
    func getTodos(onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        
        let url = URL(string: "\(URL_BASE)")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data,  let response = response as? HTTPURLResponse else {
                    onError("Invalid data or reponse")
                    return}
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Todos.self, from: data)
                        onSuccess(items)
                        //handle success
                    } else {
                        let erro = try JSONDecoder().decode(APIError.self, from: data)
                        //handle error
                        onError(erro.message)
                    }
                    
                } catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func addTodo(todo: Todo, onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void){
        let url = URL(string: "\(URL_BASE)\(URL_ADD_TODO)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Avisando ao servidor o tipo de request (json):
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        do {
            let body = try JSONEncoder().encode(todo)
            request.httpBody = body
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                     
                    if let error = error{
                        onError(error.localizedDescription)
                        return
                    }
                    
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        onError("Invalid data or reponse")
                        return
                    }
                    
                    do {
                        debugPrint(response.statusCode)
                        if response.statusCode == 200{
                            
                            let items = try JSONDecoder().decode(Todos.self, from: data)
                            onSuccess(items)
                        }else{
                            let erro = try JSONDecoder().decode(APIError.self, from: data)
                            onError(erro.message)
                            
                        }
                    
                        //onError(error.localizedDescription)
                        
                        
                    } catch DecodingError.keyNotFound(let key, let context) {
                        Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                    } catch DecodingError.valueNotFound(let type, let context) {
                        Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                    } catch DecodingError.typeMismatch(let type, let context) {
                        Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                    } catch DecodingError.dataCorrupted(let context) {
                        Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                    } catch let error as NSError {
                        NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                   
                        
                        
                    }
                    
                }
            }
            task.resume()
            
        } catch {
            onError(error.localizedDescription)
        }
        
    }
}
