//
//  FavoritePhotosView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 2/12/25.
//

import SwiftUI
import SwiftData

struct FavoritePhotosView: View {
    var rover: Rovers
    @StateObject private var viewModel: FavoritePhotosViewModel
    private let columns = [
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80))
    ]
    @State private var showSaveConfirmation = false
    @State private var showDeleteConfirmation = false
    
    init(rover: Rovers, photos: [Photo], modelContext: ModelContext) {
        self.rover = rover
        self._viewModel = StateObject(
            wrappedValue: FavoritePhotosViewModel(rover: rover,
                                                  photos: photos, modelContext: modelContext)
        )
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($viewModel.filteredPhotos.wrappedValue, id: \.id) { photo in
                    FavoritePhotoCell(viewModel: viewModel, photo: photo, rover: rover)
                }
            }
        }        
        .onLongPressGesture {
            viewModel.isSelectionMode = true
        }
        .overlay(
            Group {
                if viewModel.showSaveMessage {
                    Text(viewModel.saveMessage)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.black.opacity(0.5))
                        .cornerRadius(10)
                        .transition(.opacity)
                }
            }
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if viewModel.isSelectionMode {
                        Button {
                            showSaveConfirmation = true
                        } label: {
                            Image(icon: .download)
                        }
                        .disabled(viewModel.selectedPhotos.isEmpty)
                        .confirmationDialog("Save to photo gallery?",
                                            isPresented: $showSaveConfirmation,
                                            titleVisibility: .visible) {
                            Button("Save", role: .none) {
                                viewModel.saveSelectedPhotos()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                        
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Image(icon: .trash)
                        }
                        .disabled(viewModel.selectedPhotos.isEmpty)
                        .alert("Remove from favorites?", isPresented: $showDeleteConfirmation) {
                            Button("Remove", role: .destructive) {
                                viewModel.deleteSelectedPhotos()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                        .foregroundColorIfNot(viewModel.selectedPhotos.isEmpty, .red)
                    }
                    
                    Button {
                        viewModel.isSelectionMode.toggle()
                    } label: {
                        Text(viewModel.isSelectionMode ? "Done" : "Select")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.presentDetailedView, content: {
            if let photoData = viewModel.selectedPhoto?.photoData,
               let imageData = viewModel.selectedPhoto?.data,
               let uiImage = UIImage(data: imageData) {
                DetailedView(photoData: photoData,
                             photo: uiImage,
                             inFavorites: $viewModel.inFavorites)
                .presentationBackground(.black.opacity(0.7))
            }
        })
    }
}

struct FavoritePhotoCell: View {
    @ObservedObject var viewModel: FavoritePhotosViewModel
    var photo: Photo
    var rover: Rovers
    var body: some View {
        if let uiImage = UIImage(data: photo.data) {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        if viewModel.isSelectionMode {
                            viewModel.toggleSelection(photo: photo)
                        } else {
                            viewModel.selectedPhoto = photo
                            viewModel.presentDetailedView = true
                        }
                    }
                    .frame(width: 120, height: 120)
                
                if viewModel.isSelectionMode {
                    if viewModel.isPhotoSelected(photo: photo) {
                        Image(icon: .checkmarkSquare)
                            .foregroundColor(.blue)
                            .opacity(0.8)
                            .padding(1)
                    } else {
                        Image(icon: .square)
                            .foregroundColor(.white)
                            .opacity(0.8)
                            .padding(1)
                    }
                }
            }
        }
    }
}
