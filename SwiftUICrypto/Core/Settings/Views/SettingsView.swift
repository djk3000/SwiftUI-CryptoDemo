//
//  SettingsView.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/21.
//

import SwiftUI

struct SettingsView: View {
    let defaultUrl = URL(string: "https://www.google.com")!
    let baiduUrl = URL(string: "https://www.baidu.com")!
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack (alignment: .leading, spacing: 5){
                        Text("Demo网站")
                            .padding(.vertical)
                        Link(destination: defaultUrl) {
                            Text("Google")
                        }
                        .accentColor(.blue)
                        .padding(.vertical)
                        
                        Link(destination: defaultUrl) {
                            Text("Baidu")
                        }
                        .accentColor(.blue)
                        .padding(.vertical)
                    }
                } header: {
                    Text("Link")
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
