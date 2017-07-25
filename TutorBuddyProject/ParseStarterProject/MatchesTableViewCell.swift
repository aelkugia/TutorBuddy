//
//  MatchesTableViewCell.swift
//  TutorBuddy
//
//  Created by Abdu Elkugia on 7/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var messagesLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func send(_ sender: Any) {
        
        let message = PFObject(className: "Message") // creating new object in parse for messages
        
        message["sender"] = PFUser.current()?.objectId!
        
        message["recipient"] = userIdLabel.text
        
        message["content"] = messageTextField.text
        
        message.saveInBackground()
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
