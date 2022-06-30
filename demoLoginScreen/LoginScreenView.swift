//
//  LoginScreenView.swift
//  demoLoginScreen
//
//  Created by Marc Guerrini on 29/06/2022.
//

import SwiftUI

struct LoginScreenView: View {
    @State var username = ""
    @State var password = ""
    @State var displayLoginSection = false
    @AppStorage("loggedIn") var authenticated: Bool?
    @AppStorage("lastAuthenticationSuccessDate") var lastAuthenticationSuccessDate: Date?
    @State var loginError = false
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            // here put your logo
            VStack {
                Image(systemName: "applelogo")
                    .font(.system(size: 72))
                    .padding(.top, displayLoginSection ? 20 : 0)
                if displayLoginSection {
                    Spacer()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
                    withAnimation {
                        displayLoginSection = true
                    }
                }
            }
            
            if displayLoginSection {
                VStack {
                    Spacer()
                    TextField("", text: $username)
                        .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty, placeholder: "username"))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .overlay(RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.white.opacity(0.20), lineWidth: 2)
                        )
                    SecureField("", text: $password)
                        .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty, placeholder: "password"))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .overlay(RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.white.opacity(0.20), lineWidth: 2)
                        )
                    
                    if username != "" && password != "" {
                        Button {
                            processFormLogin()
                        } label: {
                            Text("Login")
                        }
                        .alert("Error login in", isPresented: $loginError) {
                            Button("ok") { }
                        }
                        .padding(.top)
                    }
                    Spacer()
                }
                .transition(.move(edge: .bottom))
                .padding()
            }
        }
        .foregroundColor(.white)
    }
    
fileprivate func processFormLogin() {
    if username == "John" && password == "password" {
        authenticated = true
        lastAuthenticationSuccessDate = Date()
    } else {
        loginError = true
    }
}
}

struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .padding(5.0)
                    .foregroundColor(.white.opacity(0.50))
            }
            content
            .padding(5.0)
        }
        .background(.blue)
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
