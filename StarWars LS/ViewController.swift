//
//  ViewController.swift
//  StarWars LS
//
//  Created by Akib Shahjahan on 2020-07-28.
//  Copyright © 2020 Akib Shahjahan. All rights reserved.
//

import UIKit
import TinyNetworking

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let apiURL: String = "https://swapi.dev/api/people"
    var people: Array<Person> = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        populatePeople(pageURL: apiURL)
    }
    
    /**
        Sets delegate and datasource for the tableView and modifies design
    */
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .white
    }

    /**
        Fetches all the star wars characters and poulates the tableView
        - Parameter pageURL:  The url for the swapi endpoint to retrieve  list of characters
    */
    func populatePeople(pageURL: String) {
        let endpoint = Endpoint(json: .get, url: URL(string: pageURL)!) as Endpoint<People>
        URLSession.shared.load(endpoint) { result in
            do {
                try self.people.append(contentsOf: result.get().results)
                self.people.sort(){ $0.name.lowercased() < $1.name.lowercased() } // nlogn (introsort)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                let next = try result.get().next
                if (next != nil) {
                    self.populatePeople(pageURL: next!)
                }
            } catch {
                print(error)

                if (self.people.count == 0){
                    DispatchQueue.main.async {
                        self.showAlert(title: "Sorry", message: "We are having difficulties fetching character list.")
                    }
                }
            }
        }
    }
    
    /**
       Fetches all the star wars characters and poulates the TableView
       - Parameters:
            - title:  Title for the Alert popup
            - message: Message for the Alert popup
    */
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

// MARK: - TableView Delegate and DataSource function implementations

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC: DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        detailVC.detail = people[indexPath.row]
        self.present(detailVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0; // Gets Rid of Line Limit
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Star Wars Characters"
    }
}

