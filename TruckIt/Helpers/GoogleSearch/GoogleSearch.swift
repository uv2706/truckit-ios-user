//
//  GoogleSearch.swift
//  GoogleAutoComplete
//
//  Created by Apple on 29/04/18.
//  Copyright © 2018 leena. All rights reserved.
//

import UIKit
import GooglePlaces

import IQKeyboardManagerSwift

class GoogleSearch: UIViewController {
    
    @IBOutlet  weak var searchBar : UISearchBar!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imageBg: UIImageView!
    
    var tableData = [GMSAutocompletePrediction]()
    var fetcher: GMSAutocompleteFetcher?
    var completion:((GMSAutocompletePrediction?, String, Error?)->())!
    
    /// Insatance
    ///
    /// - Returns: SignUpViewController
    class func instance() -> GoogleSearch? {
        return StoryBoard.GoogleSearch.board.instantiateViewController(withIdentifier: AppClass.googleSearch.rawValue) as? GoogleSearch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     if #available(iOS 13.0, *) {
          overrideUserInterfaceStyle = .light
     } else {
          // Fallback on earlier versions
     }
        GMSPlacesClient.provideAPIKey(AppConstants.googleAPIKey)
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "US"
        fetcher  = GMSAutocompleteFetcher()
        fetcher?.autocompleteFilter = filter
        fetcher?.delegate = self
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       // UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        // Do any additional setup after loading the view.
        imageBg.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.09411764706, blue: 0.3450980392, alpha: 1)
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.tintColor = UIColor.white
        searchBar.setPlaceholderTextColorTo(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
    }
    

    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GoogleSearch : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchResultCell
        aCell.lblTitle.text = tableData[indexPath.row].attributedPrimaryText.string
        aCell.lblAddress.text = tableData[indexPath.row].attributedSecondaryText?.string
        return aCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let aPredictor = tableData[indexPath.row]
        let placeClient = GMSPlacesClient.shared()
        var addrsss = tableData[indexPath.row].attributedFullText.string
        placeClient.lookUpPlaceID(aPredictor.placeID) { (place, error) in
            if error == nil
            {
                addrsss = place?.formattedAddress ?? ""
            
            }
            self.completion(self.tableData[indexPath.row],addrsss,nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension GoogleSearch : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetcher?.sourceTextHasChanged(searchBar.text!)
    }// called when text changes (including clear)
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        completion(nil,"",nil)
        dismiss(animated: true, completion: nil)
    }
}

extension GoogleSearch : GMSAutocompleteFetcherDelegate
{
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
      
        tableData.removeAll()
        
        for prediction in predictions{
            
            tableData.append(prediction)
            
        }
        tblView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
     //   completion(nil,error)
       // dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UISearchBar
{
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}

