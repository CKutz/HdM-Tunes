//
//  JETopBarViewController.swift
//  JETopTabBarController
//
//  Created by JE on 02.06.15.
//  Copyright (c) 2015 JE. All rights reserved.
//

import UIKit

@IBDesignable
class InspectableView: UIView
{
    @IBInspectable var tabOne: String? {
        didSet {
            self.setupTabs()
        }
    }
    @IBInspectable var tabTwo: String? {
        didSet {
            self.setupTabs()
        }
    }
    @IBInspectable var tabThree: String? {
        didSet {
            self.setupTabs()
        }
    }
    
    var buttonArr = [UIButton]()
    
    func setupTabs()
    {
        for button in self.buttonArr
        {
            button.removeFromSuperview()
        }
        self.buttonArr = [UIButton]()
        
        let tabs = [tabOne, tabTwo, tabThree]
        
        // create a button for every tabTitle
        for tab in tabs
        {
            if let title = tab
            {
                var button = UIButton.buttonWithType(UIButtonType.System) as UIButton
                button.setTitle(title, forState: UIControlState.Normal)
                button.addTarget(self, action: "showTabContent:", forControlEvents: UIControlEvents.TouchUpInside)
                button.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.addSubview(button)
                buttonArr.append(button)
            }
        }
        
        // layout
        // create views array
        var views = [String: UIButton]()
        let metrics = ["top": 0]
        
        for (index, button) in enumerate(buttonArr)
        {
            views["button\(index)"] = button
        }
        
        // vertical constraints
        for (index, button) in enumerate(buttonArr)
        {
            self.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|-top-[button\(index)]",
                    options: nil,
                    metrics: metrics,
                    views: views))
        }
        
        // horizontal constraints
        var horizontalString = "H:|[button0]"
        
        for var i = 1; i < buttonArr.count; i++
        {
            horizontalString += "[button\(i)(==button0)]"
        }
        
        horizontalString += "|"
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(horizontalString,
                options: nil,
                metrics: nil,
                views: views))
    }
}


class JETopBarViewController: UIViewController
{
    @IBInspectable var tabOne: String?
    @IBInspectable var tabTwo: String?
    @IBInspectable var tabThree: String?
    @IBInspectable var tabFour: String?
    @IBInspectable var tabFive: String?
    
    var buttonArr = [UIButton]()
    var contentView: UIView!
    var playerView: UIView!
    
    var contentViewController: UIViewController! {
        willSet {
            self.displayContentController(newValue, onView: self.contentView)
        }
        didSet {
            if let controller = oldValue
            {
                self.hideContentViewController(controller)
            }
        }
    }
    
    var playerViewController: UIViewController! {
        willSet {
            self.displayContentController(newValue, onView: self.playerView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTabs()
        self.setupContentView()
        self.setupFirstContent()
        self.setupPlayer()
    }
    
    
    
    // setup the tabs
    func setupTabs()
    {
        let tabs = [
            tabOne,
            tabTwo,
            tabThree,
            tabFour,
            tabFive
        ]
        
        // create a button for every tabTitle
        for tab in tabs
        {
            if let title = tab
            {
                var button = UIButton.buttonWithType(UIButtonType.System) as UIButton
                button.setTitle(title,
                    forState: UIControlState.Normal)
                button.addTarget(self,
                    action: "changeTabContent:",
                    forControlEvents: UIControlEvents.TouchUpInside)
                button.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.view.addSubview(button)
                buttonArr.append(button)
            }
        }
        
        // layout
        // create views array
        var views = [String: UIButton]()
        let metrics = ["top": 30]
        
        for (index, button) in enumerate(buttonArr)
        {
            views["button\(index)"] = button
        }
        
        // vertical constraints
        for (index, button) in enumerate(buttonArr)
        {
            self.view.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|-top-[button\(index)]",
                    options: nil,
                    metrics: metrics,
                    views: views))
        }
        
        // horizontal constraints
        var horizontalString = "H:|[button0]"
        
        for var i = 1; i < buttonArr.count; i++
        {
            horizontalString += "[button\(i)(==button0)]"
        }
        
        horizontalString += "|"
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(horizontalString,
                options: nil,
                metrics: nil,
                views: views))
    }
    
    
    // change the content in the tab
    func changeTabContent(sender: UIButton)
    {
        if let title = sender.titleLabel?.text
        {
            self.contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(title) as UIViewController
        }
    }
    
    func setupContentView()
    {
        let devider = UIView()
        devider.backgroundColor = UIColor.lightGrayColor()
        devider.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(devider)
        
        self.contentView = UIView()
        self.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(self.contentView)
        
        self.playerView = UIView()
        self.playerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(self.playerView)
        
        let views = [
            "devider": devider,
            "content": self.contentView,
            "player": self.playerView
        ]
        let metrics = [
            "top": 62,
            "deviderHeight": 1,
            "playerHeight": 120
        ]
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[devider]|",
                options: nil,
                metrics: nil,
                views: views))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-top-[devider(deviderHeight)]",
                options: nil,
                metrics: metrics,
                views: views))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[content]|",
                options: nil,
                metrics: nil,
                views: views))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[player]|",
                options: nil,
                metrics: nil,
                views: views))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[devider][content][player(playerHeight)]|",
                options: nil,
                metrics: metrics,
                views: views))
    }
    
    func setupFirstContent()
    {
        if let first = self.tabOne
        {
            self.contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(first) as UIViewController
        }
    }
    
    func setupPlayer()
    {
        self.playerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Player") as UIViewController
    }
    
    //MARK: - Container Controller
    
    func displayContentController(content: UIViewController, onView view: UIView)
    {
        self.addChildViewController(content)
        content.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        content.view.alpha = 0.0
        view.addSubview(content.view)
        content.didMoveToParentViewController(self)
        
        let views = ["content": content.view]
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[content]|",
                options: nil,
                metrics: nil,
                views: views))
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[content]|",
                options: nil,
                metrics: nil,
                views: views))
        
        UIView.animateWithDuration(
            0.25,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                content.view.alpha = 1.0
            }, completion: nil)
    }
    
    func hideContentViewController(content: UIViewController)
    {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
