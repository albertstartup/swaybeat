import Foundation
import AVFoundation
import SwiftyJSON
import Parse

class SoundcloudTrack {
  
  private(set) var title: String!
  private(set) var artist: String!
  private(set) var id: String!
  
  init(fromSwiftyJSON song: JSON) {
    
    title = song["title"].stringValue
    artist = song["user"]["username"].stringValue
    id = song["id"].stringValue
  }
  
  init(fromParseObject object: PFObject) {
    // object is GlobalTrack on parse
    title = " "
    artist = " "
    id = object["trackId"] as! String
  }

}

class StreamableSoundcloudTrack: SoundcloudTrack {
  private(set) var streamURL: NSURL!
  
  override init(fromSwiftyJSON song: JSON) {
    super.init(fromSwiftyJSON: song)
    
    let streamURLString = song["stream_url"].stringValue.stringByAppendingFormat(
      "?client_id=%@",
      SoundcloudAuth.sharedInstance.clientId
    )
    
    streamURL = NSURL(string: streamURLString)
  }
  
  override init(fromParseObject object: PFObject) {
    super.init(fromParseObject: object)
    let urlString = object["streamURL"] as! String
    streamURL = NSURL(string: urlString)
  }
  
}

