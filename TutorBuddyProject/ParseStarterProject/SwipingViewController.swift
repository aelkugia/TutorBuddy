//
//  SwipingViewController.swift
//  TutorBuddy
//
//  Created by Abdu Elkugia on 7/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import Koloda

class SwipingViewController: UIViewController {

    //@IBOutlet var imageView: UIImageView!
    
//    var displayedUserID = ""
//    
//    func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
//        
//        let translation = gestureRecognizer.translation(in: view)
//        
//        let label = gestureRecognizer.view!
//        
//        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
//        
//        let xFromCenter = label.center.x - self.view.bounds.width / 2
//        
//        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
//        
//        let scale = min(abs(100 / xFromCenter), 1)
//        
//        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
//        
//        label.transform = stretchAndRotation
//        
//        if gestureRecognizer.state == UIGestureRecognizerState.ended {
//            
//            var acceptedOrRejected = ""
//            
//            if label.center.x < 100 {
//                
//                acceptedOrRejected = "rejected"
//                
//            } else if label.center.x > self.view.bounds.width - 100 {
//                
//                acceptedOrRejected = "accepted"
//                
//            }
//            
//            if acceptedOrRejected != "" && displayedUserID != "" {
//                
//                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected)
//                
//                PFUser.current()?.saveInBackground(block: { (success, error) in
//                    
//                    print(PFUser.current())
//                    
//                    self.updateImage()
//
//                })
//                
//            }
//            
//            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
//            
//            rotation = CGAffineTransform(rotationAngle: 0)
//            
//            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
//            
//            label.transform = stretchAndRotation
//            
//            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
//            
//        }
//        
//    }
//    
//   func updateImage() {
//    
//        //let query = PFUser.query()
////        
////        //query?.whereKey("isInPerson", equalTo: Any)
//    
//        let query = PFUser.query()
//    
//        print(PFUser.current())
//    
//        //query?.whereKey("isInPerson", equalTo: (PFUser.current()?["isInPerson"])!)
//    
//        var ignoredUsers = [""]
//    
//        if let acceptedUsers = PFUser.current()?["accepted"] {
//        
//            ignoredUsers += acceptedUsers as! Array
//        
//        }
//    
//        if let rejectedUsers = PFUser.current()?["rejected"] {
//        
//            ignoredUsers += rejectedUsers as! Array
//        
//        }
//    
//        query?.whereKey("objectId", notContainedIn: ignoredUsers)
//    
//        query?.limit = 1
//    
//        query?.findObjectsInBackground(block: { (objects, error) in
//            
//            if let users = objects {
//                
//                for object in users {
//                    
//                    if let user = object as? PFUser {
//                        
//                        self.displayedUserID = user.objectId!
//                        
//                        let imageFile = user["photo"] as! PFFile
//                        
//                        imageFile.getDataInBackground(block: { (data, error) in
//                            
//                            if error != nil {
//                                
//                                print(error)
//                                
//                            }
//                            
//                            if let imageData = data {
//                                
//                                self.imageView.image = UIImage(data: imageData)
//                                
//                            }
//                        
//                        })
//                    
//                    }
//                }
//            
//            }
//        })
//    
//    
//    
////        self.displayedUserID = (PFUser.current()?.objectId!)!
////    
////        let imageFile = PFUser.current()?["photo"] as! PFFile
////    
////        imageFile.getDataInBackground(block: { (data, error) in
////            
////        if let imageData = data {
////            
////        self.imageView.image = UIImage(data: imageData)
////            }
////                        
////        })
//    
//        
//    }

    
    @IBOutlet weak var swipeCard: KolodaView!
    
    var users = [String]()
    
    var images = [PFFile]()
    
    var courses = [[String]]()
    
    var skills = [[String]]()
    
    var availability = [Bool]()
    
    var pfUser = [PFUser]()
    
    var userObjectId = [String]()
    
    // Research model objects
    //1) add textviews to nib view and file
    //2) set up area for skills, courses, availability
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
//        
//        imageView.isUserInteractionEnabled = true
//        
//        imageView.addGestureRecognizer(gesture)
        
        //updateImage()
        
        swipeCard.delegate = self
        
        swipeCard.dataSource = self
        
        let query = PFUser.query()
        
        query?.whereKeyExists("objectId")
        
        if let latitude = (PFUser.current()!["location"] as AnyObject).latitude {
            
            if let longitude = (PFUser.current()!["location"] as AnyObject).longitude {
                
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
                
            }
        }
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if error == nil {
                
                for object in objects! {
                    
                    if let user = object as? PFUser{
                        
                        let id = user.objectId!
                        
                        guard id != PFUser.current()?.objectId! else { return }
                        
                        let username = user["username"] as! String
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        let courses = user["courses"] as! [String]
                        
                        let skills = user["skills"] as! [String]
                        
                        let availability = user["isInPerson"] as! Bool
                        
                        let userObjectId = user.objectId! as String
                        
                        self.images.append(imageFile)
                        
                        self.users.append(username)
                        
                        self.courses.append(courses)
                        
                        self.skills.append(skills)
                        
                        self.availability.append(availability)
                        
                        self.pfUser.append(user)
                        
                        self.userObjectId.append(userObjectId)
                        
                        self.swipeCard.reloadData()
                        
                    }}
                    
                
            }
            
        })
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
            if let geopoint = geopoint {
                
                PFUser.current()?["location"] = geopoint
                
                PFUser.current()?.saveInBackground()
                
                
                
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            
            PFUser.logOut()
            
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


extension SwipingViewController: KolodaViewDataSource, KolodaViewDelegate{
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        
        return users.count
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let swipeCard = Bundle.main.loadNibNamed("swipeCard", owner: self, options: nil)?[0] as? swipeCard
        
        let imageFile = images[index]
        
        let userCourses = courses[index]
        
        let stringRepresentation = userCourses.joined(separator: "\n")
    
        let userSkills = skills[index]
        
        let stringRepresentation2 = userSkills.joined(separator: "\n")
        
        let available = availability[index]
        
        imageFile.getDataInBackground(block: { (data, error) in
            
            if error != nil {
                
                print(error)
                
            }
            
            if let imageData = data {
                
                swipeCard?.imageView.image = UIImage(data: imageData)
                
                swipeCard?.label.text = self.users[index]
            
                swipeCard?.courses.text = stringRepresentation
                
                swipeCard?.skills.text = stringRepresentation2
                
                if available {
                    
                    swipeCard?.availability.text = "In Person"
                    
                } else {
                    
                    swipeCard?.availability.text = "Online"

                    
                }

                
            }
            

        })
        
        return swipeCard!

        
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        
        return .default
        
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        
        var swipeCard = Bundle.main.loadNibNamed("swipeCard", owner: self, options: nil)?[0] as? swipeCard

        swipeCard?.label.text = "No more users, please try again later"
        
        swipeCard?.coursesLabel.text = ""
        
        swipeCard?.skillsLabel.text = ""
        
        swipeCard?.availabilityLabel.text = ""
        
        self.swipeCard.addSubview(swipeCard!)
    
        
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        
        let user = pfUser[index]
        
        if direction == .left {
            
            if var rejectedUsers = PFUser.current()?["rejectedUsers"] as? [String]{
                
                rejectedUsers.append(user.objectId!)
                
                PFUser.current()?["rejectedUsers"] = rejectedUsers
                
            }
            
            
        } else if direction == .right {
            
            if var acceptedUsers = PFUser.current()?["acceptedUsers"] as? [String]{
                
                acceptedUsers.append(user.objectId!)
                
                PFUser.current()?["acceptedUsers"] = acceptedUsers
            }
            
        }
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                var errorMessage = "Update failed, please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
            } else {
                
                print("Swipe Updated")
                
            }
        
        
    })
    
        return true

    }
    

}









