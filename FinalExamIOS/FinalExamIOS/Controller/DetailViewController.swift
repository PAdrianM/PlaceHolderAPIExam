//
//  DetailViewController.swift
//  FinalExamIOS
//
//  Created by Adrian Garcia on 1/31/24.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var toDosSpecificTableView: UITableView!
    
    
    var users: [User] = []
    var todosSpecific: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDosSpecificTableView.delegate = self
        toDosSpecificTableView.dataSource = self
        
        
        // Configurar la tabla users
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellDetail")
        
        // Configurar la tabla todos-specific
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
                    //Se envuelve en el Array y con la funcion prefix se toman los primeros 5 elemntos del arreglo
                    self.users = Array(self.users.prefix(5))
                    
                    //Se recarga la data de manera asincronica
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
        //Determina la cantidad de filas que debe tener la tabla en función de la tabla que está solicitando la información.
        //A traves de operadores ternarios
        return tableView == usersTableView ? users.count : todosSpecific.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellDetail", for: indexPath) as! CustomTableViewCell
        
        if tableView == usersTableView {
            cell.titleLabel.text = users[indexPath.row].name
        } else if tableView == toDosSpecificTableView {
            let todo = todosSpecific[indexPath.row]
            cell.titleLabel.text = todo.title
            
//            // Configurar el color del checkmark según el valor de "completed"
//            if todo.completed {
//                cell.checkImageView.tintColor = UIColor.systemGreen
//            } else {
//                cell.checkImageView.tintColor = UIColor.systemRed
//            
//            }
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
                    
                    //Se recarga la data de manera asincronica
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
            // Cuando se selecciona una celda en usersTableView, cargar los todos específicos
            let selectedUserID = users[indexPath.row].id
            loadTodosSpecific(userID: selectedUserID)
        } else if tableView == toDosSpecificTableView {
            // Cuando se selecciona una celda en toDosSpecificTableView
            let selectedTodo = todosSpecific[indexPath.row]
            
            // Crear una copia mutable del modelo y modificar la propiedad 'completed'
            let mutableTodo = Todo(title: selectedTodo.title, userId: selectedTodo.userId, completed: !selectedTodo.completed)
            
            // Reemplazar el elemento en el arreglo con el modelo modificado
            todosSpecific[indexPath.row] = mutableTodo
            
            // Recargar la celda
            tableView.reloadRows(at: [indexPath], with: .none)
            
            // Deseleccionar la celda para que no quede resaltada
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == toDosSpecificTableView {
            // Configurar el color del checkmark al cargar la celda
            let todo = todosSpecific[indexPath.row]
            let color: UIColor = todo.completed ? .systemGreen : .systemRed // Cambiar el orden de colores
            if let customCell = cell as? CustomTableViewCell {
                customCell.checkImageView.tintColor = color
            }
            // Asegurarse de que la propiedad `selectionStyle` esté configurada como `.none`
            cell.selectionStyle = .none
        }
    }
    
}

