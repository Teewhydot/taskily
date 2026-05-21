//
//  SettingsView.swift
//  taskily
//
//  Created by Issa Abubakar on 09/05/2026.
//

import SwiftUI

struct SettingsView: View {
    enum AppTheme: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
    @AppStorage("selectedTheme") var selectedTheme = AppTheme.system
    @State private var notificationsOn: Bool = false
    private func SettingsRow<Trailing: View>(icon: String, leadingColor: Color, title: String, @ViewBuilder suffixWidget: () -> Trailing) -> some View {
        HStack(spacing: 12){
            Image(systemName: icon)
                .padding(8)
                .foregroundStyle(.foreground)
                .background(leadingColor)
                .cornerRadius(10)

            Text(title)
            Spacer()
            suffixWidget()
        }.padding(8)
        
    }
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .bold()
            VStack(alignment: .leading){
               
                SettingsRow(icon: "bell",leadingColor: .red, title: "Push Notifications"){
                    Toggle("",isOn: $notificationsOn).labelsHidden()
                }
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "paintpalette.fill")
                            .padding(10)
                            .foregroundStyle(.foreground)
                            .background(.blue)
                            .cornerRadius(10)
                        Text("Appearance")
                        
                    }.padding(.bottom,10)
                    Picker("Appearance",systemImage: "paintpalette.fill",selection: $selectedTheme){
                        ForEach(AppTheme.allCases,id: \.self){ theme in
                            Text(theme.rawValue)
                            
                        }
                    }.pickerStyle(.segmented)
                  
                    
                }.padding(.leading,6)
        
                
            }.padding(6)
            .background(.secondary)
                .cornerRadius(15)

                .padding()
            
            VStack(alignment: .leading){
                
                SettingsRow(icon: "questionmark.circle",leadingColor: .red, title: "Help and support"){
                    Image(systemName: "chevron.right").padding(.trailing,10)
                }
                SettingsRow(icon: "questionmark",leadingColor: .accentColor, title: "Privacy Policy"){
                    Image(systemName: "chevron.right").padding(.trailing,10)

                }
            
            }.padding(6)
            .background(.secondary)
                .cornerRadius(15)

                .padding()
                .padding(.bottom, 30)
                
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
