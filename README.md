# Swaybeat iOS

A social media based around finding people that like the same songs you enjoy. 

## Project Structure
* The UI was mostly built programmaticly.

* Usage of reactive programming to emulate React
``` swift
// Swaybeat/SongSearchPage.swiftt

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
        
        SPTSearch.performSearchWithQuery(...)
```

* Custom URL audio player library.
``` swift
// Swaybeat/GlobalPlayer/URLPLayer.swift

class URLPlayer: NSObject {
  private let player = AVPlayer()
  
  var isPlaying = false
  private(set) var didEnd = false
  private(set) var currentURL: NSURL?
  
  override init() {
    super.init()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "URLPlayerDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self)

    player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions([.New, .Initial]),context: nil)
  }
  
  func play(url: NSURL) {
```

