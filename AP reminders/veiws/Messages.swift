//
//  Messages.swift
//  AP reminders
//
//  Created by 64005533 on 4/8/26.
//

import SwiftUI
struct Card: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}
struct Messages: View {
    
    let cards = [
        Card(title: "Example Message", subtitle: "AP Test\nDetails"),
        Card(title: "Example Message", subtitle: "Teacher Name\nStudy Link"),
        Card(title: "Example Message", subtitle: "AP Test\nDetails"),
        Card(title: "Example Message", subtitle: "Teacher Name\nStudy Link"),
        Card(title: "Example Message", subtitle: "AP Test\nDetails"),
        Card(title: "Example Message", subtitle: "Teacher Name\nStudy Link"),
        Card(title: "Example Message", subtitle: "AP Test\nDetails"),
        Card(title: "Example Message", subtitle: "Teacher Name\nStudy Link"),
        Card(title: "Example Message", subtitle: "EP Schools\nDetails")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(cards) { card in
                    CardView(title: card.title, subtitle: card.subtitle)
                }
            }
            .padding()
        }
    }
}
struct CardView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.body)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}
