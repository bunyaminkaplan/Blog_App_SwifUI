//
//  HomePageView.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 22.05.2024.
//

import SwiftUI
import Cloudinary

let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "dahnnnwts", apiKey: "232443663459449", apiSecret: "4rFu-YVSX7lCwQ4R5c1hAIjDI_A"))

@Observable
class RefreshObservableObject {
    var data = [String : Any]()
    
    func fetchData(username: String) async {
        do{
            let _data = try await aioViewModelClass().getAioObjects(objectsUrl: URL(string: "http://127.0.0.1:8000/api_server/aio?format=json")!, currentUsername: username)
            DispatchQueue.main.async {
                self.data = _data
            }
            
        }catch {
            print(error)
        }
        
    }
}


struct HomePageView: View {
    @State private var refresh_object = RefreshObservableObject()
    @State var toggle_delete = Bool()
    var aioService = homePageService()
    var currentUserName : String
    var csrfToken: String
    init(currentUserName : String , csrfToken: String){
        self.currentUserName = currentUserName
        self.csrfToken = csrfToken
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                if (refresh_object.data["aioList"] != nil) {
                    
                    List {
                        
                        ForEach(refresh_object.data["aioList"] as! [aioViewModel]){ eachPost in
                            
                            
                            if eachPost.imageAdded {
                                PostCellView(imageURL: URL(string: eachPost.imageUrl!)!, title: eachPost.title, index: eachPost.index , pushed_by: eachPost.owner, delete: true)
                                    .background(Color.clear)
                                    .listRowBackground(Color.white.opacity(0.5))
                                    .listRowBackground(RoundedRectangle(cornerRadius: 100))
                            }else {
                                PostCellViewWithoutImage(title: eachPost.title, index: eachPost.index , pushed_by: eachPost.owner, delete: true)
                                    .background(Color.clear)
                                    .listRowBackground(Color.white.opacity(0.5))
                                    .listRowBackground(RoundedRectangle(cornerRadius: 100))
                            }
                            
                            
                                
                            
                            if (refresh_object.data["ownPosts"] as! [Int]).contains(eachPost.genCode) {
                                
                                Button {
                                    Task {
                                        if currentUserName == eachPost.owner {
                                            let deleteRequestURL = URL(string: "http://127.0.0.1:8000/api_server/user_posts/\(eachPost.specs_id)")!
                                            do{
                                                try await aioService.deleteRequest(deleteRequestUrl: deleteRequestURL, csrf_token: self.csrfToken)
                                                
                                                cloudinary.createManagementApi().destroy("images/\(eachPost.owner)/\(eachPost.genCode)")
                                                
                                                await refresh_object.fetchData(username: currentUserName)
                                                
                                            }catch {
                                                print(error)
                                            }
                                        }
                                    }
                                } label: {
                                    Text("delete")
                                }
                            }
                        }
                    }
                    .background(ignoresSafeAreaEdges: .all)
                    .backgroundStyle(Color.clear)
                    
                    .frame(width: 350 , height: 680 , alignment: .bottom)
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                    .listRowSpacing(20)
                    
                    
                    
                        
                }else {
                        Text("Tap Refresh Button")
                            .foregroundStyle(Color.black)
                            .offset(y:-250)
                            
                }
            }
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
                        // 42, 157, 143
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .background(ignoresSafeAreaEdges: .all)
            
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await refresh_object.fetchData(username: currentUserName)
                    }
                    
                } label: {
                    
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 35 , height: 35)
                        .foregroundStyle(Color.black)
                    
                }

            }
            
        }
        .background(ignoresSafeAreaEdges: .all)
        .navigationTitle("<home_page/>")
    }
}

#Preview {
    HomePageView(currentUserName: "benjamin", csrfToken: "dummy data")
}
