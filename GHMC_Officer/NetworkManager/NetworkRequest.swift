//
//  NetworkRequest.swift
//  RedCross
//
//  Created by IOS User1 on 20/01/20.
//  Copyright © 2020 IOS User1. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD
enum NetworkError: Error {
    case domainError(_ msg : Error)
    case decodingError(_ msg : Error)
}
class NetworkRequest
{
    class func makeRequest<T : Decodable>(type : T.Type , urlRequest : Router , completion : @escaping (Swift.Result<T , NetworkError>)->())
    {
        print("url :- \(urlRequest.urlRequest?.url?.absoluteString)")
        print("headers :- \(String(describing: urlRequest.urlRequest?.allHTTPHeaderFields))")
//        print("Url:- ",urlRequest.urlRequest?.url?.absoluteString as Any)
//        if let jsondata = try? JSONSerialization.jsonObject(with: (urlRequest.urlRequest?.httpBody)!, options: .allowFragments)
//        {
//            print("parameters :- ", jsondata)
//        }
        
        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = urlRequestTimeOutInterval
//        configuration.timeoutIntervalForResource = urlRequestTimeOutInterval
//        let alamoFireManager = Alamofire.SessionManager(configuration: configuration) // not in this line
        //guard Reachability.isConnectedToNetwork() else { self.showAlert(message: NoInternet) ; return }
        DispatchQueue.main.async {
            self.showLoading(text: "Loading")
        }
        Alamofire.request(urlRequest).responseJSON { (response) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
          //  print(response)
         //   print(try! JSONSerialization.jsonObject(with: response.data!, options: .allowFragments))
            guard let data = response.data, response.error == nil else {
                
                if let error = response.error as NSError? {
                print(error)
                    DispatchQueue.main.async {
                        self.hideLoading()
                    }
                     completion(.failure(.domainError(error)))
                }
                return
            }
           
            do {
                let modelData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                     self.hideLoading()
                }
                completion(.success(modelData))
            } catch let err{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                completion(.failure(.decodingError(err)))
            }
        }
    }
    class func makeRequestArray<T : Decodable>(type : T.Type , urlRequest : Router , completion : @escaping (Swift.Result<[T] , NetworkError>)->())
    {
        DispatchQueue.main.async {
            self.showLoading(text: "Loading")
        }
        Alamofire.request(urlRequest).responseJSON { (response) in
            guard let data = response.data, response.error == nil else {
                if let error = response.error as NSError?, error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        self.hideLoading()
                    }
                    completion(.failure(.domainError(error)))
                }
                return
            }
            do {
                let modelData = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                completion(.success(modelData))
            } catch let err{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                completion(.failure(.decodingError(err)))
            }

        }

    }


    class func showLoading(text: String)
    {

        PKHUD.sharedHUD.contentView = PKHUDProgressView(title: nil, subtitle: nil)
        PKHUD.sharedHUD.dimsBackground = true
        PKHUD.sharedHUD.show()

    }
    class func hideLoading() {
        PKHUD.sharedHUD.hide()
    }

}

enum NetworkError1: Error {
    case domainError(_ msg : Error)
    case decodingError(_ msg : Error)
}
enum HTTPMethod : String
{
    case get = "GET"
    case post = "POST"
}
class NetworkManager
{
    class func makeRequest<T : Codable>(type : T.Type , method : HTTPMethod,parameters : [String : Any]?, url : URL ,encoding : JSONEncoding, completion : @escaping (Swift.Result<T , NetworkError1>)->())
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method
        {
        case .get :
            print("get")
            urlRequest.httpMethod = "GET"
        case .post :
            if let parameters = parameters
            {
                if let jsondata = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
                {
                    urlRequest.httpMethod = "POST"
                    urlRequest.httpBody = jsondata
//                    urlRequest.addValue(UserDefaultVars.token!, forHTTPHeaderField:"Auth_token")
                    print(urlRequest)
                }
            }
            print("post method")
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                                        completion(.failure(.domainError(error)))
                }
                return
            }
            do {
                let modelData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(modelData))
            } catch let err{
                completion(.failure(.decodingError(err)))
            }
        }
        task.resume()
    }
}
