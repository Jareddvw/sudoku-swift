//
//  SquareView.swift
//  SudokuApp
//
//  Created by Jared Williams on 12/5/22.
//

import Foundation
import SwiftUI

class Square: ObservableObject {
    @Published var squareVal: Int
    @Published var index: Int
    @Published var row: Int
    @Published var col: Int
    @Published var isPermanent: Bool
    @Published var isHint: Bool
    @Published var isWrong: Bool
    
    init(value: Int, index: Int, rowCol:[Int], isPermanent:Bool) {
        self.squareVal = value
        self.index = index
        self.row = rowCol[0]
        self.col = rowCol[1]
        self.isPermanent = isPermanent
        self.isHint = false
        self.isWrong = false
    }
}

struct SquareView: View {
    @ObservedObject var data: Square
    
    var onclick: () -> Void
    
    var squareColor: Color {
        
        if (((self.data.col > 5 || self.data.col < 3) && (self.data.row > 5 || self.data.row < 3)) ||
            ((self.data.col <= 5 && self.data.col >= 3) && (self.data.row <= 5 && self.data.row >= 3))) {
            return .blue.opacity(0.5)
        } else {
            return .blue.opacity(0.8)
        }
    }
    
    var squareWeight: Font.Weight {
        if (self.data.isHint) {
            return .bold
        }
        if (self.data.isWrong) {
            return .bold
        }
        
        return self.data.isPermanent ? .bold : .light
    }
    
    var squareTextColor: Color {
        if (self.data.isHint) {
            return .white
        } else if (self.data.isWrong) {
            return .red.opacity(0.5)
        } else {
            return .black
        }
    }
    
    var body: some View {
        Button(action: {
            self.onclick()
        }, label: {
            Text(self.data.squareVal != 0 ? String(self.data.squareVal) : " ")
                .foregroundColor(squareTextColor)
                .fontWeight(squareWeight)
                .frame(width:40, height:40, alignment: .center)
                .border(Color.black.opacity(0.7))
                .background(squareColor)
        })
    }
}
