//
//  ContentView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import SwiftUI

struct RoverSelectionView: View {
    @ObservedObject var viewModel: RoverSelectionViewModel
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ZStack {
                            ForEach(Rovers.allCases, id: \.self) { rover in
                                Image("\(rover.rawValue)_shape_bg")
                                    .resizable()
                                    .modifier(ClipAnimatedShape(rover: rover, selectedRover: viewModel.selectedRover))
                                    .onTapGesture {
                                        withAnimation { viewModel.selectedRover = rover }
                                    }
                            }
                        }
                        .frame(UIScreen.width, UIScreen.width * 1.25)
                        Text(Titles.roverSelectionView.rawValue.uppercased())
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                            .frame(width: UIScreen.width, alignment: .leading)
                        
                        TabView(selection: $viewModel.selectedRover) {
                            ForEach(Rovers.allCases, id: \.self) { rover in
                                InfoView(rover: rover, viewModel: viewModel)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle.init(indexDisplayMode: .never))
                        .frame(width: UIScreen.width, height: 250)
                    }
                }
                .ignoresSafeArea(.all)
                
                HStack(spacing: 10) {
                    Spacer()
                    NavigationLink {
                        RoverView(viewModel: RoverViewModel(for: viewModel.selectedRover))
                    } label: {
                        Spacer()
                        Text(Titles.fetchButton.rawValue.capitalized)
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(.infinity, 50, .leading)
                    .backgroundColor(.blue)
                    .clipCapsule()
                    Spacer()
                    
                    Button {
                    }
                label: {
                    Image(icon: .calendar)?
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(20)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                }
                .backgroundColor(.blue)
                .frame(.infinity, 50, .trailing)
                .clipCapsule()
                    Spacer()
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

fileprivate struct InfoView: View {
    var rover: Rovers
    var viewModel: RoverSelectionViewModel
    
    var body: some View {
        VStack {
            Text(rover.rawValue.uppercased())
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .frame(width: UIScreen.width, alignment: .leading)
            
            Text(Titles.roverInfoSubtitle.rawValue.uppercased())
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
                .frame(width: UIScreen.width, alignment: .leading)
            
            Text(viewModel.getMissionInfo(for: rover))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 5)
                .padding(.horizontal, 10)
                .frame(width: UIScreen.width, alignment: .leading)
            
            Button {
            } label: {
                HStack {
                    Text(Titles.moreButton.rawValue.uppercased())
                    Image(icon: .ellipsisCircle)
                }
            }
            .foregroundColor(.gray)
            .padding(.trailing, 10)
            .frame(width: UIScreen.width, alignment: .trailing)
            Spacer()
        }
    }
}

fileprivate struct ClipAnimatedShape: ViewModifier {
    var rover: Rovers
    var selectedRover: Rovers
    func body(content: Content) -> some View {
        let offset: CGFloat = rover == selectedRover ? UIScreen.width * 0.025 : 0

        switch rover {
        case .opportunity:
            content
                .clipShape(Segments.OpportunitySegment())
                .contentShape(Segments.OpportunitySegment())
                .scaleEffect(rover == selectedRover ? 1.2 : 1)
                .offset(-offset * 0.2, offset * 1.3)
                .grayscale(rover == selectedRover ? 0 : 1)

        case .spirit:
            content
                .clipShape(Segments.SpiritSegment())
                .contentShape(Segments.SpiritSegment())
                .scaleEffect(rover == selectedRover ? 1.2 : 1)
                .offset(-offset * 2, -offset * 1.3)
                .grayscale(rover == selectedRover ? 0 : 1)

        case .curiosity:
            content
                .clipShape(Segments.CuriositySegment())
                .contentShape(Segments.CuriositySegment())
                .scaleEffect(rover == selectedRover ? 1.2 : 1)
                .offset(-offset * 0.2, -offset * 4.1)
                .grayscale(rover == selectedRover ? 0 : 1)
        }
    }
}

#Preview {
    RoverSelectionView(viewModel: RoverSelectionViewModel(for: .curiosity))
}
