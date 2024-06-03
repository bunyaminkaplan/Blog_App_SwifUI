//
//  ViewModel.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 21.05.2024.
//

import Foundation
import SwiftUI

class TrackerViewModelClass: ObservableObject {
    
    @Published var trackersList = [TrackerViewModel]()
    
    func getTrackerObjects(trackerUrl: URL) async {
        let WebService = TrackerWebService()

        do {
            let trackers = try await WebService.getRequest(trackerUrl: trackerUrl)
            
            if let trackers = trackers {
                let trackersList = trackers.map(TrackerViewModel.init)
                
                DispatchQueue.main.async {
                    self.trackersList = trackersList
                }
            }
        } catch {
            print(error)
        }
    }
}

struct TrackerViewModel: Identifiable {
    let model: tracker_object
    
    var id: Int {
        model.id
    }
    
    var request_owner: String {
        model.requestOwner
    }
    
    var request_receiver: String {
        model.requestReceiver
    }
    
    var still: Bool {
        model.still
    }
}

class SuggestViewModelClass : ObservableObject {
    @Published var suggestsList = [SuggestViewModel]()
    
    func getSuggestObjects(suggestsUrl: URL) async {
        
        let WebService = suggestsWebService()
        
        do {
            let suggests = try await WebService.getRequest(objectsUrl: suggestsUrl)
            
            if let suggests = suggests {
                let suggestsList = suggests.map(SuggestViewModel.init)
                
                DispatchQueue.main.async {
                    self.suggestsList = suggestsList
                }
            }
        }catch {
            print(error)
        }
    }
}

struct SuggestViewModel: Identifiable {
    let model : suggest_object
    
    var id: Int {
        model.id
    }
    
    var suggest_name: String {
        model.username
    }
}

class aioViewModelClass{
    var published_infos = ["aioList" : [aioViewModel]() , "ownPosts" : [Int]()] as [String : Any]
    private var ownPostsList = [Int]()
    private var aioObjectsList = [aioViewModel]()
    private var _aioObjectsList = [aioViewModel]()
    private var posts_ids = Set<Int>()
    private var posts_ids_dict = [Int : Bool]()
    
    @ObservedObject var TrackerVM = TrackerViewModelClass()
    
    func getAioObjects(objectsUrl: URL , currentUsername: String) async throws -> [String : Any] {
        
        
        //print("currentUsername from LoginPage: \(currentUsername)")
        let WebService = homePageService()
        
        do{
            let aioObjects = try await WebService.getRequest(objectsUrl: objectsUrl)
            
            if let aioObjects = aioObjects {
                aioObjectsList = aioObjects.map(aioViewModel.init)
                
                
                
                await TrackerVM.getTrackerObjects(trackerUrl: URL(string: "http://127.0.0.1:8000/api_server/following_trackers")!)
                //                print("\(TrackerVM.trackersList)\n")
                for t in TrackerVM.trackersList {
                    if t.request_owner == currentUsername && t.still == true {
                        for o in self.aioObjectsList {
                            //                            print("o: \(o.owner)")
                            //                            print("t: \(t.request_receiver)")
                            if o.owner == t.request_receiver{
                                print(self.posts_ids.insert(o.id).inserted)
                                print(self.posts_ids)
                            }
                            if o.owner == currentUsername {
                                self.ownPostsList.append(o.genCode)
                            }
                        }
                    }
                }
                for id in posts_ids {
                    self.posts_ids_dict.updateValue(false, forKey: id)
                }
                
                for o in aioObjectsList {
                    if posts_ids.contains(o.id){
                        
                        if posts_ids_dict[o.id] == false {
                            self._aioObjectsList.append(o)
                            posts_ids_dict.updateValue(true, forKey: o.id)
                            
                        }
                        //print(posts_ids_dict)
                    }
                }
                
                
                self._aioObjectsList = self._aioObjectsList.sorted { $0.addedAt > $1.addedAt }
                
                //print("aio_objects_list: \(self._aioObjectsList)\n")
                self.published_infos["aioList"] = self._aioObjectsList
                self.published_infos["ownPosts"] = self.ownPostsList
            }
        }catch {
            print(error)
        }
        return published_infos
    }
}

struct aioViewModel: Identifiable {
    let model : aio_object
    
    var id: Int {
        model.id
    }
    var imageUrl : String? {
        model.image
    }
    var addedAt: String {
        model.addedAt
    }
    var owner: String {
        model.specs.whoPushed
    }
    var title: String {
        model.specs.title
    }
    var index: String {
        model.specs.index
    }
    var likeCount: Int {
        model.specs.likeCount
    }
    var imageAdded: Bool {
        model.specs.imageAdded
    }
    var genCode: Int {
        model.specs.generatedCode
    }
    var specs_id: Int {
        model.specs.id
    }
    
    
}

class check_and_send_follow_requests: ObservableObject {
    
    @ObservedObject var TrackersVM = TrackerViewModelClass()
    @ObservedObject var SuggestsVM = SuggestViewModelClass()
    @Published var follow_status_dict = [String: [String: Any]]()
    let TrackerService = TrackerWebService()
    
    func create_following_status_dict(currentUsername: String) async {
        await SuggestsVM.getSuggestObjects(suggestsUrl: URL(string: "http://127.0.0.1:8000/api_server/suggests")!)
        await TrackersVM.getTrackerObjects(trackerUrl: URL(string: "http://127.0.0.1:8000/api_server/following_trackers")!)
        let trackersList = TrackersVM.trackersList
        let suggestsList = SuggestsVM.suggestsList
        var trackers_receivers_names_list = [String]()
        var trackers_receivers_dict = [String : [String : Any]]()
        
        for t in trackersList{
            if t.request_owner == currentUsername{
                trackers_receivers_names_list.append(t.request_receiver)
                trackers_receivers_dict.updateValue(["still" : t.still , "id" : t.id ], forKey: t.request_receiver)
                //print(trackers_receivers_names_list) success
            }
        }
        
        for s in suggestsList {
            let s_key = s.suggest_name
            //print(s_key) success
            if trackers_receivers_names_list.contains(s_key){
                //print(s_key) success
                if trackers_receivers_dict[s_key]!["still"] as! Bool == true {
                    let s = ["request_owner" : currentUsername ,
                            "status" : "unfollow" ,
                            "method" : "PUT" ,
                             "id" : trackers_receivers_dict[s_key]!["id"] as! Int] as [String : Any]
                    //print(s) success
                    DispatchQueue.main.async {
                        //print(s) success
                        self.follow_status_dict.updateValue( s ,forKey: s_key)
                        //print(self.follow_status_dict) kinda success
                        
                    }
                    
                }else {
                    let s = ["request_owner" : currentUsername ,
                             "status" : "follow" ,
                             "method" : "PUT" ,
                             "id" : trackers_receivers_dict[s_key]!["id"] as! Int] as [String : Any]
                    
                    DispatchQueue.main.async {
                        self.follow_status_dict.updateValue(s ,forKey: s_key)
                    }
                }
            }else {
                let s = ["request_owner" : currentUsername ,
                         "status" : "follow" ,
                         "method" : "POST",
                         "id" : trackers_receivers_dict[s_key]!["id"] as! Int] as [String : Any]
                
                DispatchQueue.main.async {
                    self.follow_status_dict.updateValue( s , forKey: s_key)
                    
                }
            }
        }
    }
    
    func send_request(request_owner : String , status : String , method : String , request_receiver : String , request_id : Int , csrf_token : String) async throws  {
        
        if method == "POST" {
            print("post")
            let postURL = URL(string: "http://127.0.0.1:8000/api_server/following_trackers")!
            try await TrackerService.postRequest(postRequestUrl: postURL,
                                                 postRequestParameters:[ "request_owner" : request_owner ,
                                                                         "request_receiver" : request_receiver ] , 
                                                 csrf_token: csrf_token)
            
            follow_status_dict.updateValue(["status" : "unfollow" , 
                                            "method" : "PUT" ,
                                            "request_owner" : request_owner ,
                                            "request_receiver" : request_receiver,
                                            "id" : request_id
                                           ],
                                           forKey: request_receiver)
            
        }else if method == "PUT" {
            print("put")
            let putURL = URL(string: "http://127.0.0.1:8000/api_server/following_trackers/\(request_id)")!
            var toggle_still = true
            var toggle_status = "follow"
            
            if status == "follow" {
                toggle_status = "unfollow"
                toggle_still = true
                
            }else if status == "unfollow" {
                toggle_status = "follow"
                toggle_still = false
            }
            
            try await TrackerService.putRequest(putRequestUrl: putURL,
                                                putRequestParameters:
                                                    [
                                                        "request_owner" : request_owner,
                                                        "request_receiver" : request_receiver,
                                                        "still" : toggle_still
                                                    ] , csrf_token: csrf_token
                                                )
            
            follow_status_dict.updateValue([
                                            "status" : toggle_status,
                                            "request_owner" : request_owner ,
                                            "request_receiver" : request_receiver,
                                            "method" : "PUT",
                                            "id" : request_id
                                            ], forKey: request_receiver)
                                            
        }
    }
}

func create_RGB_code(r: Double , g: Double , b: Double) -> Color {
    return Color(red: r/255, green: g/255, blue: b/255)
}

func return_black_placeholder(ph: String) -> String {
    return String(ph.localizedCapitalized)
}
