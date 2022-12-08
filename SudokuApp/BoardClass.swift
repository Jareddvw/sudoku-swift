//
//  BoardClass.swift
//  SudokuApp
//
//  Created by Jared Williams on 12/5/22.
//

import Foundation
import SwiftUI

class BoardClass: ObservableObject {
    @Published var items = [Square]()
    @Published var numSteps = 0
    @Published var currentPuzzle: [String] = [""]
    
    @Published var data: [[String]] = [
        ["831000000270006000000009001050001600700902050063000009006017005000000000000008093",
        "831574962279136548645829731952341687718962354463785219396417825584293176127658493"],
        ["560801000010000008000500070159600002600900031000000000090108050000070006070000800",
        "567841923314792568928563174159637482642985731783214695496128357835479216271356849"],
        ["570006000008504000006000030000000000100000800030080200080001060605300020010005073",
        "571936482328574619946128735859712346162453897437689251783291564695347128214865973"],
        ["410006000709800020000300000000090002600008100200007940120000000908600000064000208",
        "412976385739854621856321479547193862693248157281567943125489736978632514364715298"],
        ["300060090004200006000000200003900000400000508080020900670000035208000000009308007",
        "325861794814279356967543281753984162492136578186725943671492835238657419549318627"],
        ["000600340000004001000010906700001008000500090900800130040007800090405013007100059",
        "271689345639754281584213976763941528418532697952876134145397862896425713327168459"],
        ["000024000000030050005000100500000600802350901900806300410000030000000200029000418",
        "186524793794631852235978164543192687862357941971846325417289536658413279329765418"],
        ["001009050003005109070000034300000080200408500085391070000503200000000010000000000",
        "421839756863745129579126834394257681217468593685391472948513267732684915156972348"]
    ]
    
    init() {
        self.makeNewBoard()
    }
    
    func chooseNextPuzzle() {
        let prevPuzzle: [String] = currentPuzzle
        while (prevPuzzle == self.currentPuzzle) {
            self.currentPuzzle = self.data[Int.random(in:0..<(data.count))]
        }
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
        self.chooseNextPuzzle()
        items.removeAll()
        for (i, ch) in currentPuzzle[0].map(String.init).enumerated() {
            items.append(Square(value:(Int(ch) ?? 0), index:i, rowCol:indexToRowCol(index: i),
                                isPermanent:(Int(ch) ?? 0) > 0))
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
    
    func revealOne() -> Void {
        for (i, ch) in currentPuzzle[1].map(String.init).enumerated() {
            if (self.items[i].squareVal == 0) {
                self.items[i].squareVal = Int(ch) ?? 0
                self.items[i].isHint = true
                break
            }
        }
    }

    
    func solveBoard() {
        for (i, ch) in currentPuzzle[1].map(String.init).enumerated() {
            if (self.items[i].squareVal > 0 && self.items[i].squareVal != Int(ch)) {
                self.items[i].isWrong = true
            } else {
                self.items[i].isWrong = false
                self.items[i].squareVal = Int(ch) ?? 0
            }
            
        }
    }
}
