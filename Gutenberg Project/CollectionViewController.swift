//
//  CollectionViewController.swift
//  Gutenberg Project
//
//  Created by Anshu Vij on 2/14/20.
//  Copyright © 2020 Anshu Vij. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var category: String?
    var apiUrl : URL?
    var articles: Array<Dictionary<String,Any>> = [];
    var pageNumber = 1
    var isDataLoading = false
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let arrays = articles[indexPath.row]
        cell.titleLabel.text = (arrays["title"] as! String)
        let authors = arrays["authors"] as? [Dictionary<String,Any>]
        if  (authors!.count > 0)
        {
            
            let authNAme = authors?[0]["name"] as? String
            let array = authNAme?.components(separatedBy: ", ")
            if array!.count>1
            {
            cell.authorLabel.text =  array![1]+" "+array![0]
            }
            else
            {
                cell.authorLabel.text =  array![0]
                
            }
        }
        
       let imageJson = arrays["formats"] as? Dictionary<String,Any>
        guard let imageUrl = imageJson?["image/jpeg"] as? String
        else
        {
            return cell
        }
        
        guard let url = URL(string: imageUrl) else { return cell }
           
          
           
           DispatchQueue.global().async {
               let data = try? Data(contentsOf: url)
               
               if let data = data, let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                    cell.imageView.image = image
                       
                       
                   }
               }
           }
               return cell;
        
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
          
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2);
      }
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         perform((#selector(self.reloadData)),with: searchBar, afterDelay: 0.75)
        
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//
//
//    }
//   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reloadData), object: searchBar)
//        perform((#selector(self.reloadData)),with: searchBar, afterDelay: 0.75)
//    }
    
    @objc func reloadData()
    {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        apiUrl =  URL(string :"http://gutendex.com/books/?search="+query)
        loadData(apiUrl: apiUrl!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self;
        collectionView.dataSource = self;
         searchBar.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // apiUrl = URL(string : "http://gutendex.com/books/?category="+category!)
        let numberOfCellsPerRow: CGFloat = 3
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
             apiUrl = URL(string : "http://skunkworks.ignitesol.com:8000/books/?category="+category!+"&page=\(pageNumber)")
        }
       
        loadData(apiUrl: apiUrl!)
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(apiUrl : URL){
      //  http://skunkworks.ignitesol.com:8000/books/?category=Fiction&page=2
       
        let session = URLSession.shared.dataTask(with: URLRequest(url : apiUrl)) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode != 200) {
                        //DIE AND SHOW ERROR MESSAGE
                    }
                }
                if let myData = data {
                    if let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String,Any> {

                        
                         
                                if let articles = json["results"] as? Array<Dictionary<String,Any>> {
                                    self.articles = articles
                                    self.isDataLoading = false
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
                                } else {

                                 
                                }
                            
                        
                    } else {
                        print("Error");
                    }
                }
 
    }
        session.resume();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
