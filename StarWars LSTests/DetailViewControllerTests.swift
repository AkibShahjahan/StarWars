//
//  DetailViewControllerTests.swift
//  StarWars LSTests
//
//  Created by Akib Shahjahan on 2020-07-28.
//  Copyright © 2020 Akib Shahjahan. All rights reserved.
//

import XCTest
import TinyNetworking
@testable import StarWars_LS

class DetailViewControllerTests: XCTestCase {

    var detailVC: DetailViewController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController
        _ = detailVC?.view // calls the viewDidLoad
    }

    override func tearDown() {
        super.tearDown()
    }

    /// Tests the worCount() function
    func testWordCount() {
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: ""), 0)
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: "        "), 0)
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: "..."), 0)
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: "\r\n\n"), 0)
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: "Hello World!\r\n"), 2)
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: "Hello World!\r\nHello World!"), 4)
        XCTAssertEqual(detailVC?.wordCount(openingCrawl: "It is a dark time for the\r\nRebellion. Although the Death\r\nStar has been destroyed,\r\nImperial troops have driven the\r\nRebel forces from their hidden\r\nbase and pursued them across\r\nthe galaxy.\r\n\r\nEvading the dreaded Imperial\r\nStarfleet, a group of freedom\r\nfighters led by Luke Skywalker\r\nhas established a new secret\r\nbase on the remote ice world\r\nof Hoth.\r\n\r\nThe evil lord Darth Vader,\r\nobsessed with finding young\r\nSkywalker, has dispatched\r\nthousands of remote probes into\r\nthe far reaches of space...."), 81)
    }
    
    /// Tests whether tableView is initialized properly in the DetailViewController
    func testInitTableView() {
        XCTAssertNotNil(detailVC?.tableView)
        XCTAssertTrue(detailVC?.tableView.dataSource is DetailViewController)
        XCTAssertTrue(detailVC?.tableView.delegate is DetailViewController)
    }
    
    /// Tests whether tableView is populated properly with personal details fields
    func testPersonalDetailsPopulation() {
        detailVC?.detail = Person(name: "Bob", birth_year: "1990", height: "170", mass: "150", hair_color: "black", eye_color: "brown", films: [])
        detailVC?.tableDetails = [[], []]
        detailVC?.populatePersonalDetails()

        XCTAssertTrue(detailVC?.tableView.numberOfSections == 2)
        XCTAssertTrue(detailVC?.tableView.numberOfRows(inSection: 0) == 6)

        var indexPath = IndexPath(row: 0, section: 0)
        var cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Name: Bob")
        
        indexPath = IndexPath(row: 1, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Birth Year: 1990")
        
        indexPath = IndexPath(row: 2, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Height: 170")
        
        indexPath = IndexPath(row: 3, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Mass: 150")
        
        indexPath = IndexPath(row: 4, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Hair Color: black")
        
        indexPath = IndexPath(row: 5, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Eye Color: brown")
    }
    
    /// Tests whether tableView is populated properly  when  personal details fields are empty
    func testPersonalDetailsEmpty() {
        detailVC?.tableDetails = [[], []]
        detailVC?.populatePersonalDetails()

        XCTAssertTrue(detailVC?.tableView.numberOfSections == 2)
        XCTAssertTrue(detailVC?.tableView.numberOfRows(inSection: 0) == 6)

        var indexPath = IndexPath(row: 0, section: 0)
        var cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Name: -")
        
        indexPath = IndexPath(row: 1, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Birth Year: -")
        
        indexPath = IndexPath(row: 2, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Height: -")
        
        indexPath = IndexPath(row: 3, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Mass: -")
        
        indexPath = IndexPath(row: 4, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Hair Color: -")
        
        indexPath = IndexPath(row: 5, section: 0)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Eye Color: -")
    }
    
    /// Tests whether film's section in tableView is populated properly
    func testFilmsPopulation() {
        detailVC?.tableDetails = [ [],
            ["The Phantom Menace (78)",
             "Attack of the Clones (80)",
             "Revenge of the Sith (75)"
            ]
        ]
        detailVC?.tableView.reloadData()
        
        XCTAssertTrue(detailVC?.tableView.numberOfSections == 2)
        XCTAssertTrue(detailVC?.tableView.numberOfRows(inSection: 1) == 3)
        
        var indexPath = IndexPath(row: 0, section: 1)
        var cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "The Phantom Menace (78)")
        
        indexPath = IndexPath(row: 1, section: 1)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Attack of the Clones (80)")
        
        indexPath = IndexPath(row: 2, section: 1)
        cell = detailVC?.tableView.cellForRow(at: indexPath)
        XCTAssertTrue(cell?.textLabel?.text == "Revenge of the Sith (75)")
    }
    
    /// Tests whether film's section in tableView is populated properly when there are no films
    func testFilmsEmpty() {
        detailVC?.tableDetails = [[],[]]
        detailVC?.tableView.reloadData()
        
        XCTAssertTrue(detailVC?.tableView.numberOfSections == 2)
        XCTAssertTrue(detailVC?.tableView.numberOfRows(inSection: 1) == 0)
    }
}

