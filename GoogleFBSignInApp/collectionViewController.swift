//
//  collectionViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 24/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
struct Moment: Decodable {
    let `Type` : String!
    let MomentUrl : String!
}
class collectionViewController: UIViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var serachBar: UISearchBar!
    @IBOutlet weak var CollectionView: UICollectionView!
    var footerView:CustomFooterView?
    var alert : LoginViewController?
    var items = [Int]()
    var isLoading:Bool = false
    var images : [Moment] = []
    var Momentdata : [Moment] = []
    let footerViewReuseIdentifier = "RefreshFooterView"
    var startIndex : Int = 1
    var stopIndex : Int = 5
    var StrSearchedText : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        self.serachBar.delegate = self
        //getData()
        // Do any additional setup after loading the view, typically from a nib.
        self.CollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        self.CollectionView.register(UINib(nibName: "customCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCell")
        getData()
        for i:Int in 1...25 {
            items.append(i)
        }
    }
    func getData() {
        let url = URL(string: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Moment/GetMoments?iStartIndex=\(self.startIndex)&iEndIndex=\(self.stopIndex)&strSearch=\(self.StrSearchedText)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do {
                    self.images = try JSONDecoder().decode([Moment].self, from: data!)
                    self.Momentdata.append(contentsOf: self.images)
                    //let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    //print(json)
                }catch {
                    print("parse error")
                }
                DispatchQueue.main.async {
                    print("get Data")
                    print("Count Of Objects in Images \(self.images.count)")
                    print("Count Of Objects in Momentsdata \(self.Momentdata.count)")
                    if self.images.count != 0 {
                        self.CollectionView.reloadData()
                    }
                    else
                    {
                        //self.footerView?.stopAnimate()
                        self.footerView?.prepareInitialAnimation()
                    }
                }
                
            }
            else
            {
               self.alert?.CreateAlert(tittle: "Ooops", message: "No Internet")
            }
            }.resume()
    }
    func clearAndGetData() {
        print("In Clear Data")
        self.startIndex = 1
        self.stopIndex = 5
        self.images.removeAll()
        self.Momentdata.removeAll()
        self.getData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.StrSearchedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        //clearAndGetData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        clearAndGetData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.StrSearchedText = ""
        serachBar.resignFirstResponder()
        clearAndGetData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCell", for: indexPath) as! customCollectionViewCell
        //cell.backgroundColor = UIColor.green
        //cell.layer.cornerRadius = 30
        cell.cellTextLabel?.text = "\(Momentdata[indexPath.row].Type!)"
        cell.imageCell.downloadedFrom(link: Momentdata[indexPath.row].MomentUrl)
        //cell.imageCell.downloadImageFrom(link: Momentdata[indexPath.row].MomentUrl)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.items.count
        //return Momentdata.count
        return Momentdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 405.0, height: 330.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return UIEdgeInsetsMake(20, 30, 20, 30)
        return UIEdgeInsetsMake(20, 30, 30, 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 50.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = fabs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    print("in scroll")
                    self.startIndex = self.stopIndex + 1
                    self.stopIndex = self.startIndex + 4
                    self.getData()
                    self.isLoading = false
                })
            }
        }
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
extension UIImageView {
    func downloadImageFrom(link: String,contentMode mode: UIViewContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadImageFrom(url: url, contentMode: mode)
    }
    
    func downloadImageFrom(url: URL,contentMode mode: UIViewContentMode = .scaleToFill) {
        let imageCache = NSCache<NSString, AnyObject>()
        //var imageURLString: String?
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
                }.resume()
        }
    }
}
