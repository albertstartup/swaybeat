import UIKit
import Parse

class ActivityPage: UITableViewController {
  
  var isPlaying = false
  var tblData: [[String:AnyObject]] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Everyone's Shared Songs"
        
    tableView.registerNib(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: "ActivityCell")        
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    PFUser.query()?.findObjectsInBackgroundWithBlock { users, error in
      guard error == nil else  {
        print(error)
        return
      }
      var filteredUsers = [[String:AnyObject]]()
      for user in users! {
        var filteredUser = [String:AnyObject]()
        filteredUser["name"] = user["name"]
        print(user.objectId!)
        filteredUser["userId"] = user.objectId!
        filteredUsers.append(filteredUser)
      }
      self.tblData = filteredUsers
      self.tableView.reloadData()
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tblData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("ActivityCell")!    
  }

  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    let activityCell = cell as! ActivityCell
    
    if (tblData.count != 0) {
      let name = tblData[indexPath.row]["name"]
      
      activityCell.setModel(["name": name!])
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //self.isPlaying = !isPlaying
    //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    let pvc = parentViewController as! UINavigationController
    let vc = UIViewController()
    pvc.pushViewController(vc, animated: true)
    
    let user = tblData[indexPath.row]
    let share = PFQuery(className: "Share")
    share.whereKey("userId", equalTo: user["userId"]!)
    share.orderByDescending("updatedAt")
    share.findObjectsInBackgroundWithBlock { results, error in
      if error != nil || results == nil {
        print(error)
        print("this person does not share")
        return
      }
      
      print(results)
      let result = results![0]
      result["globalTrack"].fetchIfNeededInBackgroundWithBlock { PFglobalTrack, error in
        if error != nil || PFglobalTrack == nil {
          print(error)
          print("could not fetch")
          return
        }
        //print(PFglobalTrack!.objectId)
        let scTrack = StreamableSoundcloudTrack(fromParseObject: PFglobalTrack!)
        let gTrack = GlobalTrack(fromSoundCloudTrack: scTrack)
        GlobalPlayer.sharedInstance.play(gTrack)
      }
    }
  }
  
}
