//
//  FavoritePhotosViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 2/12/25.
//

import SwiftUI
import SwiftData

final class FavoritePhotosViewModel: NSObject, ObservableObject {
    @Published var filteredPhotos: [Photo] = []
    @Published var presentDetailedView: Bool = false
    @Published var selectedPhoto: Photo?
    @Published var inFavorites: Bool = true
    @Published var selectedPhotos: Set<UUID> = []
    @Published var saveMessage: String = ""
    
    @Published var isSelectionMode: Bool = false {
        didSet {
            if !isSelectionMode {
                selectedPhotos.removeAll()
            }
        }
    }
    
    @Published var showSaveMessage: Bool = false {
        didSet {
            if showSaveMessage {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.2)) { [weak self] in
                        guard let self else { return }
                        showSaveMessage = false
                    }
                }
            }
        }
    }
    
    private var modelContext: ModelContext
    
    init(rover: Rovers, photos: [Photo], modelContext: ModelContext) {
        self.modelContext = modelContext
        super.init()
        filterPhotos(rover: rover, photos: photos)
    }
    
    func filterPhotos(rover: Rovers, photos: [Photo]) {
        filteredPhotos = photos.filter { $0.photoData?.rover.name.lowercased() == rover.rawValue }
    }
    
    func toggleSelection(photo: Photo) {
        if selectedPhotos.contains(photo.id) {
            selectedPhotos.remove(photo.id)
        } else {
            selectedPhotos.insert(photo.id)
        }
    }
    
    func isPhotoSelected(photo: Photo) -> Bool {
        return selectedPhotos.contains(photo.id)
    }
    
    func deleteSelectedPhotos() {
        for photoID in selectedPhotos {
            if let photo = filteredPhotos.first(where: { $0.id == photoID }) {
                modelContext.delete(photo)
            }
        }
        try? modelContext.save()
        filteredPhotos.removeAll { photo in
            selectedPhotos.contains(photo.id)
        }
        selectedPhotos.removeAll()
    }
    
    func saveSelectedPhotos() {
        for photoID in selectedPhotos {
            if let photo = filteredPhotos.first(where: { $0.id == photoID }),
               let image = UIImage(data: photo.data) {
                saveToPhotoLibrary(image: image)
            }
        }
        isSelectionMode = false
    }
    
    func saveToPhotoLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            saveMessage = "Error: \(error.localizedDescription)"
        } else {
            saveMessage = "Saved!"
        }
        showSaveMessage = true
    }
}
