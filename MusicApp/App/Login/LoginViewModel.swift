//
//  LoginViewModel.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/20/21.
//

import Foundation
import Combine

class LoginViewModel {
    
    private let credentialsManager: CredentialsManaging
    
    let message = PassthroughSubject<Message, Never>()
    let shouldDismiss = PassthroughSubject<Bool, Never>()
    @Published var isFetchingProfile: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(credentialsManager: CredentialsManaging = CredentialsManager()) {
        self.credentialsManager = credentialsManager
    }
    
    var loginPageURL: URL {
        return credentialsManager.loginPageURL
    }
    
    func isAccessTokenURL(url: URL?) -> Bool {
        guard let url = url else { return false }
        return url.absoluteString.contains("#access_token")
    }
    
    func handleRedirectCodeURL(_ url: URL?) {
        guard let url = url?.replacingAnchorTag,
              let queryItems = URLComponents(string: url.absoluteString)?.queryItems,
              let token = queryItems.first(where: { $0.name == "access_token" })?.value
        else {
            onFailed()
            return
        }
        
        credentialsManager.registerAccessToken(token)
        
        fetchProfile()
    }
    
    private func fetchProfile() {
        isFetchingProfile = true
        
        credentialsManager
            .fetchProfile()
            .sink { [weak self] (result) in
                switch result {
                case .finished:
                    self?.onSuccess()
                case .failure(_):
                    self?.onFailed()
                }
                self?.isFetchingProfile = false
            } receiveValue: { user in
                print("User fetched: \(user.name ?? "")")
            }
            .store(in: &subscriptions)
    }
    
    func handleError(_ error: Error) {
        onFailed()
    }
    
    private func onFailed() {
        message.send(Message(title: "Oops", description: "There was an issue signing in."))
    }
    
    private func onSuccess() {
        shouldDismiss.send(true)
    }
    
    
}
