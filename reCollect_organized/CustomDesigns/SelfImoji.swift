//
//  SelfImoji.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 18/07/2023.
//

import SwiftUI

class ImojiViewModel: ObservableObject {
    
    // size factor
    @Published var sF: Double = 1.5
    
    @Published var eyesImojiOpacity: Double = 0
    @Published var mouthImojiOpacity: Double = 0
    @Published var earXoffset : Double = 10 * 1.5
    
    @Published var headRotation: Double = 0
    @Published var bodyRotation: Double = 0
    @Published var headOffsetX: Double = 0
    @Published var bodyoffsetX: Double = 0
    @Published var thumbOffsetX: Double = 0
    @Published var thumbOffsetY: Double = 46 * 1.5
    
    func fadeInEyes() {
        withAnimation(.easeIn(duration: 1)) {
            eyesImojiOpacity = 1
        }
    }
    
    func fadeInMouth() {
        withAnimation(.easeIn(duration: 1)) {
            mouthImojiOpacity = 1
        }
    }
    
    func revealEars(){
        withAnimation(.easeIn(duration: 1)){
            earXoffset = 13.5 * sF
        }
    }
    
    func thumbsUp(){
        withAnimation(.easeIn(duration: 1)) {
            headRotation = -13 * sF
            bodyRotation = -10 * sF
            thumbOffsetX = 23 * sF
            thumbOffsetY = 29 * sF
            bodyoffsetX = -6 * sF
            headOffsetX = -10 * sF
        }
    }
}

struct SelfImoji: View {
    
    @ObservedObject var viewModel: ImojiViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("frameImoji")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75 * viewModel.sF, height: 75 * viewModel.sF)
            
            Image("thumbImoji")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20 * viewModel.sF, height: 20 * viewModel.sF)
                .offset(x:viewModel.thumbOffsetX,
                        y: viewModel.thumbOffsetY)
            
            Image("bodyImoji")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:  46.96 * viewModel.sF, height: 49.6 * viewModel.sF)
                .offset(y: 45.1 * viewModel.sF)
                .offset(x: viewModel.bodyoffsetX)
                .rotationEffect(.degrees(viewModel.bodyRotation))
            
            
            ZStack() {
                Image("headImoji")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:  29 * viewModel.sF, height: 29 * viewModel.sF)
                
                Image("eyesImoji")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15 * viewModel.sF, height: 4 * viewModel.sF)
                    .offset(y: -(2.5) * viewModel.sF)
                    .opacity(viewModel.eyesImojiOpacity)
                Image("mouthImoji")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12 * viewModel.sF, height: 4 * viewModel.sF)
                    .offset(y: 5 * viewModel.sF)
                    .opacity(viewModel.mouthImojiOpacity)
                Image("cheekImoji")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 8.5 * viewModel.sF, height: 8.5 * viewModel.sF)
                    .offset(x:viewModel.earXoffset ,
                            y: 1 * viewModel.sF)
                
                Image("cheekImoji")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 8.5 * viewModel.sF,
                           height: 8.5 * viewModel.sF)
                    .offset(x:(-(viewModel.earXoffset) + 0.5),
                            y: 0.9)
            }
            .offset(y: 15.4 * viewModel.sF)
            .rotationEffect(.degrees(viewModel.headRotation))
            .offset(x: viewModel.headOffsetX)
            
            
        }.mask(
            Image("frameImoji")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75 * viewModel.sF, height: 75 * viewModel.sF)
        )
    }
}

struct SelfImoji_Previews: PreviewProvider {
    static var previews: some View {
        SelfImoji(viewModel: ImojiViewModel())
    }
}

