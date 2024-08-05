//
//  PhotoGalleryView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/25/24.
//

import SwiftUI

struct PhotoGalleryView: View {
    @ObservedObject var viewModel: PhotoGalleryViewModel
    private let columns = [
            GridItem(.adaptive(minimum: 80)),
            GridItem(.adaptive(minimum: 80)),
            GridItem(.adaptive(minimum: 80))
        ]
    var body: some View {
        VStack {
            VStack {
                Rectangle()
                    .frame(width: UIScreen.width * 0.3, height: 5)
                    .clipShape(.capsule)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                Spacer()
            }
            .height(20)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.photos.sorted { $1.0 < $0.0 }, id: \.key) { key, url in
                        AsyncImage(url: url) {image in
                            image
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    viewModel.detailedURL = url
                                    viewModel.presentDetailedView = true
                                }
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 120)
                    }
                }
                Button {
                    viewModel.bind()
                } label: {
                    Text(Titles.showMoreButton.rawValue.capitalized)
                        .font(.system(size: 15, weight: .bold))
                }
                .frame(width: 200, height: 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipCapsule()
                .padding(.vertical, 30)
                
            }
            .ignoresSafeArea(.all)
        }
        .sheet(isPresented: $viewModel.presentDetailedView, content: {
            DetailedView(detailedURL: $viewModel.detailedURL)
                .presentationBackground(.clear)
                .presentationDetents([.height(UIScreen.height * 0.7)])
        })
        .ignoresSafeArea(.all)
    }
}

struct DetailedView: View {
    @Binding var detailedURL: URL?
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var currentOffset = CGPoint.zero
    @State private var previousOffset = CGPoint.zero
    @State private var imageSize: CGSize = .zero
    var body: some View {
        VStack {
            AsyncImage(url: detailedURL) {image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .scaleEffect(currentZoom + totalZoom)
            .gesture(
                SimultaneousGesture(
                    MagnifyGesture()
                        .onChanged { value in
                            currentZoom = value.magnification - 1
                        }
                        .onEnded { value in
                            totalZoom += currentZoom
                            currentZoom = 0
                            if totalZoom < 1 {
                                totalZoom = 1
                            }
                        },
                    
                    DragGesture(minimumDistance: 10, coordinateSpace: .global)
                        .onChanged { value in
                            if totalZoom > 1 {
                                currentOffset.y = previousOffset.y + value.translation.y
                                currentOffset.x = previousOffset.x + value.translation.x
                            } else {
                                withAnimation {
                                    currentOffset = .zero
                                }
                            }
                        }
                        .onEnded { value in
                            previousOffset = currentOffset
                        }
                )
            )
            .offset(currentOffset)
            .background(Color.white.opacity(0.9))
            .accessibilityZoomAction { action in
                if action.direction == .zoomIn {
                    totalZoom += 0.5
                } else {
                    totalZoom -= 0.5
                }
            }
            .border(Color.white.opacity(0.9), width: 5)
            .cornerRadiusIf(true, 5)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}
