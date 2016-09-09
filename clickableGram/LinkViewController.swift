//
//  LinkViewController.swift
//  clickableGram
//
//  Created by Ugowe on 8/10/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var linkTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkTextView.delegate = self

         let textString = linkTextView.text
        
        
        // My attempt to turn the textView.text into links
        let magicLinkString = turnStringsIntoLinks(textString)
        
        
        // Do any additional setup after loading the view.
        
        linkTextView.attributedText = magicLinkString
        linkTextView.delegate = self
        linkTextView.selectable = true
        linkTextView.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        linkString.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 18.0)!, range: NSMakeRange(0, newThisWord.characters.count))
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
