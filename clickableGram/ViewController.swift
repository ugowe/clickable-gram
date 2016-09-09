//
//  ViewController.swift
//  Gram
//
//  Created by Ugowe on 7/20/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    

    var imagePicker: UIImagePickerController!
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, nil, nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // The user picked an image. Send it to Clarifai for recognition.
            imageView.image = image
            textView.text = "Recognizing..."
            //            button.enabled = false
            recognizeImage(image)
            
        }
    }
    
    func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!
        
        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                self.textView.text = results![0].tags.joinWithSeparator(", ")
                self.performLinkMaker(self.textView.text)
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    // Takes in a String and returns a link that's an NSMutableAttributedString
    func turnStringIntoLink(thisWord: String) -> NSMutableAttributedString {
        
        let newThisWord = thisWord.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let linkString = NSMutableAttributedString(string: thisWord)
        
        linkString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://en.wikipedia.org/wiki/\(newThisWord)")!, range: NSMakeRange(0, newThisWord.characters.count))
         linkString.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 16.0)!, range: NSMakeRange(0, newThisWord.characters.count))
        return linkString
    }
    
    // concatenate attributed strings
    func addTwo(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        let space = NSAttributedString(string: ", ")
        
        result.appendAttributedString(left)
        result.appendAttributedString(space)
        result.appendAttributedString(right)
        return result
    }
    
    func turnStringsIntoLinks(text: String) -> NSMutableAttributedString {
        
        //Seperate text strings into words by calling componentsSeparatedByString(", ")
        let newText = text.componentsSeparatedByString(", ")
        // Make each 'word' an NSAttributedString by calling NSAttributedString(string: "word")
        
        // Combine each NSAttributed string back together
        let result = NSMutableAttributedString()
        let space = NSAttributedString(string: ", ")
        
        
        // Append each NSAttributedString "word" to the result, with a ", ", so that the result will be one long NSAttributedString string
        for word in newText {
            let newWord = turnStringIntoLink(word)
            result.appendAttributedString(newWord)
            result.appendAttributedString(space)
            
        }
        
        return result
    }
    
    func performLinkMaker(textString: String) {
        let textString = self.textView.text
        
        // My attempt to turn the textView.text into links
        let magicLinkString = self.turnStringsIntoLinks(textString)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.textView.attributedText = magicLinkString
        self.textView.delegate = self
        self.textView.selectable = true
        self.textView.dataDetectorTypes = .Link
        self.textView.userInteractionEnabled = true
    }

    
}

