//
//  ViewController.swift
//  ios2_finalProject
//
//  Created by Xcode User on 2017-12-21.
//  Copyright © 2017 Xcode User. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {
    let md = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var lbSongTitle: UILabel!
    @IBOutlet var lbArtist: UILabel!
    @IBOutlet var btArtwork: UIButton!
    @IBOutlet var lbSongTitle2: UILabel!
    @IBOutlet var lbArtist2: UILabel!
    @IBOutlet var btArtwork2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        md.volNum=0.5;
        md.volNum2=0.5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPauseSong(sender: UIButton) {
        if(md.audioPlayer?.isPlaying)!{
            md.audioPlayer?.pause()
        }
        else{
            md.audioPlayer?.play()
        }
        
        if(md.audioPlayer2?.isPlaying)!{
            md.audioPlayer2?.pause()
        }
        else{
            md.audioPlayer2?.play()
        }
    }
    
    @IBAction func stopSong(sender: UIButton) {
        md.audioPlayer?.stop()
        md.audioPlayer?.currentTime = 0
        md.audioPlayer2?.stop()
        md.audioPlayer2?.currentTime = 0
    }

    
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {
        var songArtist: NSString?
        var songTitle: NSString?
        var songArtist2: NSString?
        var songTitle2: NSString?
        if(md.audioPlayer != nil){
            md.audioPlayer?.currentTime = 0
            songArtist = md.song?.albumArtist as NSString?
            songTitle = md.song?.title as NSString?
            if (songArtist == nil){
                lbArtist.text = "Artist Unknown"
            }
            else{
                lbArtist.text = songArtist as String?
            }
            
            if(songTitle == nil){
                lbSongTitle.text = "Title Unknown"
            }
            else{
                lbSongTitle.text = songTitle as String?
            }
            
            let artworkSize: CGSize = CGSize(width: 30, height: 30)
            var artworkImage: UIImage?
            if(md.song?.value(forProperty: MPMediaItemPropertyArtwork) == nil){
                artworkImage = UIImage(named: "AlbumArt1.png")
            }
            else{
                let artwork: MPMediaItemArtwork = md.song?.value(forProperty: MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                artworkImage = artwork.image(at: artworkSize)
            }
            
            btArtwork.setBackgroundImage(artworkImage, for: .normal)
        }
        if(md.audioPlayer2 != nil){
            md.audioPlayer2?.currentTime = 0
            songArtist2 = md.song2?.albumArtist as NSString?
            songTitle2 = md.song2?.title as NSString?
            if (songArtist2 == nil){
                lbArtist2.text = "Artist Unknown"
            }
            else{
                lbArtist2.text = songArtist2 as String?
            }
            
            if(songTitle2 == nil){
                lbSongTitle2.text = "Title Unknown"
            }
            else{
                lbSongTitle2.text = songTitle2 as String?
            }
            
            let artworkSize: CGSize = CGSize(width: 30, height: 30)
            var artworkImage: UIImage?
            if(md.song2?.value(forProperty: MPMediaItemPropertyArtwork) == nil){
                artworkImage = UIImage(named: "AlbumArt1.png")
            }
            else{
                let artwork: MPMediaItemArtwork = md.song2?.value(forProperty: MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                artworkImage = artwork.image(at: artworkSize)
            }
            
            btArtwork2.setBackgroundImage(artworkImage, for: .normal)
        }
    }


}

