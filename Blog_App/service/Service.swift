//
//  Service.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 21.05.2024.
//

import Foundation
import SwiftSoup
import SwiftUI

class TrackerWebService {

    func getRequest(trackerUrl: URL) async throws -> [tracker_object]? {
        let (data, _) = try await URLSession.shared.data(from: trackerUrl)
        let trackers = try JSONDecoder().decode([tracker_object].self, from: data) 
        return trackers
    }

    func putRequest(putRequestUrl : URL  , putRequestParameters : [String : Any] , csrf_token : String) async throws {
        var request = URLRequest(url: putRequestUrl)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: putRequestParameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("JSON serialization failed: \(error.localizedDescription)")
            throw error
        }
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                print(String(data: data, encoding: .utf8) ?? "error data serialization either")
                throw URLError(.badServerResponse)
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(jsonResponse)")
            } catch {
                print("JSON deserialization failed: \(error.localizedDescription)")
                throw error
            }
        } catch {
            print("Network request failed: \(error.localizedDescription)")
            throw error
        }
    }

    func postRequest(postRequestUrl : URL  , postRequestParameters : [String : Any] , csrf_token : String) async throws {
        var request = URLRequest(url: postRequestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postRequestParameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("JSON serialization failed: \(error.localizedDescription)")
            throw error
        }
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                throw URLError(.badServerResponse)
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(jsonResponse)")
            } catch {
                print("JSON deserialization failed: \(error.localizedDescription)")
                throw error
            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
    }
    
}

class suggestsWebService {
    
    func getRequest(objectsUrl: URL) async throws -> [suggest_object]? {
        let (data, _) = try await URLSession.shared.data(from: objectsUrl) //Session uzerinden data alacagimizi belirtiyoruz url de vererek
        let objects = try JSONDecoder().decode([suggest_object].self, from: data) // aldigimiz json dosyasini decodera gereken iki parametresi ile veriyoruz
        
        // 1.si ayiklanma bicimi olan model 2.si nereden hangi dosyadan oldugunu belirtmek
        return objects
    }
}

class signupPageService {
    
    func postRequest(postRequestUrl : URL  , username : String , password : String ,password2 : String, csrf_token: String) async throws -> Bool {
        var request = URLRequest(url: postRequestUrl)
        var is_authenticated = true
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
        let user_credentials = "username=\(username)&password1=\(password)&password2=\(password2)"
        let _user_credentials = user_credentials.data(using: .utf8)!
        request.httpBody = _user_credentials
        
        
        let session = URLSession.shared
        
        do {
            let (data, _) = try await session.data(for: request)
            let string_html = String(data: data, encoding: .utf8)!
            //print(string_html)
            let doc: Document = try SwiftSoup.parse(string_html)
            //print(try doc.text())
            if try doc.text() == "BLOG APP_BLOG Home New Login Register Logout Username: Password: Password confirmation: Signup" {
                is_authenticated = false
            }
            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                is_authenticated = false
//                print("Server error!")
//                throw URLError(.badServerResponse)
//            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
        
        return is_authenticated
    }
    
    func getRequest(requestUrl: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: requestUrl) //Session uzerinden data alacagimizi belirtiyoruz url de vererek
        var csrf_token_ = String()
        do {
            
            let string_html = String(data: data, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(string_html)
                let link: Elements = try doc.select("input")
                csrf_token_ = try link.attr("value")
                
                print(csrf_token_)
            } catch Exception.Error(_, let message) {
                print(message)
            }
            
            return csrf_token_
        }
    }
}

class loginWebService {
    
    func postRequest(postRequestUrl : URL  , username : String , password : String , csrf_token: String) async throws -> Bool {
        var request = URLRequest(url: postRequestUrl)
        var is_authenticated = true
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
        let user_credentials = "username=\(username)&password=\(password)"
        let _user_credentials = user_credentials.data(using: .utf8)!
        request.httpBody = _user_credentials
        
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            let string_html = String(data: data, encoding: .utf8)!
            
            let doc: Document = try SwiftSoup.parse(string_html)
               let link: Element = try doc.select("a").first()!
               let text: String = try doc.body()!.text() // "An example link."
            if text == "APP_BLOG Home New Login Register Logout Username: Password: Login" {
                is_authenticated = false
            }
            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                is_authenticated = false
//                print("Server error!")
//                throw URLError(.badServerResponse)
//            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
        
        return is_authenticated
    }
    
    func getRequest(requestUrl: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: requestUrl) //Session uzerinden data alacagimizi belirtiyoruz url de vererek
        var linkHref = String()
        do {
            
            let string_html = String(data: data, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(string_html)
                let html_string =  try doc.html()
                let link: Elements = try doc.select("input")
                linkHref = try link.attr("value")
                
                print(linkHref)
            } catch Exception.Error(_, let message) {
                print(message)
            }
            
            return linkHref
        }
    }
}

class logoutWebService {
    func postRequest(postRequestUrl : URL , csrf_token: String) async throws -> Bool  {
        var request = URLRequest(url: postRequestUrl)
        var is_loggedout = true
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                is_loggedout = false
                print("Server error!")
                throw URLError(.badServerResponse)
            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
    
        return is_loggedout
    }
    
}

class homePageService {
       
    func getRequest(objectsUrl: URL) async throws -> [aio_object]? {
        
        let (data, _) = try await URLSession.shared.data(from: objectsUrl) //Session uzerinden data alacagimizi belirtiyoruz
        let objects = try JSONDecoder().decode([aio_object].self, from: data) // aldigimiz json dosyasini decodera gereken iki parametresi ile veriyoruz
        //print(objects.first ?? "no value here")
        return objects
    }
    
    func deleteRequest(deleteRequestUrl : URL , csrf_token: String) async throws {
        var request = URLRequest(url: deleteRequestUrl)
        request.httpMethod = "DELETE"
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
 
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                print(String(data: data, encoding: .utf8) ?? "error data serialization either")
                
                throw URLError(.badServerResponse)
            }
            
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
    }
}

class addPageService {
    
    func getRequest(requestUrl: URL) async throws -> [String : Any] {
        let (data, _) = try await URLSession.shared.data(from: requestUrl) //Session uzerinden data alacagimizi belirtiyoruz url de vererek
        var add_page_infos = [String : Any]()
        
        do {
            let string_html = String(data: data, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(string_html)
                //let html_string =  try doc.html()
                let input_tag_array = try doc.select("input").array()
                let gen_code = Int(try input_tag_array[5].attr("value"))
                let csrf_token = try input_tag_array[0].attr("value")
                let current_user_username = try input_tag_array[4].attr("value")
                add_page_infos.updateValue(gen_code ?? 000, forKey: "genCode")
                add_page_infos.updateValue(csrf_token, forKey: "csrfToken")
                add_page_infos.updateValue(current_user_username, forKey: "currentUser")
                print(add_page_infos)
            } catch Exception.Error(_, let message) {
                print(message)
            }
            
            return add_page_infos
        }
    }
        
    func postRequestImage(postRequestUrl : URL  , username: String , generated_code: Int , uploadedUrl: String , csrf_token: String) async throws -> imagePostResponseJson{
        var jsonResponse : imagePostResponseJson
        var request = URLRequest(url: postRequestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")

        let postRequestParameters : [String : Any] = ["current_user_username" : username , "generated_code" : generated_code , "uploaded_url" : uploadedUrl]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postRequestParameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("JSON serialization failed: \(error.localizedDescription)")
            throw error
        }
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                throw URLError(.badServerResponse)
            }
            
            do {
                jsonResponse = try JSONDecoder().decode(imagePostResponseJson.self, from: data)
                print("Response JSON: \(jsonResponse)")
                
            } catch {
                print("JSON deserialization failed: \(error.localizedDescription)")
                throw error
            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
        return jsonResponse
    }
    
    func postRequestUserPost(postRequestUrl : URL  , owner: String , title: String , index: String , imageAdded: Bool , generated_code: Int , csrf_token: String) async throws -> userPostResponseJson{
        var request = URLRequest(url: postRequestUrl)
        let jsonResponse : userPostResponseJson
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")
        
        let postRequestParameters : [String : Any] = ["who_pushed" : owner , "title" : title , "index": index , "image_added": imageAdded ,  "generated_code" : generated_code ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postRequestParameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("JSON serialization failed: \(error.localizedDescription)")
            throw error
        }
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                print(String(data: data, encoding: .utf8) ?? "error data serialization either")
                
                throw URLError(.badServerResponse)
            }
            
            do {
                jsonResponse = try JSONDecoder().decode(userPostResponseJson.self, from: data)
                print("Response JSON: \(jsonResponse)")
            } catch {
                print("JSON deserialization failed: \(error.localizedDescription)")
                throw error
            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }
        return jsonResponse
    }
    
    func postRequestAIO(postRequestUrl : URL  , specsFK: Int , imageFK: Int , generated_code: Int , csrf_token: String) async throws -> aioResponseJson{
        var request = URLRequest(url: postRequestUrl)
        let jsonResponse : aioResponseJson
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(csrf_token, forHTTPHeaderField: "X-CSRFToken")

        
        let postRequestParameters : [String : Any] = ["specs" : specsFK , "image" : imageFK , "generated_code" : generated_code ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postRequestParameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("JSON serialization failed: \(error.localizedDescription)")
            throw error
        }
        
        let session = URLSession.shared
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error!")
                print(String(data: data, encoding: .utf8) ?? "error data serialization either")
                throw URLError(.badServerResponse)
            }
            
            do {
                jsonResponse = try JSONDecoder().decode(aioResponseJson.self, from: data)
                print("Response JSON: \(jsonResponse)")
            } catch {
                print("JSON deserialization failed: \(error.localizedDescription)")
                throw error
            }
        } catch {
            print("Network request failed: \(error)")
            throw error
        }

    
        return jsonResponse
    }
    
       
    }
