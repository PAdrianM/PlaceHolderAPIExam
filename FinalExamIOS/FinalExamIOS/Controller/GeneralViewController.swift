//
//  GeneralViewController.swift
//  FinalExamIOS
//
//  Created by Adrian Garcia on 1/31/24.
//

import UIKit

class GeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var toDosTableView: UITableView!
    
    var posts: [Post] = []
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar las tablas
        toDosTableView.delegate = self
        toDosTableView.dataSource = self
        toDosTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // Configurar la tabla
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // Llamar a la función para cargar los posts desde la API
        loadPosts()
        loadTodos()
    }
    
    
    // Función para cargar los posts desde la API
    func loadPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    // Decodificar los datos de la respuesta JSON
                    let decoder = JSONDecoder()
                    self.posts = try decoder.decode([Post].self, from: data)
                    
                    // Limitar a 10 registros
                    self.posts = Array(self.posts.prefix(10))
                    
                    // Actualizar la interfaz en el hilo principal
                    DispatchQueue.main.async {
                        self.postsTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    // Función para cargar los todos desde la API
    func loadTodos() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.todos = try decoder.decode([Todo].self, from: data)
                    self.todos = Array(self.todos.prefix(10)) // Limitar a 10 registros
                    
                    DispatchQueue.main.async {
                        self.toDosTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    
    // Funciones de UITableViewDelegate y UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == postsTableView ? posts.count : todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        // Configurar la celda según la tabla
        if tableView == postsTableView {
            cell.titleLabel.text = posts[indexPath.row].title
        } else if tableView == toDosTableView {
            cell.titleLabel.text = todos[indexPath.row].title
        }
        
        return cell
    }
}
