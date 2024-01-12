//
//  Inky1Controller.swift
//  CalcudokuCollection
//
//  Created by 567 on 2024/1/11.
//

import UIKit


class Inky1Controller: UIViewController {
    
    var size: Int = 0
    var constraints: [String] = []
    var answer: [String] = []
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    
    var p: [Int] = []
    var info: [Group] = []
    
    var cur: Int = -1
    
    func find(x: Int) -> Int {
        if p[x] != x {
            p[x] = find(x: p[x])
        }
        return p[x]
    }
    
    var calcudoku = Calcudoku()
    
    var nums: [UIButton] = []
    var delete: UIButton = UIButton()
    var reset: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let num_st_x = 75
        let num_st_y = 500
        for i in 0 ..< 6 {
            let button = UIButton()
            nums.append(button)
            button.frame = CGRect(x: num_st_x + 65 * (i % 4), y: num_st_y + 65 * (i / 4), width: 60, height: 60)
            button.setTitle(String(i + 1), for: .normal)
            button.isEnabled = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.addTarget(self, action: #selector(numTouched(_:)), for: .touchUpInside)
//            TODO
            button.tag = i + 1
            self.view.addSubview(button)
        }
        delete.frame = CGRect(x: num_st_x + 65 * 2, y: num_st_y + 65, width: 60, height: 60)
        delete.setTitle("del", for: .normal)
        delete.isEnabled = true
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        delete.setTitleColor(UIColor.black, for: .normal)
        delete.layer.cornerRadius = 5
        delete.layer.masksToBounds = true
        delete.layer.borderWidth = 2
        delete.layer.borderColor = UIColor.black.cgColor
        delete.addTarget(self, action: #selector(deleteTouched(_:)), for: .touchUpInside)
        self.view.addSubview(delete)
        reset.frame = CGRect(x: num_st_x + 65 * 3, y: num_st_y + 65, width: 60, height: 60)
        reset.setTitle("reset", for: .normal)
        reset.isEnabled = true
        reset.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        reset.setTitleColor(UIColor.black, for: .normal)
        reset.layer.cornerRadius = 5
        reset.layer.masksToBounds = true
        reset.layer.borderWidth = 2
        reset.layer.borderColor = UIColor.black.cgColor
        reset.addTarget(self, action: #selector(clearTouched(_:)), for: .touchUpInside)
        self.view.addSubview(reset)
        
        let bundle = Bundle.main
        if let filePath = bundle.path(forResource: "inky1", ofType: "txt") {
            let fileHandle: FileHandle?
            do {
                fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: filePath))
            } catch {
                print("Error opening file: \(error)")
                fileHandle = nil
            }
            
            if let fileHandle = fileHandle {
                defer {
                    fileHandle.closeFile()
                }
                let data = fileHandle.readDataToEndOfFile()
                if let content = String(data: data, encoding: .utf8) {
                    let lines = content.components(separatedBy: .newlines)
                    var i = 0
                    var st = false
                    for line in lines {
                        if i == 0 {
                            size = Int(line)!
                        } else if line == "%" {
                            st = true
                        } else if !st {
                            constraints.append(line)
                        } else if st {
                            answer.append(line)
                        }
                        i += 1
                    }
                } else {
                    print("Error decoding file content.")
                }
            } else {
                print("File not found or unable to open.")
            }
            
            parse()
        }
    }
    
    func parse() -> Void {
        calcudoku.setSize(sz: size)
        for i in 0 ..< size * size {
            buttons.append(UIButton())
            p.append(i)
        }
        for str in constraints {
            var begin = false
            var readOp = false
            var readRes = false
            var id1 = 0
            var con = Group()
            var res = 0
            for i in 0 ..< str.count {
                let c = str[str.index(str.startIndex, offsetBy: i)]
                if c == "[" {
                    begin = true
                } else if c == "]" {
                    con.ids.append(id1)
                    begin = false
                    readOp = true
                } else if c == " " {
                    continue
                } else if c == "," {
                    if begin {
                        con.ids.append(id1)
                        id1 = 0
                    }
                } else if begin {
                    if let digit = c.wholeNumberValue {
                        id1 = id1 * 10 + digit
                    }
                } else if readOp {
                    switch c {
                        case "a": con.op = "+"
                        case "s": con.op = "-"
                        case "m": con.op = "*"
                        case "d": con.op = "/"
                        default:
                            con.op = "e"
                    }
                    readOp = false
                    readRes = true
                } else if readRes {
                    if let digit = c.wholeNumberValue {
                        res = res * 10 + digit
                    }
                }
            }
            con.res = res
            info.append(con)
            calcudoku.addInfo(con: con)
        }
        for str in answer {
            for i in 0 ..< str.count {
                let c = str[str.index(str.startIndex, offsetBy: i)]
                if let digit = c.wholeNumberValue {
                    calcudoku.addAns(digit: digit)
                }
            }
        }
        
        initButton()
    }
    
    func initButton() -> Void {
        let st_x = 50
        let st_y = 150
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            button.frame = CGRect(x: st_x + 75 * (i % 4), y: st_y + 75 * (i / 4), width: 75, height: 75)
            button.isEnabled = true
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            button.tag = i
            button.addTarget(self, action: #selector(cellTouched(_:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
        for con in info {
            for i in 1 ..< con.ids.count {
                p[find(x: con.ids[i])] = find(x: con.ids[0])
            }
            let s = String(con.res) + " " + String(con.op)
            let label = UILabel(frame: CGRect(x: buttons[con.ids[0]].frame.origin.x + 5, y: buttons[con.ids[0]].frame.origin.y, width: 75, height: 30))
            label.text = s
            labels.append(label)
            self.view.addSubview(label)
        }
        for i in 0 ..< size * size {
            // right
            if i % size < size - 1 && p[i] != p[i + 1] {
                addLeft(button: buttons[i + 1])
                addRight(button: buttons[i])
            }
            // up
            if i >= size && p[i] != p[i - size] {
                addTop(button: buttons[i])
                addButtom(button: buttons[i - size])
            }
            // border
            if i % size == 0 {
                addLeft(button: buttons[i])
            }
            if i < size {
                addTop(button: buttons[i])
            }
            if i % size == size - 1 {
                addRight(button: buttons[i])
            }
            if (i >= size * (size - 1)) {
                addButtom(button: buttons[i])
            }
        }
    }
    
    func addTop(button: UIButton) -> Void {
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: 0, width: button.frame.size.width, height: 3.0)
        button.layer.addSublayer(border)
    }
    
    func addRight(button: UIButton) -> Void {
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: button.frame.size.width, y: 0, width: 3.0, height: button.frame.size.height)
        button.layer.addSublayer(border)
    }
    
    func addButtom(button: UIButton) -> Void {
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: button.frame.size.height, width: button.frame.size.width, height: 3.0)
        button.layer.addSublayer(border)
    }
    
    func addLeft(button: UIButton) -> Void {
        let border = CALayer()
        border.backgroundColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: 0, width: 3.0, height: button.frame.size.height)
        button.layer.addSublayer(border)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func cellTouched(_ sender: UIButton) {
        if cur != -1 {
            buttons[cur].backgroundColor = UIColor.white
        }
        cur = sender.tag
        buttons[cur].backgroundColor = UIColor.orange
    }
    
    
    @objc func numTouched(_ sender: UIButton) {
        if cur == -1 {
            return
        }
        let num = sender.tag
        if num > size {
            return
        }
        self.calcudoku.setNum(p: cur, num: num)
        // TODO: check the same row and line and set red
        buttons[cur].setTitle(String(num), for: .normal)
        buttons[cur].setTitleColor(UIColor.black, for: .normal)
        buttons[cur].titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        for button in buttons {
                button.setTitleColor(UIColor.black, for: .normal)
        }
        let chk = calcudoku.checkRowAndCol(p: cur)
        for i in chk {
            if calcudoku.getNum(p: i) == 0 {
                continue
            }
            buttons[i].setTitleColor(UIColor.red, for: .normal)
        }
        // TODO: check if game finishes
        if calcudoku.isOver() {
            let alertController = UIAlertController(title: "Congratulations!", message: "You have won!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Got it.", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        buttons[cur].backgroundColor = UIColor.white
        cur = -1
    }
    

    @objc func deleteTouched(_ sender: UIButton) {
        if cur == -1 {
            return
        }
        calcudoku.setNum(p: cur, num: 0)
        buttons[cur].setTitle("", for: .normal)
        for i in 0 ..< size * size {
            if calcudoku.getNum(p: i) != 0 && !calcudoku.checkDup(p: i) && !calcudoku.checkCal(p: i) {
                    buttons[i].setTitleColor(UIColor.black, for: .normal)
            }
        }
        buttons[cur].backgroundColor = UIColor.white
        cur = -1
    }
    
    
    @objc func clearTouched(_ sender: UIButton) {
        if cur != -1 {
            buttons[cur].backgroundColor = UIColor.white
        }
        cur = -1
        calcudoku.clear()
        // TODO: set all cells title empty
        for button in buttons {
            button.setTitle("", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
        }
    }
}
