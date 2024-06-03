//
//  testAddPage.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 25.05.2024.
//

import SwiftUI
import Cloudinary
import PhotosUI
import UIKit


struct AddPageView: View {
    let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "yourCloudName", apiKey: "yourApiKey", apiSecret: "yourApiSecret"))
    
    @State private var title_input = String()
    @State private var index_input = String()
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Data?
    @State var post_parameters = [String : Any]()
    let AddPageService = addPageService()
    var body: some View {
        
        
        NavigationStack {
            
            
            
            
            VStack {
                
                Text("title")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .offset(x: 10, y: 4)
                    .foregroundStyle(Color.black)
                
                TextField("title" , text: $title_input)
                    .background(Color.white.opacity(0.5))
                    .padding(10)
                    .textInputAutocapitalization(.never)
                    .border(Color.white.opacity(0.5) , width: 10)
                    .textFieldStyle(.automatic)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .autocorrectionDisabled()
                    .keyboardType(.default)
                    .foregroundStyle(Color.black)
                    .textCase(.lowercase)
                
                Text("index")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .offset(x: 10, y: 4)
                    .foregroundStyle(Color.black)
                
                TextEditor(text: $index_input)
                    .background(content: {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color.purple)
                    })

                    .frame(maxHeight: 130)
                    .padding(10)
                    .textInputAutocapitalization(.never)
                    .border(Color.white.opacity(0.5) , width: 10)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .autocorrectionDisabled()
                    .keyboardType(.default)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.5))
                            //.backgroundStyle(Color.white.opacity(0.5))
                            //.foregroundStyle(Color.white.opacity(0.5))
                            
                    })
                    .foregroundStyle(Color.white)
                    .textCase(.lowercase)
                    
                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Text("Select Image")
                        .padding(10)
                        .background()
                        .backgroundStyle(Color.white.opacity(0.7))
                        .foregroundStyle(.black)
                        .border(Color.white.opacity(0) , width: 10 )
                        .clipShape(Capsule())
                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10 ))
                }
                .onChange(of: avatarItem , perform: { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            avatarImage = data
                        }
                    }
                })
               
                Button {
                    
                    Task {
                        //imageless push will be preset
                        let uploader = cloudinary.createUploader()
                        let params = CLDUploadRequestParams()
                        
                        let folder_name = "images/\(post_parameters["currentUser"] as! String)"
                        params.setPublicId("\(folder_name)/\(post_parameters["genCode"] as! Int)")
                        
                        uploader.upload(data: avatarImage!, uploadPreset: "aluzfrcv" , params: params, completionHandler: { result  , error in
                            print(error?.description)
                            print(result?.description)
                        })

                        let postRequestURL = URL(string: "http://127.0.0.1:8000/api_server/user_posts")!
    //
                        
                        
                        let user_post_object = try await AddPageService.postRequestUserPost(postRequestUrl: postRequestURL, owner: post_parameters["currentUser"] as! String, title: title_input, index: index_input, imageAdded: true, generated_code: post_parameters["genCode"] as! Int , csrf_token: post_parameters["csrfToken"] as! String)
                        
                        let imageUploadedURL =  "https://res.cloudinary.com/dahnnnwts/image/upload/images/\(post_parameters["currentUser"] as! String)/\(post_parameters["genCode"] as! Int)"

                        let imageRequestURL = URL(string: "http://127.0.0.1:8000/api_server/images")!
                        let image_object = try await AddPageService.postRequestImage(postRequestUrl: imageRequestURL, username: post_parameters["currentUser"] as! String, generated_code: post_parameters["genCode"] as! Int, uploadedUrl: imageUploadedURL , csrf_token: post_parameters["csrfToken"] as! String)
                        
                        //print("user_post_object_id: \(user_post_object.id)")
                        //print("image_object_id: \(image_object.id)")
                        
                        let aioRequestURL = URL(string: "http://127.0.0.1:8000/api_server/aio_2")!
                        let _ = try await AddPageService.postRequestAIO(postRequestUrl: aioRequestURL, specsFK: user_post_object.id, imageFK: image_object.id, generated_code: post_parameters["genCode"] as! Int , csrf_token: post_parameters["csrfToken"] as! String)

                    //hicbir yerde sorun olmamasi halinde generated code tekrardan istenecek ya da redirect edilecek
                        
                    }
                    
                } label: {
                    Text("push")
                        .padding(10)
                        .background()
                        .backgroundStyle(Color.white.opacity(0.7))
                        .foregroundStyle(.black)
                        .border(Color.white.opacity(0) , width: 10 )
                        .clipShape(Capsule())
                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10 ))
                }
                
                
                
                
            }
            .navigationTitle("add something")
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .padding(50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        create_RGB_code(r: 231, g: 111, b: 81),
                        create_RGB_code(r: 244, g: 162, b: 97),
                        create_RGB_code(r: 233, g: 196, b: 106),
                        Color(red: 42/255, green: 157/255, blue: 143/255) ,
                        Color(red: 38/255, green: 70/255, blue: 83/255)
                        // 42, 157, 143
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .task {
                do{
                    self.post_parameters = try await AddPageService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/add")!)
                }catch {
                    print(error)
                }
                
            }
            
        }
    }
}
    #Preview {
        AddPageView()
    }

