//
//  Credentials.swift
//  ClarifaiApiDemo
//

import Foundation


// IMPORTANT NOTE: you should replace the clarifaiClientID and clarifaiClientSecret values below
// with your own. You can obtain these at https://developer.clarifai.com/applications -- the
// defaults are shared credentials that will stop working once their quota is reached.
// 
// Also, if you're committing your code to a public repo, be careful not to check in your
// credentials -- we're including these here so you can get started out of the box, but this is
// generally a bad practice.
let clarifaiClientID = "rR2LZf-x5eWJ1QKXF1GM7N4HpulW9rWhzrR78D1I"
let clarifaiClientSecret = "ah9a2p2dD54IHWvIc5dYBPWeJ8fdu6TCaWq47R0k"


@objc class Credentials : NSObject {
  class func clientID() -> String { return clarifaiClientID }
  class func clientSecret() -> String { return clarifaiClientSecret }
}
