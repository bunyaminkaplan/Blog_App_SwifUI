//
//  LoginScreenView.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 22.05.2024.
//

import SwiftUI

struct LoginPageView: View {
    @State var username : String = ""
    @State var password : String = ""
    let LoginService = loginWebService()
    let LogoutService = logoutWebService()
    @State var is_authenticated = false
    @State var is_loggedout = true
    @State var wrong_input = false
    @State var csrf_token : String?
    
    var body: some View {
        NavigationView {
            
            ZStack{
                VStack{
                    if is_authenticated == false && is_loggedout == true {
                        
                        
                        Text("username")
                            .frame(maxWidth: .infinity ,alignment: .leading)
                            .offset(x: 10, y: 4)
                            .foregroundStyle(Color.black)
                        
                        TextField( "username", text: $username)
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
                        
                        
                        
                        
                        Text("password")
                            .frame(maxWidth: .infinity ,alignment: .leading)
                            .offset(x: 10, y: 4)
                            .foregroundStyle(Color.black)
                            .padding(EdgeInsets(top: 30, leading: 0 ,bottom: 0, trailing: 0))
                        
                        
                        
                        TextField("", text: $password)
                            .foregroundStyle(Color.black)
                            .background(Color.white.opacity(0.5))
                            .padding(10)
                            .textInputAutocapitalization(.never)
                            .border(Color.white.opacity(0.5) , width: 10)
                            .textFieldStyle(.automatic)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                            .foregroundStyle(Color.black)
                        
                        
                        
                        
                        Button {
                            Task {
                                //try await LoginService.postRequest(postRequestUrl: URL(string: "http://127.0.0.1:8000/login/")!, postRequestParameters: loginParameters)
                                let csrf_token = try await LoginService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/login/")!)
                                
                                
                                self.is_authenticated = try await LoginService.postRequest(postRequestUrl: URL(string: "http://127.0.0.1:8000/login/")!, username: username , password: password , csrf_token: csrf_token)
                                print(" is authenticated : \(is_authenticated)")
                                print(" is loggedout : \(is_loggedout)")
                                
                                if is_authenticated == true {
                                    self.wrong_input = false
                                    self.is_loggedout = false
                                }else {
                                    self.wrong_input = true
                                }
                                
                                
                            }
                        } label: {
                            Text("Login")
                                .padding(10)
                                .background()
                                .backgroundStyle(Color.white.opacity(0.7))
                                .foregroundStyle(.black)
                                .border(Color.white.opacity(0) , width: 10 )
                                .clipShape(Capsule())
                                .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10 ))
                            
                            
                            
                        }
                        
                        
                        
                        NavigationLink {
                            SignupPageView()
                        } label: {
                            Text("or Signup")
                                .padding(10)
                                .background()
                                .backgroundStyle(Color.white.opacity(0.7))
                                .foregroundStyle(.black)
                                .border(Color.white.opacity(0) , width: 10 )
                                .clipShape(Capsule())
                                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        
                        
                        
                        
                    }else {
                        Spacer()
                        HStack {
                            
                            Spacer()
                            
                            NavigationLink {
                                if self.csrf_token != nil {
                                    HomePageView(currentUserName: username , csrfToken: self.csrf_token!)
                                }
                            } label: {
                                Image(systemName: "house")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100 , height: 100)
                                    .foregroundStyle(Color.white)
                                
                                
                                
                            }.task {
                                do{
                                    self.csrf_token = try await LoginService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/login/")!)
                                }catch {
                                    print(error)
                                }
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                AddPageView()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100 , height: 100)
                                    .foregroundStyle(Color.white)
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            
                            
                            
                            NavigationLink {
                                if self.csrf_token != nil {
                                    SuggestsPageView(currentUsername: username , csrfToken: self.csrf_token!)
                                }
                            } label: {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100 , height: 100)
                                    .foregroundStyle(Color.white)
                            }.task {
                                do{
                                    self.csrf_token = try await LoginService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/login/")!)
                                }catch {
                                    print(error)
                                }
                                
                            }
                            
                        }
                        Spacer()
                        HStack{
                            Text("Welcome \(username)")
                            
                            Spacer()
                            
                            Button {
                                Task{
                                    let csrf_token = try await LoginService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/login")!)
                                    self.is_loggedout = try await LogoutService.postRequest(postRequestUrl: URL(string: "http://127.0.0.1:8000/logout/")!, csrf_token: csrf_token)
                                    if is_loggedout == true {
                                        self.is_authenticated = false
                                    }
                                }
                            } label: {
                                //rectangle.portrait.and.arrow.forward
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50 , height: 50)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        
                        
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
                
                
                if wrong_input == true {
                    Text("check your informations")
                        .padding(50)
                        .offset(y: 210)
                }

            }
            .navigationTitle("pixel blog")
            
        }
        
        
    }
}

#Preview {
    LoginPageView()
}
