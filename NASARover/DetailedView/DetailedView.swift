//
//  DetailedView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 2/13/25.
//

import SwiftUI
import SwiftData

struct DetailedView: View {
    var photoData: PhotoData?
    var photo: UIImage?
    @Binding var inFavorites: Bool
    @Query private var photos: [Photo]
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var currentOffset = CGPoint.zero
    @State private var previousOffset = CGPoint.zero
    @State private var buttonScale: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if let photoData {
                    VStack(alignment: .leading) {
                        Text("Date: \(photoData.date) (Sol: \(photoData.sol))")
                        Text("\(photoData.camera.fullName)")
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                }
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(icon: .xmark)
                        .resizable()
                        .scaledToFill()
                        .frame(20)
                        .foregroundColor(.white)
                        .shadow(1, offset: 5.0, angle: .bottomTrailing)
                }
                .padding(.trailing, 10)
            }
            ScrollView {
                if let image = photo {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(currentZoom + totalZoom)
                        .gesture(
                            SimultaneousGesture(
                                MagnifyGesture()
                                    .onChanged { value in
                                        currentZoom = (value.magnification - 1) * (totalZoom * 0.5)
                                    }
                                    .onEnded { value in
                                        totalZoom += currentZoom
                                        currentZoom = 0
                                        if totalZoom < 1 {
                                            totalZoom = 1
                                            withAnimation {
                                                currentOffset = .zero
                                            }
                                        }
                                    },
                                
                                DragGesture(minimumDistance: 10, coordinateSpace: .global)
                                    .onChanged { value in
                                        if totalZoom > 1 {
                                            currentOffset.y = previousOffset.y + value.translation.y
                                            currentOffset.x = previousOffset.x + value.translation.x
                                        }
                                    }
                                    .onEnded { value in
                                        previousOffset = currentOffset
                                    }
                            )
                        )
                        .accessibilityZoomAction { action in
                            if action.direction == .zoomIn {
                                totalZoom += 0.5
                            } else {
                                totalZoom -= 0.5
                            }
                        }
                        .offset(currentOffset)
                        .background(Color.white.opacity(0.9))
                        .border(Color.white.opacity(0.9), width: 5)
                        .cornerRadiusIf(true, 5)
                }
            }
            .scaledToFit()
            .scrollDisabled(true)
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    buttonScale = 1.2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        saveImage()
                    }
                }
            } label : {
                Image(icon: .add)
                    .resizable()
                    .scaledToFill()
                    .frame(20)
                    .foregroundColor(.white)
                Text("Add")
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 30)
            .background(.blue)
            .foregroundColor(.white)
            .clipCapsule()
            .padding(.leading, 10)
            .scaleEffect(buttonScale)
            .opacity(inFavorites ? 0 : 1)
            .animation(.easeInOut, value: inFavorites)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
    
    private func saveImage() {
        if let photo, let photoData {
            DispatchQueue.main.async {
                if let data = photo.jpegData(compressionQuality: 1.0) {
                    modelContext.insert(
                        Photo(
                            id: UUID(),
                            data: data,
                            photoData: photoData
                        )
                    )
                    inFavorites = photos.compactMap({ $0.photoData?.imageURL }).contains(photoData.imageURL)
                }
            }
        }
    }
}
