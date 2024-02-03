//
//  ViewController.swift
//  FinalExamIOS
//
//  Created by Adrian Garcia on 1/31/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        // Validar que ambos campos estén llenos
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please complete all the fields.")
            return
        }
        
        // Llamada a la API para autenticar al usuario
        authenticateUser(email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    // Credenciales válidas, navegar a la siguiente pantalla
                    //Instanciamos el storybord como UItoryboard y nombramos el viewController que usaremos
                    let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
                    //LLamamos el el viewController al que deseamos llegar con el Storyboard ID
                    let newViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                    //Pusheamos a la nueva ventana a traves del naigationController con los parametros ddentro de newViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                    self.passwordTextField.text = ""
                    self.emailTextField.text = ""
                    self.showAlert(message: "Valid credentials with email: \(email) and password: \(password)")
                } else {
                    // Credenciales inválidas, mostrar mensaje de error
                    self.showAlert(message: "Verify that your credentials are correct.")
                }
            }
        }
    }
    
    // Llamada a la API para autenticar al usuario
    func authenticateUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // URL de la API de usuarios
        let apiUrl = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        // Crear la solicitud
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        // Realizar la solicitud
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false) // Fallo en la solicitud
                }
                return
            }
            
            do {
                // Decodificar la respuesta JSON
                let users = try JSONDecoder().decode([User].self, from: data)
                
                // Buscar el usuario con las credenciales ingresadas
                if users.contains(where: { $0.email == email && $0.id == Int(password) }) {
                    DispatchQueue.main.async {
                        completion(true) // Usuario autenticado
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false) // Credenciales inválidas
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false) // Error al decodificar la respuesta JSON
                }
            }
        }
        .resume()
    }
    
    // Función para mostrar una alerta con un mensaje
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

