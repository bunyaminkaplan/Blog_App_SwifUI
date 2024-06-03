//
//  SignUpPageView.swift
//  Blog_App
//
//  Created by Bünyamin Kaplan on 26.05.2024.
//

import SwiftUI

struct SignupPageView: View {
    @State var username = String()
    @State var password1 = String()
    @State var password2 = String()
    @State var is_authenticated = Bool()
    let signUpService = signupPageService()
    var body: some View {
        
        NavigationStack{
            
            VStack{
                var csrf_token = String()
                
                Text("username")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .offset(x: 10, y: 4)
                    .foregroundStyle(Color.black)
                
                TextField("username" , text: $username)
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
                
                TextField("password" , text: $password1)
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
                
                
                Text("password again")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .offset(x: 10, y: 4)
                    .foregroundStyle(Color.black)
                
                TextField("password again" ,text: $password2)
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
                        csrf_token = try await signUpService.getRequest(requestUrl: URL(string: "http://127.0.0.1:8000/signup/")!)
                        is_authenticated = try await signUpService.postRequest(postRequestUrl: URL(string: "http://127.0.0.1:8000/signup/")!, username: username, password: password1, password2: password2, csrf_token: csrf_token)
                        
                        if is_authenticated == true {
                            print("authenticated")
                            
                        }else {
                            print("error")
                        }
                    }
                } label: {
                    Text("Signup")
                        .padding(10)
                        .background()
                        .backgroundStyle(Color.white.opacity(0.7))
                        .foregroundStyle(.black)
                        .border(Color.white.opacity(0) , width: 10 )
                        .clipShape(Capsule())
                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10 ))
                }
                
                
                
            }
            .navigationTitle("<signup/>")
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

        }
        
    }
}

#Preview {
    SignupPageView()
}
