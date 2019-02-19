import Foundation
import Alamofire
import SwiftyJSON

let numberOfSongToShowPerPage = 25
let soundcloudTracksAPIURL = "https://api.soundcloud.com/tracks"

func searchSoundcloud(query: String, block: (NSError!, [StreamableSoundcloudTrack]!) -> ()) {
  let url = queryToSoundcloudUrl(query)
  
  Alamofire.request(.GET, url).responseJSON { response in
    switch response.result {
    case .Success:
      if let value = response.result.value {
        let songs = JSON(value)
        var response: [StreamableSoundcloudTrack] = []
        
        for (_, song):(String, JSON) in songs {
          
          if !song["streamable"].boolValue {
            continue
          }
          
          response.append(StreamableSoundcloudTrack(fromSwiftyJSON: song)
          )
        }
        
        block(nil, response)
      }
    case .Failure(let error):
      block(error, nil)
    }
  }
  
}

func getSoundcloudTrackWithId(id: String, block: (NSError!, StreamableSoundcloudTrack!) -> ()){
  let url = idToSoundcloudUrl(id)
  
  Alamofire.request(.GET, url).responseJSON { response in
    switch response.result {
    case .Success:
      if let value = response.result.value {
        let song = JSON(value)
        var response: StreamableSoundcloudTrack
        
        
        if !song["streamable"].boolValue {
          block(NSError(domain: "souncloud track is not streamable", code: 1, userInfo: nil), nil)
        }
        
        response = StreamableSoundcloudTrack(fromSwiftyJSON: song)
        block(nil, response)
      }
    case .Failure(let error):
      block(error, nil)
    }
  }
}

func queryToSoundcloudUrl(query: String) -> String {
  let lowercaseQuery = query.lowercaseString
  let escapedQuery = lowercaseQuery.URLEscapedString
  let url = soundcloudTracksAPIURL.stringByAppendingFormat(
    "?q=%@&client_id=%@&limit=%@",
    escapedQuery,
    soundcloudClientId,
    String(numberOfSongToShowPerPage)
  )
  return url
}

func idToSoundcloudUrl(id: String) -> String {
  let url = soundcloudTracksAPIURL.stringByAppendingFormat(
    "/%@?client_id=%@",
    id,
    soundcloudClientId
  )
  return url
}

