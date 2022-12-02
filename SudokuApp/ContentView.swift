//
//  ContentView.swift
//  SudokuApp
//
//  Created by Jared Williams on 12/1/22.
//

import SwiftUI

class Square: ObservableObject {
    @Published var squareVal: Int
    @Published var index: Int
    @Published var row: Int
    @Published var col: Int
    
    init(value: Int, index: Int, rowCol:[Int]) {
        self.squareVal = value
        self.index = index
        self.row = rowCol[0]
        self.col = rowCol[1]
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
    
    var body: some View {
        Button(action: {
            self.onclick()
        }, label: {
            Text(self.data.squareVal != 0 ? String(self.data.squareVal) : " ")
                .foregroundColor(Color.white)
                .bold()
                .frame(width:40, height:40, alignment: .center)
                .border(Color.gray)
                .background(squareColor)
        })
    }
}

class BoardClass: ObservableObject {
    @Published var items = [Square]()
    init() {
        for i in 0...80 {
            items.append(Square(value:i, index:i, rowCol:indexToRowCol(index: i)))
        }
    }
    
    func indexToRowCol(index: Int) -> [Int] {
        let row: Int = index / 9
        let col: Int = index % 9
        return [row, col]
    }
}


struct ContentView: View {
    @StateObject var board = BoardClass()
    @State var isSolved = false
    
    func onSquareClick(_ index: Int) {
        return
    }
    
    var body: some View {
        VStack(spacing:0) {
            Text("Sudoku")
                .bold()
                .padding(.bottom)
                .font(.title3)
            ForEach(0 ..< board.items.count / 9, content: {
                row in
                HStack(spacing:0) {
                    ForEach(0 ..< 9, content: {
                        col in
                        let index = row * 9 + col
                        SquareView(data: board.items[index], onclick: {self.onSquareClick(index)})
                    })
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
