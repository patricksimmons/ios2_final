//
//  Track2ViewController.swift
//  ios2_finalProject
//
//  Created by Xcode User on 2017-12-21.
//  Copyright © 2017 Xcode User. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class Track2ViewController: UIViewController, MPMediaPickerControllerDelegate {
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    let md = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var btPlayPause: UIButton!
    @IBOutlet var btArtwork: UIButton!
    @IBOutlet var lblSongTitle: UILabel!
    @IBOutlet var lblArtist: UILabel!
    @IBOutlet var lblSongLength: UILabel!
    @IBOutlet var lblVolume: UILabel!
    @IBOutlet var lblKey: UILabel!
    @IBOutlet var lblTempo: UILabel!
    @IBOutlet var slProgress: UISlider!
    @IBOutlet var slVolume: UISlider!
    @IBOutlet var stDecimal:  UIStepper!
    @IBOutlet var stWholeNum:  UIStepper!
    @IBOutlet var stKey:  UIStepper!
    var myTimer: Timer?
    var myTimer2: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseSong(sender: UIButton) {
        if(md.audioPlayer2 != nil){
            md.audioPlayer2?.stop()
            myTimer?.invalidate()
            myTimer2?.invalidate()
        }
        mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        if let picker = mediaPicker{
            
            print("Successfully instantiated a media picker")
            picker.allowsPickingMultipleItems = false
            picker.popoverPresentationController?.sourceView = sender
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }
    
    @IBAction func playPauseSong(sender: UIButton) {
        var title: NSString?
        title = sender.currentTitle! as NSString
        if(title?.isEqual(to: "⏸"))!
        {
            md.audioPlayer2?.pause()
            myTimer?.invalidate()
            myTimer2?.invalidate()
            title = "▶"
            btPlayPause.setTitle(title! as String, for: .normal)
        }
        else
        {
            if(md.audioPlayer2 != nil)
            {
                md.audioPlayer2?.play()
                myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Track2ViewController.updateTimeLeft), userInfo: nil, repeats: true)
                
                myTimer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Track2ViewController.sliderProgressChange(sender:)), userInfo: nil, repeats: true)
                
                title = "⏸"
                btPlayPause.setTitle(title! as String, for: .normal)
            }
            else{
                print("Not playing song")
            }
        }
    }
    
    @IBAction func sliderProgressChange(sender: UISlider) {
        let timeLeft: TimeInterval = (md.audioPlayer2?.currentTime)!
        //var songLength: TimeInterval = (md.song?.playbackDuration)!
        slProgress.setValue(Float(timeLeft), animated: true)
    }
    
    @IBAction func sliderVolumeChanged(sender: UISlider) {
        updateLabel()
        md.volNum2 = slVolume.value
        md.volNum2 = md.volNum2!/100
        md.audioPlayer2?.volume = md.volNum2!
    }
    
    @IBAction func keyChanged(sender: UIStepper) {
        let key: Int = Int(stKey.value)
        lblKey.text = md.keyArray?[key] as? String
    }
    
    @IBAction func tempoDecimalChanged(sender: UIStepper) {
        let decimal: Float = Float(stDecimal.value)
        lblTempo.text = String(format: "%.1f bpm", decimal)
        stWholeNum.value = Double(decimal)
        md.songBPM2 = decimal
    }
    
    @IBAction func tempoWholeChanged(sender: UIStepper) {
        let wholeNum: Float = Float(stWholeNum.value)
        lblTempo.text = String(format: "%.1f bpm", wholeNum)
        stDecimal.value = Double(wholeNum)
        md.songBPM2 = wholeNum
    }
    
    func updateLabel(){
        let vol: Float = slVolume.value
        let strVol: NSString = String(format: "%.0f%%", vol) as NSString
        lblVolume.text = strVol as String
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        md.audioPlayer2 = nil
        
        md.song2 = mediaItemCollection.items.first
        
        let url :NSURL = md.song2?.value(forProperty: MPMediaItemPropertyAssetURL) as! NSURL
        
        if(!(md.audioPlayer2 != nil)){
            do {
                try md.audioPlayer2 = AVAudioPlayer.init(contentsOf: url as URL, fileTypeHint: nil)
                
            }
            catch let error as NSError { print(error.debugDescription)
                
            }
        }
        
        md.audioPlayer2?.play()
        
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Track2ViewController.updateTimeLeft), userInfo: nil, repeats: true)
        
        myTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Track2ViewController.sliderProgressChange(sender:)), userInfo: nil, repeats: true)
        btPlayPause.setTitle("⏸" as String, for: .normal)
        
        var songArtist: NSString?
        var songTitle: NSString?
        var seconds: Double?
        var songSeconds: Int?
        var songMinute: Int?
        
        if(md.song2 != nil){
            songArtist = md.song2?.albumArtist as NSString?
            songTitle = md.song2?.title as NSString?
            seconds = md.song2?.playbackDuration;
            
            songMinute = Int(seconds!) / 60
            songSeconds = Int(seconds! - Double(songMinute! * 60))
            
            if (songArtist == nil){
                lblArtist.text = "Artist Unknown"
            }
            else{
                lblArtist.text = songArtist as String?
            }
            
            if(songTitle == nil){
                lblSongTitle.text = "Title Unknown"
            }
            else{
                lblSongTitle.text = songTitle as String?
            }
            
            lblSongLength.text = "00:00/"+String(format: "%02d", songMinute!)+":"+String(format: "%02d", songSeconds!)
            
            let artworkSize: CGSize = CGSize(width: 30, height: 30)
            var artworkImage: UIImage?
            if(md.song2?.value(forProperty: MPMediaItemPropertyArtwork) == nil){
                artworkImage = UIImage(named: "AlbumArt2.png")
            }
            else{
                let artwork: MPMediaItemArtwork = md.song2?.value(forProperty: MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                artworkImage = artwork.image(at: artworkSize)
            }
            
            btArtwork.setBackgroundImage(artworkImage, for: .normal)
        }
        
        mediaPicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("Canceled song picking")
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTimeLeft() {
        let timeLeft: TimeInterval = (md.audioPlayer2?.currentTime)!
        let seconds: Double = (md.song2?.playbackDuration)!
        
        let songMinute: Int = Int(seconds) / 60
        let songSeconds: Int = Int(seconds - Double(songMinute * 60))
        
        let curSeconds: Double = timeLeft
        var curSongMinute: Int = Int(curSeconds) / 60
        var curSongSeconds: Int = Int(curSeconds - Double(curSongMinute * 60))
        
        lblSongLength.text = String(format: "%02d", curSongMinute)+":"+String(format: "%02d", curSongSeconds)+"/"+String(format: "%02d", songMinute)+":"+String(format: "%02d", songSeconds)
        
        if(timeLeft == md.song2?.playbackDuration)
        {
            btPlayPause.setTitle("▶", for: .normal)
            md.audioPlayer2?.stop()
            md.audioPlayer2?.currentTime=0
            
            curSongSeconds = 0;
            curSongMinute = 0;
            
            lblSongLength.text = String(format: "%02d", curSongMinute)+":"+String(format: "%02d", curSongSeconds)+"/"+String(format: "%02d", songMinute)+":"+String(format: "%02d", songSeconds)
            btPlayPause.setTitle("▶" as String, for: .normal)
            //String(format: "%02d", songSeconds)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        md.audioPlayer2?.stop()
        md.audioPlayer2?.currentTime = 0
        myTimer?.invalidate()
        myTimer2?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var songArtist: NSString?
        var songTitle: NSString?
        var seconds: Double?
        var songSeconds: Int?
        var songMinute: Int?
        if(md.audioPlayer2 != nil){
            md.audioPlayer2?.currentTime = 0
            songArtist = md.song2?.albumArtist as NSString?
            songTitle = md.song2?.title as NSString?
            
            if((md.songBPM2) != nil) {
                lblTempo.text = String(format: "%.1f bpm", md.songBPM2!)
            }
            
            if (songArtist == nil){
                lblArtist.text = "Artist Unknown"
            }
            else{
                lblArtist.text = songArtist as String?
            }
            
            if(songTitle == nil){
                lblSongTitle.text = "Title Unknown"
            }
            else{
                lblSongTitle.text = songTitle as String?
            }
            
            let artworkSize: CGSize = CGSize(width: 30, height: 30)
            var artworkImage: UIImage?
            if(md.song2?.value(forProperty: MPMediaItemPropertyArtwork) == nil){
                artworkImage = UIImage(named: "AlbumArt2.png")
            }
            else{
                let artwork: MPMediaItemArtwork = md.song2?.value(forProperty: MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                artworkImage = artwork.image(at: artworkSize)
            }
            
            btArtwork.setBackgroundImage(artworkImage, for: .normal)
            
            seconds = md.song2?.playbackDuration;
            songMinute = Int(seconds!) / 60
            songSeconds = Int(seconds! - Double(songMinute! * 60))
            
            
            lblSongLength.text = "00:00/"+String(format: "%02d", songMinute!)+":"+String(format: "%02d", songSeconds!)
            if(md.volNum2 != nil){
                if(md.volNum2! <= Float(1)){
                    md.volNum2 = md.volNum2!*100;
                }
                slVolume.value=md.volNum2!;
                updateLabel()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
