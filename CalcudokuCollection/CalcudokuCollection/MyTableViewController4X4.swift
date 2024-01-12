//
//  myTableViewController.swift
//  CalcudokuCollection
//
//  Created by 567 on 2023/11/10.
//

import UIKit

class MyTableViewController4X4: UITableViewController {

    var fileName: String = "4X4"
    var urlList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 获取项目的主Bundle
        let bundle = Bundle.main

        // 获取文件路径
        if let filePath = bundle.path(forResource: fileName, ofType: "txt") {
            // 打开文件
            let fileHandle: FileHandle?
            do {
                fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: filePath))
            } catch {
                print("Error opening file: \(error)")
                fileHandle = nil
            }

            // 检查文件是否成功打开
            if let fileHandle = fileHandle {
                defer {
                    // 关闭文件
                    fileHandle.closeFile()
                }

                // 读取文件内容
                let data = fileHandle.readDataToEndOfFile()
                if let content = String(data: data, encoding: .utf8) {
                    // 将文件内容按行分割
                    let lines = content.components(separatedBy: .newlines)

                    // 遍历每一行
                    for line in lines {
                        urlList.append(line)
                    }
                } else {
                    print("Error decoding file content.")
                }
            } else {
                print("File not found or unable to open.")
            }
        } else {
            print("File not found.")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "4X4 Book \(indexPath.section * 10 + indexPath.row + 1)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "show", sender: indexPath)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "show", let indexPath = sender as? IndexPath {
            if let destinationVC = segue.destination as? MyViewController {
                destinationVC.url = urlList[indexPath.section * 10 + indexPath.row]
                print(urlList[indexPath.section * 10 + indexPath.row])
            }
        }
    }
    

}
