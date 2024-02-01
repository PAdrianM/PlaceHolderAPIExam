//
//  ViewController.swift
//  FinalExamIOS
//
//  Created by Andrea Hernandez on 1/31/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInButtonPressed(_ sender: UIButton) {
        
        //Instanciamos el storybord como UItoryboard y nombramos el viewController que usaremos
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        //LLamamos el el viewController al que deseamos llegar con el Storyboard ID
        let nuevoViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        //Pusheamos a la nueva ventana a traves del naigationController
        navigationController?.pushViewController(nuevoViewController, animated: true)
    }
    
}

