//
//  MomentViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 22/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
struct Moment: Decodable {
    let `Type` : String!
    let MomentUrl : String!
}
class MomentViewController: UIViewController, UICollectionViewDataSource,UISearchBarDelegate {
    var images = [Moment]()
    private var filteredObj: [Moment] = []
    var SearchedType: String!
    var imageLink: String!
    var isFiltering : Bool = false
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func btnBack(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "LoggedIn")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.center = self.view.center
        indicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(indicator)
        indicator.startAnimating()
        searchBar.delegate = self
        collectionView.dataSource = self
        let url = URL(string: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Moment/GetMoments")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    DispatchQueue.main.async {
                        if !self.indicator.isAnimating {
                            self.indicator.startAnimating()
                            print("Was OFF")
                        }
                        else
                        {
                            print("Is ON")
                        }
                    }
                    self.images = try JSONDecoder().decode([Moment].self, from: data!)
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print(json)
                }catch {
                    print("parse error")
                }
                DispatchQueue.main.async {
                    print(self.images.count)
                    self.indicator.stopAnimating()
                    self.collectionView.reloadData()
                }
                
            }
            }.resume()
        
    }
    func objects(at indexPath: IndexPath) -> String {
        if isFiltering {
            return filteredObj[indexPath.row].MomentUrl
        } else {
            return images[indexPath.row].MomentUrl
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredObj.count
        }else {
            return images.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        
        let moment = objects(at: indexPath)
        cell.imageCell.downloadedFrom(link: moment)
        return cell
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.SearchedType = searchText
        let searchItems = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        filterMoment(searchItem: searchItems)
        self.collectionView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //dont filter
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filterMoment(searchItem: "")
        self.collectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    func filterMoment(searchItem: String) {
        if searchItem.isEmpty {
            isFiltering = false
            filteredObj.removeAll()
        } else {
            isFiltering = true
            let searchItems = searchItem.trimmingCharacters(in: .whitespacesAndNewlines)
            filteredObj = images.filter({ (e:Moment) -> Bool in
                return (e.Type.contains(searchItems))
                
            })
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

