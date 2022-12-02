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
    @Published var isPermanent: Bool
    
    init(value: Int, index: Int, rowCol:[Int], isPermanent:Bool) {
        self.squareVal = value
        self.index = index
        self.row = rowCol[0]
        self.col = rowCol[1]
        self.isPermanent = isPermanent
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
        return self.data.isPermanent ? .bold : .light
    }
    
    var body: some View {
        Button(action: {
            self.onclick()
        }, label: {
            Text(self.data.squareVal != 0 ? String(self.data.squareVal) : " ")
                .foregroundColor(Color.black)
                .fontWeight(squareWeight)
                .frame(width:40, height:40, alignment: .center)
                .border(Color.black.opacity(0.7))
                .background(squareColor)
        })
    }
}

class BoardClass: ObservableObject {
    @Published var items = [Square]()
    init() {
        self.makeNewBoard()
    }
    
    func indexToRowCol(index: Int) -> [Int] {
        let row: Int = index / 9
        let col: Int = index % 9
        return [row, col]
    }
    
    func rowColToIndex(row:Int, col:Int) -> Int {
        return col + row * 9
    }
    
    func setSquare(index: Int, newVal: Int) -> Void {
        if (items[index].isPermanent) {
            return
        } else {
            items[index].squareVal = newVal
        }
    }
    
    func makeNewBoard() {
        items.removeAll()
        for i in 0...80 {
            let perm = Int.random(in: 0..<10)
            items.append(Square(value:perm, index:i, rowCol:indexToRowCol(index: i), isPermanent:(arc4random() != 0 && perm != 0)))
        }
    }
    
    func isValid(rowIndex:Int, colIndex:Int, k:Int) -> Bool {
        for i in 0 ..< 9 {
          let m = 3 * (rowIndex / 3) + (i / 3);
          let n = 3 * (colIndex / 3) + (i % 3);
            if (items[rowColToIndex(row:rowIndex, col:i)].squareVal == k ||
                items[rowColToIndex(row:i, col:colIndex)].squareVal == k ||
                items[rowColToIndex(row:m, col:n)].squareVal == k) {
            return false;
          }
      }
      return true;
    }

    
    func solveBoard() -> Bool {
        for i in 0 ..< 9 {
            for j in 0 ..< 9 {
                if (items[rowColToIndex(row: i, col: j)].squareVal == 0) {
                    for k in 1 ..< 10 {
                        if (isValid(rowIndex:i, colIndex:j, k:k)) {
                            items[rowColToIndex(row:i, col:j)].squareVal = k
                            if (solveBoard()) {
                                return true;
                            } else {
                                items[rowColToIndex(row:i, col:j)].squareVal = 0;
                            }
                        }
                    }
                return false;
                }
            }
          }
          return true;
    }
}


struct ContentView: View {
    @StateObject var board = BoardClass()
    @State var isSolved: Bool = false
    @State var selectedVal: Int = 0
    
    func getButtonColor(currentVal: Int, selectedVal: Int) -> Color {
        if (currentVal == selectedVal) {
            return Color.blue.opacity(0.8)
        } else {
            return Color.blue.opacity(0.5)
        }
    }
    
    func setSelectedVal(selected: Int) -> Void {
        selectedVal = selected
    }
    
    var body: some View {
        VStack(spacing:0) {
            Text("Sudoku")
                .bold()
                .padding([.bottom], 20)
                .font(.title3)
            ForEach(0 ..< board.items.count / 9, content: { row in
                HStack(spacing:0) {
                    ForEach(0 ..< 9, content: {
                        col in
                        let index = row * 9 + col
                        SquareView(data: board.items[index], onclick: {
                            self.board.setSquare(index: index, newVal: selectedVal)
                        })
                    })
                }
            })
            VStack(spacing:2) {
                HStack(spacing:2) {
                    ForEach(0 ..< 6, content: { val in
                        Button(action: {
                            self.setSelectedVal(selected: val)
                        }, label: {
                            Text(val == 0 ? "X" : String(val))
                                .foregroundColor(Color.white)
                                .bold()
                                .frame(width:40, height:40, alignment: .center)
                                .border(Color.gray)
                                .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                        })
                    })
                }
                HStack(spacing:2) {
                    ForEach(6 ..< 10, content: { val in
                        Button(action: {
                            self.setSelectedVal(selected: val)
                        }, label: {
                            Text(String(val))
                                .foregroundColor(Color.white)
                                .bold()
                                .frame(width:40, height:40, alignment: .center)
                                .border(Color.gray)
                                .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                        })
                    })
                }

            }
            .padding([.top, .bottom], 20)
            HStack(spacing:2) {
                Button(action: {
                    self.board.makeNewBoard()
                }, label: {
                    Text("New Game")
                        .foregroundColor(Color.white)
                        .bold()
                        .frame(alignment: .center)
                        .padding(10)
                        .border(Color.gray)
                        .background(Color.gray)
                })
                Button(action: {
                    self.board.solveBoard()
                }, label: {
                    Text("View Solution")
                        .foregroundColor(Color.white)
                        .bold()
                        .frame(alignment: .center)
                        .padding(10)
                        .border(Color.gray)
                        .background(Color.gray)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
