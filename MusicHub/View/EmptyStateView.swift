//
//  EmptyStateView.swift
//  MusicHub
//
//  Created by Hector Carmona on 10/6/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Text("No artists found")
                .font(.title)
                .foregroundColor(.gray)

            Text("Please enter an artist's name to search.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
        }
        .padding()
    }
}
