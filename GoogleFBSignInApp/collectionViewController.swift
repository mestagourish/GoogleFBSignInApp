//
//  collectionViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 24/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class collectionViewController: UIViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //var ARCardType: String!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var CollectionView: UICollectionView!
    var footerView:CustomFooterView?
    var alert : LoginViewController?
    var isLoading:Bool = false
    var images : [Moment] = []
    var Momentdata : [Moment] = []
    let footerViewReuseIdentifier = "RefreshFooterView"
    var startIndex : Int = 1
    var stopIndex : Int = 5
    var StrSearchedText : String = ""
    var strData : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //fatalError()
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        self.searchBar.delegate = self
        //searchTextField.rightViewMode = .always
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = #colorLiteral(red: 0.9810437817, green: 0.9810437817, blue: 0.9810437817, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        self.CollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        self.CollectionView.register(UINib(nibName: "customCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCell")
        /*
         06/07/2018
         logic to check for internet connectivity
         if true then calls the getdata function which makes api call
         else gives an alert 
        */
        if Conectivity.isConnectedToInternet()
        {
            print("Yes! internet is available.")
            ActivityLoader.StartAnimating(view: self.view)
            getData()
        }
        else
        {
            DispatchQueue.main.async {
                ActivityLoader.StopAnimating(view: self.view)
                CreateAlerts.DisplayAlert(tittle: "Alert", message: "Check your Internet Conectivity", view: UIApplication.topViewController()!)
            }
        }
        //self.CollectionView.contentInset.bottom = 30.0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let searchTextField:UITextField = searchBar.subviews[0].subviews.last as! UITextField
        //var bounds : CGRect!
        //bounds = searchTextField.frame
        //bounds.size.height = 57
        //searchTextField.bounds = bounds
        searchTextField.borderStyle = .none
        searchTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 15
        searchTextField.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        searchTextField.layer.masksToBounds = true
        //searchTextField.textAlignment = NSTextAlignment.left
       /* let image:UIImage = UIImage(named: "search_icon 40x40")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.placeholder = "  Search"
        searchTextField.textAlignment = NSTextAlignment.center
        searchTextField.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextFieldViewMode.always
        let arbitraryValue: Int = 5
        if let newPosition = searchTextField.position(from: searchTextField.beginningOfDocument, in: UITextLayoutDirection.right, offset: arbitraryValue){
            searchTextField.selectedTextRange = searchTextField.textRange(from: newPosition, to: newPosition)
        }*/
        /*let arbitraryValue: Int = 5
        if let newPosition = searchTextField.position(from: searchTextField.beginningOfDocument, offset: arbitraryValue) {
            
            searchTextField.selectedTextRange = searchTextField.textRange(from: newPosition, to: newPosition)
        }*/
    }
    /*
     24/05/2018
     Function calls the getMoment api gets the Moment screen Data
      stores the Moment image,type and id in the array object
    */
    func getData() {
        let url = URL(string: "\(AppSettings.Urls.strMomentUrl)iStartIndex=\(self.startIndex)&iEndIndex=\(self.stopIndex)&strSearch=\(self.StrSearchedText)")
        ApiServiceMethod.GetRequest(url: url!, iDataToDecode: 0) { (images,berror) in
            if !berror {
                 ActivityLoader.StopAnimating(view: self.view)
                print(images)
                self.images = images as! [Moment]
                self.Momentdata.append(contentsOf: self.images)
                DispatchQueue.main.async {
                    print("Count Of Objects in Images \(self.images.count)")
                    print("Count Of Objects in Momentsdata \(self.Momentdata.count)")
                    if self.images.count != 0 {
                        //reloads the collection view with new Moment Images and thier Type
                        self.CollectionView.reloadData()
                    }
                    else
                    {
                        self.footerView?.prepareInitialAnimation()
                    }
                }
            }
            else
            {
                ActivityLoader.StopAnimating(view: self.view)
            }
            
        }
        
    }
    //Function clears the image and Moment objects and gets new Moment Data
    func clearAndGetData() {
        print("In Clear Data")
        self.startIndex = 1
        self.stopIndex = 5
        self.images.removeAll()
        self.Momentdata.removeAll()
        self.getData()
        
    }
    //search bar on text change Event
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.StrSearchedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        //clearAndGetData()
    }
    //search bar Text Did Begin Editing change Event
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    //search bar Text Did end Editing change Event
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    /*Search bar search Button Clicked event
     hides the keypad and gets the data
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        clearAndGetData()
    }
    /*search bar Cancel button Clicked event
     clears the search bar text, hides the keypad and calls the clearAndGetData function
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.StrSearchedText = ""
        searchBar.resignFirstResponder()
        clearAndGetData()
    }
    
   /* override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let searchTextField:UITextField = searchBar.subviews[0].subviews.last as! UITextField
        searchTextField.borderStyle = .none
        searchTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 15
        searchTextField.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        searchTextField.layer.masksToBounds = true
        //searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "search_icon 40x40")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = NSTextAlignment.center
        searchTextField.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextFieldViewMode.always
        if let selectedRange = searchTextField.selectedTextRange {
            
            // and only if the new position is valid
            if let newPosition = searchTextField.position(from: selectedRange.start, offset: +1) {
                
                // set the new position
                searchTextField.selectedTextRange = searchTextField.textRange(from: newPosition, to: newPosition)
            }
        }
        //searchTextField.rightViewMode = .always
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     18/05/2018
     UICollection View    */
    //defines No of section in the collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //Function returs the Count of the data in the Moment object
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Momentdata.count
    }
    
    //Assign the Collection view Cell with the Images and the image Type text
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCell", for: indexPath) as! customCollectionViewCell
        cell.cellTextLabel?.text = "\(Momentdata[indexPath.row].Type!)"
        cell.imageCell.downloadedFrom(link: Momentdata[indexPath.row].ImageUrl!)
        //cell.btnGet.accessibilityValue = Momentdata[indexPath.row].Type
        //cell.btnGet.tag = Momentdata[indexPath.row].ARCardID
        cell.btnGet.tag = indexPath.row
        //let secondParams = Momentdata[indexPath.row].Type
        cell.btnGet.addTarget(self, action: #selector(handleget), for: .touchUpInside)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        return cell
        
    }
    @objc func handleget(sender: UIButton)
    {
        //print("btn Pressed\(sender.tag)")
        print("ARCard ID = \(sender.tag)")
        setParameter(indexPathRow: sender.tag)
        dispatch()
    }
    func setParameter(indexPathRow : Int)
    {
        staticVariables.strARCode = "\(GetARCode.randomString(length: 5))"
        staticVariables.prevSelectedSongCell = nil
        staticVariables.prevSelectedMessageCell = nil
        staticVariables.prevSelectedAnimationCell = nil
        staticVariables.strRecipentName = ""
        staticVariables.strInitials = ""
        staticVariables.strStreamingUrl = nil
        staticVariables.strVoiceRecordingName = ""
        staticVariables.strVoiceRecordingPath = ""
        staticVariables.strAnimationPath = ""
        staticVariables.strAnimationName = ""
        staticVariables.iARCardId = Momentdata[indexPathRow].ARCardID!
        staticVariables.strARCardType = Momentdata[indexPathRow].Type!
        staticVariables.strMomentUrl = Momentdata[indexPathRow].ImageUrl!
        staticVariables.iMomentID = Momentdata[indexPathRow].MomentID!
        
    }
    //On Image Click Event
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        setParameter(indexPathRow: indexPath.row)
        dispatch()
    }
    //Opens the Create Card View
    func dispatch() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToVideoScreen", sender: self)
        }
    }
    //assigns the ArCardID and ArCardType in Create Card View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if let destination = segue.destination as? CreateCardViewController
        {
            destination.strMomentUrl = strMomentUrl
            destination.iARCardID = iARCardID
            destination.strARCardType = ARCardType
        }*/
    }
   
    //Defines the Image cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        print(width)
        print(height)
        let heightValue = self.view.bottomAnchor.hashValue
        print(Double(heightValue)-20.0)
        //height-286
        return CGSize(width: width-14, height: height-250)
    }
    
    //defines the spaces between the images container
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 1, 40.0, 1)//UIEdgeInsetsMake(top, left, bottom, right)
    }
    //Empty the collection View for images
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
    //Loads the Loader at the bottom Of the Moment Colection View
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
    func goToVideoScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToVideoScreen", sender: self)
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
    
    //compute the offset(the scroll amount) and call the getdata method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = fabs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
            //if loader finished loading then calls then initialize new start and stop index of images and calls the getdata method
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
                /*if #available(iOS 10.0, *) {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                        print("in scroll")
                        self.startIndex = self.stopIndex + 1
                        self.stopIndex = self.startIndex + 4
                        self.getData()
                        self.isLoading = false
                    })
                } else {
                    // Fallback on earlier versions
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
                }*/
            }
        }
    }
    @objc func update()
    {
        print("in scroll")
        self.startIndex = self.stopIndex + 1
        self.stopIndex = self.startIndex + 4
        self.getData()
        self.isLoading = false
    }
}
//External function to get the image from the image URL
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
