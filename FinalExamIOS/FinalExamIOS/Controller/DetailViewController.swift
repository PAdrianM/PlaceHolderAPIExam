//
//  DetailViewController.swift
//  FinalExamIOS
//
//  Created by Andrea Hernandez on 1/31/24.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var toDosSpecificTableView: UITableView!
    
    
    var users: [User] = []
    var todosSpecific: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar las tablas
           usersTableView.delegate = self
           usersTableView.dataSource = self
           usersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellDetail")

           toDosSpecificTableView.delegate = self
           toDosSpecificTableView.dataSource = self
           toDosSpecificTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellDetail")

           
        
        // Llamar a la función para cargar los users
        loadUsers()
    }
    
    // Función para cargar los users desde la API
    func loadUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.users = try decoder.decode([User].self, from: data)

                    // Limitar a 5 registros
                    self.users = Array(self.users.prefix(5))

                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    // Funciones de UITableViewDelegate y UITableViewDataSource para usersTableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == usersTableView ? users.count : todosSpecific.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellDetail", for: indexPath) as! CustomTableViewCell

        if tableView == usersTableView {
            cell.titleLabel.text = users[indexPath.row].name
        } else if tableView == toDosSpecificTableView {
            let todo = todosSpecific[indexPath.row]
            cell.titleLabel.text = todo.title

            // Configurar la imagen del checkmark según el valor de "completed"
            if todo.completed {
                cell.checkImageView.tintColor = UIColor.systemRed
            } else {
                cell.checkImageView.tintColor = UIColor.systemGreen
            }
        }

        return cell
    }
    
    // Función para cargar los todos específicos desde la API según el userID seleccionado
    func loadTodosSpecific(userID: Int) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos?userId=\(userID)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.todosSpecific = try decoder.decode([Todo].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.toDosSpecificTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    // Función para manejar la selección de una celda en usersTableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == usersTableView {
            let selectedUserID = users[indexPath.row].id
            loadTodosSpecific(userID: selectedUserID)
        }
    }
    
}

