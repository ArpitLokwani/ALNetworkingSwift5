//
//  CustomeTableViewController.swift
//  ALNetworking
//
//  Created by Arpit Lokwani on 29/04/20.
//  Copyright © 2020 Arpit Lokwani. All rights reserved.
//

import UIKit

class CustomeTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var customTable: UITableView!
    
    var dataSource = [UserData]()
    var configuration = Configuration()
    let rest = RestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUsersList()
        
        customTable.dataSource = self
        customTable.delegate = self
        customTable.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        if(self.dataSource.count>0){
            let userData:UserData = self.dataSource[indexPath.row]
            
            // let content = exampleContent[indexPath.row]
            
            cell.descriptionLabele?.numberOfLines = 0
            cell.descriptionLabele?.text = userData.data?[indexPath.row].firstName
            
            cell.imageSection.dowloadFromServer(link: (userData.data?[indexPath.row].avatar)!, contentMode: .scaleAspectFill)
            
        }
        return cell
    }
    
    
    func getUsersList() {
        guard let url = URL(string: configuration.environment.baseURL+configuration.environment.method) else { return }
        
        // The following will make RestManager create the following URL:
        // https://reqres.in/api/users?page=2
        // rest.urlQueryParameters.add(value: "2", forKey: "page")
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let userData = try? decoder.decode(UserData.self, from: data) else { return }
                print(userData.description)
                for _ in 0...userData.perPage!-1{
                    self.dataSource.append(userData)
                }
            }
            DispatchQueue.main.async {
                self.customTable.reloadData()
                
            }
            print("\n\nResponse HTTP Headers:\n")
            
            if let response = results.response {
                for (key, value) in response.headers.allValues() {
                    print(key, value)
                }
            }
        }
    }
    
    
    func getNonExistingUser() {
        guard let url = URL(string: configuration.environment.baseURL+configuration.environment.method+"100") else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let _ = results.data, let response = results.response {
                if response.httpStatusCode != 200 {
                    print("\nRequest failed with HTTP status code", response.httpStatusCode, "\n")
                }
            }
        }
    }
    
    
    
    func createUser() {
        guard let url = URL(string: configuration.environment.baseURL+configuration.environment.method) else { return }
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: "John", forKey: "name")
        rest.httpBodyParameters.add(value: "Developer", forKey: "job")
        
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 201 {
                guard let data = results.data else { return }
                let decoder = JSONDecoder()
                guard let jobUser = try? decoder.decode(JobUser.self, from: data) else { return }
                print(jobUser.description)
            }
        }
    }
    
    // For any single User
    
    func getSingleUser() {
        guard let url = URL(string: configuration.environment.baseURL+configuration.environment.method+"1") else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let singleUserData = try? decoder.decode(SingleUserData.self, from: data),
                    let user = singleUserData.data,
                    let avatar = user.avatar,
                    let url = URL(string: avatar) else { return }
                
                self.rest.getData(fromURL: url, completion: { (avatarData) in
                    guard let avatarData = avatarData else { return }
                    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                    let saveURL = cachesDirectory.appendingPathComponent("avatar.jpg")
                    try? avatarData.write(to: saveURL)
                    print("\nSaved Avatar URL:\n\(saveURL)\n")
                })
                
            }
        }
    }
    
    
}
