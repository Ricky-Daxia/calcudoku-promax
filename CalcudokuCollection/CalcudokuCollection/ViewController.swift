//
//  ViewController.swift
//  CalcudokuCollection
//
//  Created by 567 on 2023/11/10.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        intro1.text = "APP 介绍："
        intro2.text = "展示了题库中 4X4 5X5 6X6 的聪明格题目"
        intro3.text = "难度类型为 Mixed 每种类型都有 50 道题"
        intro4.text = "致谢：聪明格在线题库"
        intro5.text = "https://krazydad.com/inkies/"
    }


    @IBOutlet weak var intro1: UILabel!
    @IBOutlet weak var intro2: UILabel!
    @IBOutlet weak var intro3: UILabel!
    @IBOutlet weak var intro4: UILabel!
    @IBOutlet weak var intro5: UILabel!
}

