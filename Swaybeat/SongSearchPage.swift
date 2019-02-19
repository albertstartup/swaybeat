import UIKit
import RxCocoa
import RxSwift
import Parse
import Bolts

class SongSearchPage: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
  
  var soundcloudSearchResults: [GlobalTrack] = []
  var spotifySearchResults: [GlobalTrack] = []
  
  var selectedScopeButtonIndex = 0
  
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchController.searchBar.placeholder = "Search For A Song"
    searchController.searchBar.scopeButtonTitles = ["Soundcloud", "Spotify"];
    searchController.searchBar.barTintColor = SwaybeatPink
    searchController.searchBar.tintColor = .whiteColor()
    
    searchController.searchResultsUpdater = self
    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    extendedLayoutIncludesOpaqueBars = true
    
    searchController.searchBar.delegate = self
    
    navigationItem.title = "Share A Song"
    tableView.tableHeaderView = searchController.searchBar
    
    tableView.keyboardDismissMode = .OnDrag
    setupReactive()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // I did not deque because leaving it like this will force me to learn about performance, memory leaks, and such
    let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "SearchTableViewCell")
    
    if totalSearchResults() != 0 {
      let track = trackAtIndex(indexPath.row)
      cell.textLabel?.text = track?.title
      cell.detailTextLabel?.text = track?.artist
    }
    
    return cell
  }
  
  func trackAtIndex(index: Int) -> GlobalTrack? {
    if isSoundcloudScopeSelected() {
      return soundcloudSearchResults[index]
    } else {
      return spotifySearchResults[index]
    }
  }
  
  func scopeSearchResultCount() -> Int {
    if isSoundcloudScopeSelected() {
      return soundcloudSearchResults.count
    } else {
      return spotifySearchResults.count
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return scopeSearchResultCount()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    GlobalPlayer.sharedInstance.play(trackAtIndex(indexPath.item)!)
    
    let userId = PFUser.currentUser()!.objectId
    let share = PFObject(className: "Share")
    
    let globalTrack = trackAtIndex(indexPath.row)
    
    let query = PFQuery(className: "GlobalTrack")
    query.whereKey("service", equalTo: globalTrack!.serviceString)
    query.whereKey("streamURL", equalTo: globalTrack!.streamURLString)
    query.getFirstObjectInBackgroundWithBlock { result, error in
      if error != nil || result == nil {
        print(error)
        
        let PFglobalTrack = PFObject(className: "GlobalTrack")
        PFglobalTrack["service"] = globalTrack!.serviceString
        PFglobalTrack["trackId"] = globalTrack!.id
        PFglobalTrack["streamURL"] = globalTrack!.streamURLString
        PFglobalTrack.saveInBackgroundWithBlock() { result, error in
          if error != nil {
            print(error)
            return
          }
          
          print(PFglobalTrack["trackId"])
          
          share["globalTrack"] = PFglobalTrack
          share["userId"] = userId
          share.saveInBackgroundWithBlock { result, error in
            if error != nil {
              print(error)
              return
            }
            
            print(result)
          }
        }
        
      } else {
        print(result)
        
        share["globalTrack"] = result!
        share["userId"] = userId
        share.saveInBackgroundWithBlock { result, error in
          if error != nil {
            print(error)
            return
          }
          
          print(result)
        }
      }
    }
    
    
    
  }
  
  func setupReactive() {
    
    searchController.searchBar.rx_text
      .filter({text in
        if !text.isEmpty {
          return true
        } else {
          return false
        }
      })
      .debounce(0.75, scheduler: MainScheduler.instance)
      .subscribeNext {text in
        
        print("searching: \(text)")
        
        SPTSearch.performSearchWithQuery(text, queryType: .QueryTypeTrack, accessToken: nil, callback: { (error: NSError!, response: AnyObject!) in
          
          if error != nil {
            print("search error: \(error)")
            return
          }
          
          let result = response as! SPTListPage
          
          if !Bool(result.range.length) {return}
          
          let items = result.items as! [SPTPartialTrack]
          var globalTracks: [GlobalTrack] = []
          
          for item in items {
            let globalTrack = GlobalTrack(fromSpotifyTrack: item)
            globalTracks.append(globalTrack)
          }
          self.spotifySearchResults = globalTracks
          self.tableView.reloadData()
          
        })
        
        searchSoundcloud(text) { error, items in
          if error != nil {
            print("search error: \(error)")
            return
          }
          
          var globalTracks: [GlobalTrack] = []
          
          for item in items {
            let globalTrack = GlobalTrack(fromSoundCloudTrack: item)
            globalTracks.append(globalTrack)
          }
          self.soundcloudSearchResults = globalTracks
          self.tableView.reloadData()
        }
        
    }
    
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
  }
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    selectedScopeButtonIndex = selectedScope
    tableView.reloadData()
  }
  
}

extension SongSearchPage {
  func isSoundcloudScopeSelected() -> Bool {
    if selectedScopeButtonIndex == 0 {
      return true
    } else {
      return false
    }
  }
  
  func totalSearchResults() -> Int {
    return soundcloudSearchResults.count + spotifySearchResults.count
  }
}