//
//  TipViewController.swift
//  MAMapKit_2D_Demo
//
//  Created by xiaoming han on 16/10/8.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    var tableView: UITableView!
    
    var tableData: Array<AMapTip>!
    var search: AMapSearchAPI!
    var mapView: MAMapView!
    var gpsButton: UIButton!
    var currentRequest: AMapInputTipsSearchRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor = UIColor.gray
        
        tableData = Array()
        
        initMapView()
        
        let zoomPannelView = self.makeZoomPannelView()
        zoomPannelView.center = CGPoint.init(x: self.view.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.view.bounds.size.height -  zoomPannelView.bounds.width/2 - 30)
        
        zoomPannelView.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin , UIView.AutoresizingMask.flexibleLeftMargin]
        self.view.addSubview(zoomPannelView)
        
        gpsButton = self.makeGPSButtonView()
        gpsButton.center = CGPoint.init(x: gpsButton.bounds.width / 2 + 10, y:self.view.bounds.size.height -  gpsButton.bounds.width / 2 - 20)
        self.view.addSubview(gpsButton)
        gpsButton.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin , UIView.AutoresizingMask.flexibleRightMargin]
        initSearch()
        
        initTableView()
        initSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
        searchController.searchBar.removeFromSuperview()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initTableView() {
        
        let tableY = self.navigationController!.navigationBar.frame.maxY
        tableView = UITableView(frame: CGRect(x: 0, y: tableY, width: self.view.bounds.width, height: self.view.bounds.height - tableY), style: UITableView.Style.plain)
        tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        self.view.addSubview(tableView)
    }
    
    func makeGPSButtonView() -> UIButton! {
        let ret = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        ret.backgroundColor = UIColor.white
        ret.layer.cornerRadius = 4
        
        ret.setImage(UIImage.init(named: "gpsStat1"), for: UIControl.State.normal)
        ret.addTarget(self, action: #selector(self.gpsAction), for: UIControl.Event.touchUpInside)
        
        return ret
    }
    
    func makeZoomPannelView() -> UIView {
        let ret = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 98))
        
        let incBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 49))
        incBtn.setImage(UIImage.init(named: "increase"), for: UIControl.State.normal)
        incBtn.sizeToFit()
        incBtn.addTarget(self, action: #selector(self.zoomPlusAction), for: UIControl.Event.touchUpInside)
        
        let decBtn = UIButton.init(frame: CGRect.init(x: 0, y: 49, width: 53, height: 49))
        decBtn.setImage(UIImage.init(named: "decrease"), for: UIControl.State.normal)
        decBtn.sizeToFit()
        decBtn.addTarget(self, action: #selector(self.zoomMinusAction), for: UIControl.Event.touchUpInside)
        
        ret.addSubview(incBtn)
        ret.addSubview(decBtn)
        
        return ret
    }

    func initMapView() {
        mapView = MAMapView(frame: self.view.bounds)
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = true
        mapView.scaleOrigin = CGPoint(x: 10, y: 10)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    func initSearchController() {
        searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "请输入关键字"
        searchController.searchBar.sizeToFit()

        // fix the warning for [Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior]
        if #available(iOS 9.0, *) {
            self.searchController.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            let _ = self.searchController.view
        }
        
        
        self.navigationItem.titleView = searchController.searchBar
    }
    
    //MARK:- event handling
    @objc func zoomPlusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom+1, animated: true)
    }
    
    @objc func zoomMinusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom-1, animated: true)
    }
    
    @objc func gpsAction() {
        if(self.mapView.userLocation.isUpdating && self.mapView.userLocation.location != nil) {
            self.mapView.setCenter(self.mapView.userLocation.location.coordinate, animated: true)
            self.gpsButton.isSelected = true
        }
    }

    //MARK: - Action
    
    func searchTip(withKeyword keyword: String?) {
        
        print("keyword \(keyword)")
        if keyword == nil || keyword! == "" {
            return
        }
        
        let request = AMapInputTipsSearchRequest()
        request.keywords = keyword
        
        currentRequest = request
        search.aMapInputTipsSearch(request)
    }
    
    //MARK:- UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        print("begin")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print("search")
    }
    
    //MARK:- UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update active \(searchController.isActive)")
        tableView.isHidden = !searchController.isActive
        searchTip(withKeyword: searchController.searchBar.text)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            searchController.searchBar.placeholder = searchController.searchBar.text
        }
    }

    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        print("name: \(view.annotation.title)")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = false
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
            return annotationView!
        }
        
        return nil
    }
    
    //MARK: - AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        let nsErr:NSError? = error as NSError
//        NSLog("Error:\(error) - \(ErrorInfoUtility.errorDescription(withCode: (nsErr?.code)!))")
    }
    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
     
        if currentRequest == nil || currentRequest! != request {
            return
        }
        
        if response.count == 0 {
            return
        }
        
        tableData.removeAll()
        for aTip in response.tips {
            if aTip.location != nil{
                tableData.append(aTip)
            }
        }
        tableView.reloadData()
    }
    
    //MARK:- TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let tip = tableData[indexPath.row]
        
        if tip.location != nil {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(tip.location.latitude), longitude: CLLocationDegrees(tip.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = tip.name
            anno.subtitle = tip.address
            
            mapView.addAnnotation(anno)
            mapView.selectAnnotation(anno, animated: true)
        }
        
        searchController.isActive = false
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("地图选点"), object: tip)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //MARK:- TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "demoCellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if !tableData.isEmpty {
            
            let tip = tableData[indexPath.row]
            
            cell!.textLabel?.text = tip.name
            cell!.detailTextLabel?.text = tip.address
        }
        
        return cell!
    }
    
}
