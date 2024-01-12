//
//  Calcudoku.swift
//  CalcudokuCollection
//
//  Created by 567 on 2024/1/11.
//

import UIKit

struct Group {
    var ids: [Int] = []
    var op: Character = "0"
    var res: Int = 0
}

class Calcudoku: NSObject {
    
    var size: Int = 0
    var info: [Group] = []
    var ans: [Int] = []
    
    var cur_mat: [Int] = []
    
    func setSize(sz: Int) -> Void {
        size = sz;
        for _ in 0 ..< size * size {
            cur_mat.append(0)
        }
    }
    
    func addInfo(con: Group) -> Void {
        info.append(con)
    }
    
    func addAns(digit: Int) -> Void {
        ans.append(digit)
    }
    
    override init() {
        super.init()
    }
    
    public func setNum(p: Int, num: Int) {
        cur_mat[p] = num
    }
    
    public func getNum(p: Int) -> Int {
        return cur_mat[p]
    }
    
    public func checkCell(p: Int) -> Bool {
        if cur_mat[p] == ans[p] {
            return true
        } else {
            return false
        }
    }
    
    public func clear() {
        for i in 0 ..< size * size {
            cur_mat[i] = 0
        }
    }
    // 检查运算约束
    public func checkCal() -> [Int] {
        var ret = [Int]()
        for i in 0 ..< info.count {
            var res1: Int = 0
            var res2: Int = 0
            var valid: Bool = true
            for j in info[i].ids {
                if cur_mat[j] == 0 {
                    valid = false
                }
            }
            if !valid {
                continue
            }
            switch info[i].op {
                case "+":
                    for j in info[i].ids {
                        res1 += cur_mat[j]
                        res2 += cur_mat[j]
                    }
                case "-":
                    res1 = cur_mat[info[i].ids[0]] - cur_mat[info[i].ids[1]]
                    res2 = cur_mat[info[i].ids[1]] - cur_mat[info[i].ids[0]]
                case "*":
                    for j in info[i].ids {
                        if res1 == 0 {
                            res1 = cur_mat[j]
                        } else {
                            res1 *= cur_mat[j]
                        }
                        if res2 == 0 {
                            res2 = cur_mat[j]
                        } else {
                            res2 *= cur_mat[j]
                        }
                    }
                case "/":
                    res1 = cur_mat[info[i].ids[0]] / cur_mat[info[i].ids[1]]
                    res2 = cur_mat[info[i].ids[1]] / cur_mat[info[i].ids[0]]
                default:
                    break
            }
            if res1 == info[i].res || res2 == info[i].res {
                continue
            } else {
                for j in info[i].ids {
                    ret.append(j)
                }
            }
        }
        return ret
    }
    // 检查行列冲突
    public func checkRowAndCol(p: Int) -> [Int] {
        let num = cur_mat[p]
        var ret = [Int]()
        let r = p / size
        let c = p % size
        for j in 0 ..< size {
            if size * r + j != p && cur_mat[size * r + j] == num {
                ret.append(size * r + j)
            }
        }
        for j in 0 ..< size {
            if size * j + c != p && cur_mat[size * j + c] == num {
                ret.append(size * j + c)
            }
        }
        if !ret.isEmpty {
            ret.append(p)
        }
        let chkCal = checkCal()
        for i in chkCal {
            if !ret.contains(where: { $0 == i }) {
                ret.append(i)
            }
        }
        return ret
    }
    
    public func checkDup(p: Int) -> Bool {
        var ret: Bool = false
        let chk = checkRowAndCol(p: p)
        for i in chk {
            if i == p {
                ret = true
            }
        }
        return ret
    }
    
    public func checkCal(p: Int) -> Bool {
        let chk = checkCal()
        return chk.contains(where: { $0 == p })
    }
    
    // 检查游戏结束
    public func isOver() -> Bool {
        for i in 0 ..< size * size {
            if cur_mat[i] != ans[i] {
                return false
            }
        }
        return true
    }
}
