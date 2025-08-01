//
//  FlippableView.swift
//  SibAppTask
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import SwiftUI

struct FlippableView<Front: View, Back: View>: View {
    
    private let frontBuilder: () -> Front
    private let backBuilder: () -> Back
    @Binding var isFlipped: Bool

    init(@ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back, isFlipped: Binding<Bool>) {
        self.frontBuilder = front
        self.backBuilder = back
        self._isFlipped = isFlipped
    }

    var body: some View {
        let frontOpacity: Double = isFlipped ? 0   : 1
        let backOpacity:  Double = isFlipped ? 1   : 0
        let frontDeg:     Double = isFlipped ? 180 : 0
        let backDeg:      Double = isFlipped ? 0   : -180
        
        ZStack {
            frontBuilder()
                .opacity(frontOpacity)
                .rotation3DEffect(.degrees(frontDeg), axis: (x: 0, y: 1, z: 0))
                .frame(maxWidth: .infinity)

            backBuilder()
                .opacity(backOpacity)
                .rotation3DEffect(.degrees(backDeg), axis: (x: 0, y: 1, z: 0))
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .compositingGroup()
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}



