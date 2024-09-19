//
//  ContentView.swift
//  PhotosPicker
//
//  Created by user on 19.09.2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedPhotosData: [Data] = []
    
    var body: some View {
        NavigationStack {
                    
                    ScrollView {
                        VStack {
                            ForEach(selectedPhotosData, id: \.self) { photoData in
                                if let image = UIImage(data: photoData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(10.0)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    
                    .navigationTitle("Photos")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                                Image(systemName: "photo.on.rectangle.angled")
                            }
                            .onChange(of: selectedItems) { newItems in
                                for newItem in newItems {
                                    
                                    Task {
                                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                                            selectedPhotosData.append(data)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
        
        .padding()
        
    }
}

#Preview {
    ContentView()
}
