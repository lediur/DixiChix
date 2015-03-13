//
//  VideoPlayerViewController.swift
//  Osprey Drones
//
//  Created by Raymond Chan on 3/12/15.
//  Copyright (c) 2015 DixiChix. All rights reserved.
//

import Foundation
import UIKit

class VideoPlayerViewController: UIViewController {
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
	
        videoPlayerView.loadWithVideoId("uDP7Pty8Qnw")
    }
    
    
}
