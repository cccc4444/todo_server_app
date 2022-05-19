//
//  NetworkService.swift
//  todo-server
//
//  Created by Danylo Kushlianskyi on 10.05.2022.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    let URL_BASE = "http://localhost:3003"
    let URL_ADD_TODO = "/add"
    let URL_DELETE_TODO = "/delete"
    
    // we create a session
    let session = URLSession(configuration: .default)
    

    // use escaping to call closure in ToDoVC 
    func getToDos(_ onSuccess: @escaping (ToDoss) -> Void, _ onError: @escaping (String) -> Void){
        let url = URL(string: "\(URL_BASE)")!
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            
            // executing in the main thread
            // if we dont switch here, UI wonf refresh
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                //check if data and response are not nil
                guard let data = data, let response = response as? HTTPURLResponse else{
                    onError("Invalid response")
                    return
                }
                
                // decode and save items if status code is 200
                do {
                    if response.statusCode == 200{
                        let items = try JSONDecoder().decode(ToDoss.self, from: data)
                        onSuccess(items)
                    }
                    else{
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                    
                } catch  {
                    onError(error.localizedDescription)
                }
            }
            
        }).resume() // invoking
        
    }
    
    func addToDo(todo: ToDo,_ onSuccess: @escaping (ToDoss) -> Void, _ onError: @escaping(String) -> Void){
        let url = URL(string: "\(URL_BASE)\(URL_ADD_TODO)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // same in getToDos(), but implicitly
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       
        do {
            let bodyOfTheRequest = try JSONEncoder().encode(todo)
            request.httpBody = bodyOfTheRequest
            
            let task = session.dataTask(with: request) {data, response, error in
                
                DispatchQueue.main.async {
                    if let error = error {
                        onError(error.localizedDescription)
                        return
                    }
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        onError("Invalid data or response")
                        return
                    }
                    
                    do {
                        if response.statusCode == 200{
                            let items = try JSONDecoder().decode(ToDoss.self, from: data)
                            onSuccess(items)
                        }
                        else{
                            let err = try JSONDecoder().decode(APIError.self, from: data)
                            onError("\(err.message), error code: \(response.statusCode)")
                        }
                    } catch {
                        onError(error.localizedDescription)
                    }
                }
                

            }
            task.resume()
        } catch  {
            onError(error.localizedDescription)
        }
       
        
    }
    func deleteTodos(todo: ToDo, _ onSuccess: @escaping(ToDoss) -> Void, _ onError: @escaping(String) -> Void){
        let url = URL(string:"\(URL_BASE)\(URL_DELETE_TODO)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" // same in getToDos(), but implicitly
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let bodyOfTheRequest = try JSONEncoder().encode(todo)
            request.httpBody = bodyOfTheRequest
            
            let task = session.dataTask(with: request) {data, response, error in
                
                DispatchQueue.main.async {
                    if let error = error {
                        onError(error.localizedDescription)
                        return
                    }
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        onError("Invalid data or response")
                        return
                    }
                    
                    do {
                        if response.statusCode == 200{
                            let items = try JSONDecoder().decode(ToDoss.self, from: data)
                            onSuccess(items)
                        }
                        else{
                            let err = try JSONDecoder().decode(APIError.self, from: data)
                            onError("\(err.message), error code: \(response.statusCode)")
                        }
                    } catch {
                        onError(error.localizedDescription)
                    }
                }
                

            }
            task.resume()
            
        }
        catch {
            onError(error.localizedDescription)
        }
    }
    

}
