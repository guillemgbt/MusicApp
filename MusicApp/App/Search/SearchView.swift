//
//  SearchView.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/14/21.
//

import SwiftUI

struct SearchView: View {
    
    let service = SearchService()
    
    var body: some View {
        Text("Search")
            .onAppear(perform: {
            
                service.search(query: "eminem")
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
