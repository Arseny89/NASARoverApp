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
                                .image?.resizable()
                                .scaledToFit()
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .borderColor(.white)
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
            .backgroundColor(.white)
            .ignoresSafeArea(.all)
        }
        .ignoresSafeArea(.all)
    }
}
