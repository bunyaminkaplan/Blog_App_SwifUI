//
//  ContentView.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 21.05.2024.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    @ObservedObject var FollowingTrackerVM = FollowingTrackerViewModelClass()
    @ObservedObject var SuggestsVM = SuggestViewModelClass()
    let FollowingTrackerService = followingTrackerWebService()
    let SuggestService = suggestsWebService()
    let LoginService = loginWebService()
    
    //    init(viewModel: FollowingTrackerViewModel, service: followingTrackerWebService) {
    //        self.viewModel = viewModel
    //        self.service = service
    //    }
    
    
    var body: some View {
        VStack {
            
            VStack {
                ForEach(SuggestsVM.suggestsList) { suggest in
                    HStack{
                        Text(suggest.suggest_name)
                        Button {
                            
                        } label: {
                            Text("follow")
                        }
                    }
                }
            }
        }
        .task {
            let suggests_url = URL(string: "http://127.0.0.1:8000/api_server/suggests?format=json")!
            await SuggestsVM.getSuggestObjects(suggestsUrl: suggests_url)
        }
        .padding()
        
        
        VStack {
            Button {
                Task {
                    //try await LoginService.postRequest(postRequestUrl: URL(string: "http://127.0.0.1:8000/login/")!, postRequestParameters: loginParameters)
                    let csrf_token = try await LoginService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/login/")!)
                    let loginParameters : [String : Any] = [
                        
                        
                        "username" : "benjamin",
                        "password" : "BnymN99",
                                                
                    ]
                    //try await LoginService.postRequest(postRequestUrl: URL(string: "http://127.0.0.1:8000/login/")!, postRequestParameters: loginParameters , csrf_token: csrf_token)
                }
                
            }
        label: {
            Text("login")
            }
        }
    }
    
    //#Preview {
    //    ContentView()
    //}
}
