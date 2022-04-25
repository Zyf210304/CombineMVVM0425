//
//  LoginViewModel.swift
//  CombineMVVM0425
//
//  Created by 张亚飞 on 2022/4/25.
//

import SwiftUI
import Combine

enum PasswordStatus {
    
    case empty
    case notStrongEnough
    case repeatePasswordWrong
    case valid
}



class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var rePassword = ""
    @Published var isValid = false
    
    @Published var inlineErrorForPassword = ""
    @Published var usernameStatus = ""
    
    private var cannnellable = Set<AnyCancellable>()
    
    private static let predicate = NSPredicate(format: "SELF MATCHES %0","^(?=.*[a-z]) (?=.*[SO$#!%*?&]) .(6,}S")
  
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        
        return $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {$0.count >= 6 && $0.count < 15}
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmplyPublisher: AnyPublisher<Bool, Never> {
        
        return $email
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublished: AnyPublisher<Bool, Never> {
        
        return
            Publishers.CombineLatest($password, $rePassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map {$0 == $1}
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        
        return $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {Self.predicate.evaluate(with: $0)}
            .eraseToAnyPublisher()
    }
    
    private var isPassswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        
        return
            Publishers.CombineLatest3(isPasswordEmplyPublisher, isPasswordStrongPublisher, arePasswordsEqualPublished)
            .map {
                
                if $0 {return PasswordStatus.empty}
                if !$1 {return PasswordStatus.notStrongEnough}
                if !$2 {return PasswordStatus.repeatePasswordWrong}
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isFromValidPubliser: AnyPublisher<Bool, Never> {
        
        return Publishers.CombineLatest(isPassswordValidPublisher, isUsernameValidPublisher)
            .map{$0 == .valid && $1}
            .eraseToAnyPublisher()
    }
    
    init(){
        
        isFromValidPubliser
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cannnellable)
        
        isUsernameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { b -> String in
                
                if b {
                    return ""
                } else {
                    
                    return "用户名最少6位，最多15位"
                }
            }
            .assign(to: \.usernameStatus, on: self)
            .store(in: &cannnellable)
            
    }
    
}
