//
//  SuggestsPageView.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 29.05.2024.
//

import SwiftUI
import Foundation

struct SuggestsPageView: View {
    @ObservedObject var SuggestsVM = SuggestViewModelClass()
    @ObservedObject var Following_Status_Class = check_and_send_follow_requests()
    
    let currentUsername : String
    let csrfToken : String
    init(currentUsername : String , csrfToken : String){
        self.csrfToken = csrfToken
        self.currentUsername = currentUsername
    }
    
    var body: some View {
    
        let checked_trackers = Following_Status_Class.follow_status_dict
        let suggestsList = SuggestsVM.suggestsList
        
        NavigationStack {
        
            VStack{
                
                ForEach(suggestsList){ s in
                
                    if checked_trackers.isEmpty != true {
                        
                        HStack{
                            
                            Image(systemName: "person.crop.circle")
                                .foregroundStyle(Color.black)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                            Text(String(s.suggest_name))
                                .foregroundStyle(Color.black)
                            
                                
                            Spacer()
                            Spacer()
                            
                            Button {
                                let request_owner = checked_trackers[s.suggest_name]?["request_owner"] as! String
                                let status = checked_trackers[s.suggest_name]?["status"] as! String
                                let method = checked_trackers[s.suggest_name]?["method"] as! String
                                let request_receiver = s.suggest_name
                                let request_id = checked_trackers[s.suggest_name]?["id"] as! Int
                                
                                Task{
                                    
                                    try await Following_Status_Class.send_request(
                                        request_owner: request_owner,
                                        status: status,
                                        method: method,
                                        request_receiver: request_receiver,
                                        request_id: request_id,
                                        csrf_token: csrfToken )

                                }

                            } label: {
                                
                                Text(checked_trackers[s.suggest_name]?["status"] as! String)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    .frame(width: 90, height:  35, alignment: .center )
                                    .foregroundStyle(Color.white)
                                    .background()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    
                            }
                            
                        }
                        .background(Color.white.opacity(0.5))
                        .padding()
                        .border(Color.white.opacity(0.5) , width: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        
                        
                    }else {
                        Text("loading")
                    }
                    
                }
            }
            .navigationTitle("<find someone/>")
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .padding(50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        create_RGB_code(r: 231, g: 111, b: 81),
                        create_RGB_code(r: 244, g: 162, b: 97),
                        create_RGB_code(r: 233, g: 196, b: 106),
                        create_RGB_code(r: 42, g: 157, b: 143),
                        create_RGB_code(r: 38, g: 70, b: 83)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .task {
                
                await SuggestsVM.getSuggestObjects(suggestsUrl: URL(string: "http://127.0.0.1:8000/api_server/suggests")!)
                
                await Following_Status_Class.create_following_status_dict(currentUsername: currentUsername)
                
            }
        }
    }
}

#Preview {
    SuggestsPageView(currentUsername: "benjamin", csrfToken: "dummy")
}
