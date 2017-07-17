//
//  UserDetailsViewController.swift
//  TutorBuddy
//
//  Created by Abdu Elkugia on 7/12/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet weak var currentCourses: UITableView!
    
    var currentCoursesArray = [String]()
    
    @IBOutlet weak var technicalSkill: UITableView!
    
    var technicalSkillArray = [String]()
    
    
    @IBOutlet weak var currentCourseTextView: UITextField!
    
    @IBOutlet weak var technicalSkillTextView: UITextField!
    
    @IBAction func addCourse(_ sender: Any) {
        
        currentCoursesArray.append(currentCourseTextView.text!)
        
        currentCourseTextView.text = ""
        
        view.endEditing(true)
        
        currentCourses.reloadData()
        
    }
    
    @IBAction func addSkill(_ sender: Any) {
        
        technicalSkillArray.append(technicalSkillTextView.text!)
        
        technicalSkillTextView.text = ""
        
        view.endEditing(true)
        
        technicalSkill.reloadData()
        
        
    }
    
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var availableSwitch: UISwitch!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == currentCourses {
            
            return currentCoursesArray.count
            
        } else {
            
            return technicalSkillArray.count
            
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == currentCourses{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentCoursesCell")!
            
            let currentCourse = currentCoursesArray[indexPath.row]
            
            cell.textLabel?.text = currentCourse
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "technicalSkillCell")!
            
            let technicalSkill = technicalSkillArray[indexPath.row]
            
            cell.textLabel?.text = technicalSkill
            
            return cell
        }
    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if tableView == currentCourses{
                
                currentCoursesArray.remove(at: indexPath.row)

            } else {
                
                technicalSkillArray.remove(at: indexPath.row)

            }
            
            tableView.reloadData()
            
        }
        
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        
        PFUser.current()?["isInPerson"] = availableSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?["courses"] = currentCoursesArray
        
        PFUser.current()?["skills"] = technicalSkillArray
        
        PFUser.current()?.saveInBackground(block: { (success, error) in

            if error != nil {
                
                var errorMessage = "Update failed, please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                print("Profile Updated")
                
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
                
            }

        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // This will ensure viewload saves the users latest profile updates
        
        
        if let currentCourses = PFUser.current()?["courses"] as? [String] {
            
            currentCoursesArray = currentCourses
            
        }
        
        if let technicalSkills = PFUser.current()?["skills"] as? [String] {
            
            technicalSkillArray = technicalSkills
            
        }
        
        if let isInPerson = PFUser.current()?["isInPerson"] as? Bool{
            
            availableSwitch.setOn(isInPerson, animated: false)
            
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile{
            
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData){
                        
                        self.userImage.image = downloadedImage
                        
                    }
                    

                    
                }
                
            })
            
        }
        
        let urlArray = ["http://venatrixuk.com/wp-content/themes/ventranix/img/avatars/graduate.png","https://s-media-cache-ak0.pinimg.com/originals/25/7e/8e/257e8e8e17c694cb19ee1a1bd9ccebdc.jpg","https://www.apply4u.co.uk/Cnt/img/SectorImgs/GraduateTraineeJobs.png","https://cdn4.iconfinder.com/data/icons/IMPRESSIONS/education_icons/png/400/graduated.png","http://www.clipartqueen.com/image-files/xgraduation-clipart-girl-with-graduation-hat-color.jpg.pagespeed.ic._9iecTsMPF.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
                
            let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                user["isInPerson"] = false
                
                user["skills"] = ["Python","Java","Swift"]
                
                user["courses"] = ["CS6460 - Educational Technology"]
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                
                user.acl = acl

                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                        
                        print("user signed up!")
                        
                    }
                })
                
                
            } catch {
                
                print("Could not get data")
                
            }
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
