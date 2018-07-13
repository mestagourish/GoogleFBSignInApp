//
//  DownloadViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 08/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import AWSS3
import AVFoundation

class DownloadViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var statusLabel: UILabel!
    let S3BucketName: String = "encoar-userfiles-mobilehub-1767594688"
    let S3DownloadKeyName: String = "assetbundles/ar.jpg"
    
    var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
    
    let transferUtility = AWSS3TransferUtility.default()
    var audioPlayer: AVAudioPlayer!
    var audioRecorder : AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.progressView.progress = 0.0;
        //self.statusLabel.text = "Ready"
        
    }
    func startRecording() {
        
        // then lets create your document folder url
        let documentsDirectoryURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("EncoAR/sound.wav")
        print(destinationUrl!)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:1,
            AVLinearPCMBitDepthKey:8,
            AVLinearPCMIsFloatKey:false,
            AVLinearPCMIsBigEndianKey:false,
            AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue
            ] as [String : Any]
        
        let session = AVAudioSession.sharedInstance()
        do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder = try AVAudioRecorder(url: destinationUrl!, settings: settings)
            //AVAudioRecorder(URL: destinationUrl, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true;
            audioRecorder.record()
        }catch
        {
            print("error")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnStopRecording(_ sender: UIButton) {
        audioRecorder.stop()
        print("Recording stopped");
       /* var audioSession = AVAudioSession.sharedInstance()
        do
        {
        try audioSession.setActive(false)
        print("Recording stopped");
        }catch
        {
            print("Error")
        }*/
        
    }
    @IBAction func start(_ sender: UIButton) {
        startRecording()
        
        //self.imageView.image = nil;
        //download()
        /*let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = Float(progress.fractionCompleted)
                self.statusLabel.text = "Downloading..."
            })
        }
        
        self.completionHandler = { (task, location, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    NSLog("Failed with error: \(error)")
                    self.statusLabel.text = "Failed"
                }
                else if(self.progressView.progress != 1.0) {
                    self.statusLabel.text = "Failed"
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                }
                else{
                    self.statusLabel.text = "Success"
                    self.imageView.image = UIImage(data: data!)
                    self.saveToFile(data: data!)
                }
            })
        }
        
        transferUtility.downloadData(
            fromBucket: S3BucketName,
            key: S3DownloadKeyName,
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    NSLog("Error: %@",error.localizedDescription);
                    self.statusLabel.text = "Failed"
                }
                
                if let _ = task.result {
                    self.statusLabel.text = "Starting Download"
                    NSLog("Download Starting!")
                    // Do something with uploadTask.
                }
                return nil;
        }*/
    }
    func saveToFile(data :Data) {
        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath1.appendingPathComponent("EncoAR\(data)")
        print(logsPath!)
        do {
            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }

    func download()
    {
        let transferManager = AWSS3TransferManager.default()
        
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ar.jpg")
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        
        downloadRequest?.bucket = "encoar-userfiles-mobilehub-1767594688"
        downloadRequest?.key = "assetbundles/ar.jpg"
        downloadRequest?.downloadingFileURL = downloadingFileURL
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
        })
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
            })
        }
        
        
        transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error downloading: \(String(describing: downloadRequest?.key)) Error: \(error)")
                    }
                } else {
                    print("Error downloading: \(String(describing: downloadRequest?.key)) Error: \(error)")
                }
                return nil
            }
            print("Download complete for: \(String(describing: downloadRequest?.key))")
            let downloadOutput = task.result
            return nil
        })
        self.imageView.image = UIImage(contentsOfFile: downloadingFileURL.path)
    }

    
}

