//
//  ContentView.swift
//  CombineMVVM0425
//
//  Created by 张亚飞 on 2022/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vm = LoginViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Form {
                    
                    Section {
                        
                        TextField("请输入手机号/邮箱", text: $vm.email)
                    } header: {
                        
                        Text("用户名")
                    }
                    
                    Section {
                        
                        SecureField("密码", text: $vm.password)
                        SecureField("确认密码", text: $vm.rePassword)
                    } header: {
                        
                        Text("密码")
                    }
                }
                
                Button {

                } label: {

                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                        .frame(height: 50)
                        .overlay {

                            Text("Login")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                }
                .padding()
                .ignoresSafeArea()
            }
            .navigationTitle("注册")
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
