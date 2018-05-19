//
//  HomeMainViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 28/11/17.
//  Copyright © 2017 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
import QuartzCore



class HomeMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating , NVActivityIndicatorViewable {
    
    
    
    var providersValues = [ProvidersModel]()
    var FilteredprovidersValues = [ProvidersModel]()
    var providersValuesForFilter = [ProvidersModel]()
    
    var providersAPI = APIService()
    
    var serviceId = ContainerViewController()
    
    var visibility = false
    
    @IBOutlet weak var homeMainTableView: UITableView!
    
    
    @IBOutlet weak var menuButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var searchBarOutlet: UIBarButtonItem!
    
    @IBOutlet var topView: UIView!
    
    var searchBarVC = UISearchController(searchResultsController: nil)
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
//UIFont(name: "Questrial-Regular")!
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
        
        
        searchBarVC.searchBar.isHidden = false
        
        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)

        providersAPI.getDataForHome { (values) in
            
            switch values {
            case .Success(let data):
                self.stopAnimating()
                self.jsonResultParse(data as AnyObject)
            case .Error(let message):
                print("Error = \(message)")
                self.stopAnimating()
            }
            
            
        }
        
        
      
      
      
        searchBarVC.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchBarVC.obscuresBackgroundDuringPresentation = false
        } else {
            searchBarVC.dimsBackgroundDuringPresentation = false
            // Fallback on earlier versions
        }
        searchBarVC.searchBar.placeholder = "Enter your search here"
       
        definesPresentationContext = true
       searchBarVC.searchBar.delegate = self
       
        searchBarVC.searchBar.setBackgroundImage(imageLayerForSearchBackground(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        

        clearDataKeys()
        

   
    }
    
    func callforUpdate() {
        
        DispatchQueue.global().async {
            do {
                let update = try self.isUpdateAvailable()
                
                print("update",update)
                DispatchQueue.main.async {
                    
                    print("DONE")
                    if update{
                        self.popupUpdateDialogue();
                    }else{
                        print("No Need to Update")
                    }
                    
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
    var VersionNew = ""
    
    func isUpdateAvailable() throws -> Bool {
        
        
        
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                return false
        }
        
        let data = (try!  Data(contentsOf: url))
        
        let json = (try! JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as! [String: Any]
        
        
        
        if let result = (json["results"] as? [Any])?.first as? [String: Any],
            let version = result["version"] as? String {
            
            VersionNew = version
            print("version in app store", version)
            
        }
        
        let VersionNewNum = (self.VersionNew as NSString).doubleValue
     //   let currentVersionNum = Double(currentVersion)
        
         let currentVersionNum = (currentVersion as NSString).doubleValue
        
        print("""
            Need to update = \(VersionNewNum >= currentVersionNum)
            
            CurrentVersion = \(currentVersion)
            CurrentVersion2 = \(currentVersionNum)
            Vernum = \(VersionNewNum)
            """)
        
        return  VersionNewNum > currentVersionNum
        
    }
    

    func popupUpdateDialogue(){
       
        
        let versionInfo =  self.VersionNew
        
        
        
        let alertMessage = "A new version of LaundryBE is available,Please update to version "+versionInfo;
        let alert = UIAlertController(title: "New Version Available", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okBtn = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let url = URL(string: "https://itunes.apple.com/in/app/laundrybe/id1335930898?mt=8"),
                UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            UserDefaults.standard.set("DecisionMade", forKey: "DecisionMade")
        })
        let noBtn = UIAlertAction(title:"Skip this Version" , style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            
            UserDefaults.standard.set("DecisionMade", forKey: "DecisionMade")
        })
        alert.addAction(okBtn)
        alert.addAction(noBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            
            print("User is connected to the internet via wifi.")
            checkUpdateAvaliable()
            
        }else if currentReachabilityStatus == .reachableViaWWAN{
            
            print("User is connected to the internet via WWAN.")
            
        } else {
            self.stopAnimating()
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func checkUpdateAvaliable() {
        print("Called for update")
        
        if UserDefaults.standard.value(forKey: "DecisionMade") == nil {
            callforUpdate()
            print("Has no Value")
        }else{
            print("Has Value")
        }
    }
    
    override func viewDidLayoutSubviews() {
        checkReachability()
    }
    
    
    
    
    
    func jsonResultParse(_ json:AnyObject) {
        
        let JSONArray = json as! NSArray
        print("jsonaArray = \(JSONArray)")
        
        if JSONArray.count != 0 {
            
            for i:Int in 0 ..< JSONArray.count {
                
                let jObject = JSONArray[i] as! NSDictionary
                
                let uProvider:ProvidersModel = ProvidersModel()
                uProvider.id = (jObject["id"] as AnyObject? as? String) ?? ""
                uProvider.location = (jObject["location"] as AnyObject? as? String) ?? ""
                uProvider.picture = (jObject["picture"] as AnyObject? as? String) ?? ""
                uProvider.provider_name = (jObject["provider_name"] as AnyObject? as? String) ?? ""
                uProvider.rating = (jObject["rating"] as AnyObject? as? String) ?? ""
                providersValues.append(uProvider)
                
            }
             providersValuesForFilter = providersValues
            self.homeMainTableView.reloadData()
        }
    }
    
    
    func clearDataKeys() {
        
        print("Clearing ... 1")
        globalLabel.sharedInstance.totvalue = 0
        globalLabel.sharedInstance.placeOrderCombined.removeAll()
        
        if let OldDataKeys = UserDefaults.standard.array(forKey: "TotalKeys"){
             print("TOTal keys = \(OldDataKeys.map{$0})")
            let _ =  OldDataKeys.map{ (values) in
                print("Clearing ... 2")
                print("KeyFromLaunch = \(values)")
                UserDefaults.standard.removeObject(forKey: values as! String)
                
            }
        }
       
        
        let _ =  globalLabel.sharedInstance.dataKey.map{ (values) in
            print("Clearing ... 2")
            print("KeyFromLaunch = \(values)")
            UserDefaults.standard.removeObject(forKey: values)

        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBarVC.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        FilteredprovidersValues = providersValuesForFilter.filter({( newValue : ProvidersModel) -> Bool in
//            return (newValue.provider_name.lowercased().contains(searchText.lowercased()) || newValue.location.lowercased().contains(searchText.lowercased()))
            
            return (newValue.provider_name.lowercased().contains(searchText.lowercased()))
        })
        
        homeMainTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchBarVC.isActive && !searchBarIsEmpty()
    }
    
    
    @IBAction func TopMenuButton(_ sender: UIBarButtonItem) {
    
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
        
    }
    
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        
    
        visibility = !visibility
        

        
        createSearchBar(isVisible: visibility)
        
    }
    

    
    func createSearchBar(isVisible: Bool) {
        
        if isVisible {
            

             self.searchBarVC.searchBar.alpha = 0.0
            

            
             searchBarVC.searchBar.isHidden = false
        
            searchBarVC.searchBar.setBackgroundImage(imageLayerForSearchBackground(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.view.layoutSubviews()
                self.homeMainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.searchBarVC.searchBar.frame.width, height: self.searchBarVC.searchBar.frame.height))
                self.topView.addSubview(self.searchBarVC.searchBar)
                
            }
                , completion: { (Value) in
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.searchBarVC.searchBar.alpha = 1.0
                    
                })
            }
            )
          
          


           self.homeMainTableView.setContentOffset(CGPoint.zero, animated: true)
            

    
        }else{
           

            self.searchBarVC.searchBar.alpha = 1.0
            

            
            UIView.animate(withDuration: 0.1, animations: {
                self.searchBarVC.searchBar.alpha = 0.0
            }, completion: { (Value) in
                print("Value = \(Value)")
                self.searchBarVC.searchBar.isHidden = Value
                self.topView.willRemoveSubview(self.searchBarVC.searchBar)
                // self.homeMainTableView.tableHeaderView = nil
                
                UIView.animate(withDuration: 0.4, animations: {
                    
                    self.view.layoutSubviews()
                    self.homeMainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    
                })
                
            })
            
            
           
           
            
            searchBarVC.searchBar.setBackgroundImage(imageLayerForSearchBackground(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
           
            
          
         
        }
    }
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("SearchSelected")
        
        searchBarVC.searchBar.setBackgroundImage(imageLayerForSearchBackground(), for: UIBarPosition.any, barMetrics: UIBarMetrics.defaultPrompt)
    }
    

    

    func updateSearchResults(for searchController: UISearchController) {
       filterContentForSearchText(searchController.searchBar.text!)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return FilteredprovidersValues.count
        }
        return providersValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        let NewValues: ProvidersModel
        if isFiltering() {
            NewValues = FilteredprovidersValues[indexPath.row]
        } else {
            NewValues = providersValues[indexPath.row]
        }
        
        cell.providerLabel.text = NewValues.provider_name
        //cell.locationLabel.text = NewValues.location
        
        let imageURL = NewValues.picture
       //cell.imageForm.sd_setImage(with: URL(string: imageURL))
        cell.imageForm.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "defalutImage"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       globalLabel.sharedInstance.pname.removeAll()
         globalLabel.sharedInstance.pname = providersValues[indexPath.row].provider_name
  
        print("IDData = \(providersValues[indexPath.row].id)")
        
        let NewValues: ProvidersModel
        if isFiltering() {
            NewValues = FilteredprovidersValues[indexPath.row]
        } else {
            NewValues = providersValues[indexPath.row]
        }
        
        globalLabel.sharedInstance.id = NewValues.id
        

        newValues()
    }
    
    
    func newValues() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServiceTypeViewController")
 
        self.so_containerViewController?.topViewController = vc
      
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        // take into account the status bar
        
        if UIScreen.main.nativeBounds.height == 2436 {
            updatedFrame?.size.height += 50
            print("IphoneX😇")
        }else{
            updatedFrame?.size.height += 20
            print("SomeOther123")
        }
        let layer = GrandientClass.gradientLayerForBounds(bounds: updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func imageLayerForSearchBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        // take into account the status bar
        
        if UIScreen.main.nativeBounds.height == 2436 {
            updatedFrame?.size.height += 50
            print("IphoneX😇")
        }else{
            updatedFrame?.size.height += 20
            print("SomeOther123")
        }
        
        let layer = GrandientClass.searchLayerForBounds(bounds: updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
  

}






