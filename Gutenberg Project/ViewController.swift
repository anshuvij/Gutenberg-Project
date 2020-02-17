//
//  ViewController.swift
//  Gutenberg Project
//
//  Created by Anshu Vij on 2/12/20.
//  Copyright © 2020 Anshu Vij. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fictionOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func loadFictionOutlet(_ sender: UIButton) {
        
        var category : String?
        
        print("tag:\(sender.tag)")
        switch sender.tag {
        case 1:
            category = "Fiction"
          case 2:
            category = "Drama"
        case 3:
            category = "Humor"
        case 4:
        category = "Politics"
        case 5:
        category = "Philosophy"
        case 6:
        category = "History"
        case 7:
            category = "Adventure"
            
        default:
            category = "Fiction"
        }
        let backItem = UIBarButtonItem()
        backItem.title = category
        backItem.tintColor = UIColor(red: 94/255, green: 86/255, blue: 231/255, alpha: 1)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 20)!], for: .normal) // your textattributes here
        navigationItem.backBarButtonItem = backItem
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        secondViewController.category =  category
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
}



