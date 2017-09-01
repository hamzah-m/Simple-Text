//
//  ViewController.swift
//  Simple Text
//
//  Created by Hamzah Mugharbil on 8/20/17.
//  Copyright © 2017 Hamzah Mugharbil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var table: UITableView!
    var data: Data = Data()
    var filteredData: Data = Data()
    var selectedRow: Int = -1
    var newRowText: String = ""
    let formatter = DateFormatter()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        
        
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(goToSettings))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = settingsButton
        load()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
    }
    
    func updateTheme() {
    
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        for note in data.notes {
            if note.contains(searchText) {
                filteredData.notes.insert(note, at: 0)
            }
        }
        table.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 { return }
        
        data.notes[selectedRow] = newRowText
        if newRowText == "" {
            data.notes.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }
    
    func addNote() {
        let dateCreated = Date()
        data.creationDates.insert(dateCreated, at: 0)
        let name: String = ""
        data.notes.insert(name, at: 0)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
        
    }
    
    func goToSettings() {
        self.performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredData.notes.count
        }
        
        return data.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        
        if isFiltering() {
            cell.titleLabel.text = getTitle(for: indexPath.row)
        } else {
            cell.dateLabel.text = getDate(for: indexPath.row)
            cell.titleLabel.text = getTitle(for: indexPath.row)
            cell.subtitleLabel.text = getBody(for: indexPath.row)
        }
        return cell
    }
    
    func getDate(for row: Int) -> String {
        formatter.dateFormat = "dd/mm/yyy hh:mm:ss a"
        return formatter.string(from: data.creationDates[row])
    }
    
    func getTitle(for row: Int) -> String {
        if data.notes[row].contains("\n") {
            let range = data.notes[row].range(of: "\n")
            let rangeOfString = data.notes[row].startIndex..<(range?.upperBound)!
            return data.notes[row].substring(with: rangeOfString)
        }
        return data.notes[row]
    }
    
    func getBody(for row: Int) -> String {
        if data.notes[row].contains("\n") {
            let range = data.notes[row].range(of: "\n")
            let rangeOfString = (range?.upperBound)! ..< data.notes[row].endIndex
            
            return data.notes[row].substring(with: rangeOfString)
        }
        return ""
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.notes.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailView: DetailViewController = segue.destination as! DetailViewController
            selectedRow = table.indexPathForSelectedRow!.row
            detailView.masterView = self
            detailView.setText(t: data.notes[selectedRow])
        }
    }
    
    func save() {
        UserDefaults.standard.set(data.notes, forKey: "notes")
        UserDefaults.standard.set(data.creationDates, forKey: "dates")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let loadedNotes = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data.notes = loadedNotes
            table.reloadData()
        }
        if let loadedDates = UserDefaults.standard.value(forKey: "dates") as? [Date] {
            data.creationDates = loadedDates
            table.reloadData()
        }
    }
}

