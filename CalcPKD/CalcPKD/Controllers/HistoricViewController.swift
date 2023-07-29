//
//  HistoricViewController.swift
//  CalcPKD
//
//  Created by Philip Dunker on 16/07/23.
//

import SwiftUI
import UIKit

class HistoricViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // UITableView example for Swift
    // Seconde response
    // https://stackoverflow.com/questions/33234180/uitableview-example-for-swift
    var tableView: UITableView = UITableView()
    var animals = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    let cellReuseIdentifier = "cell"

    override func viewDidLoad ()
    {
        super.viewDidLoad()

        self.tableView.frame = CGRectMake(0, 50, 320, 200)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        
        //self.tableView.tableFooterView = UIView()

        self.view.addSubview(tableView)
    }

    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.animals.count
    }

    func tableView (_ tableView: UITableView, didSelectRowAt didSelectRowAtIndexPath: IndexPath)
    {
        print("You tapped cell number \(didSelectRowAtIndexPath.row).")
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
        cell.textLabel!.text = self.animals[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCell.EditingStyle.delete)
        {
            print("removing \(indexPath.row)")
            let animal = self.animals.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            print("\(animal) removed")
        }
    }
}
