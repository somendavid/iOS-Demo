//
//  ScrollViewControllerBase.swift
//  iOS Demo
//
//  Created by David Somen on 13/03/2015.
//  Copyright (c) 2015 David Somen. All rights reserved.
//

import UIKit

class ScrollViewControllerBase: UIViewController, UITextFieldDelegate
{
    var keyboardInfoFrame : CGSize? = CGSizeMake(400, 400)
    
    @IBOutlet var scrollView : UIScrollView?
    var currentTextField : UITextField?
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        currentTextField = textField
        
        moveScrollView()
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        currentTextField = nil
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        let userInfo = notification.userInfo
        keyboardInfoFrame = userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        
        moveScrollView()
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        scrollView?.setContentOffset(CGPointZero, animated: true)
    }
    
    func moveScrollView()
    {
        let elementOrigin = currentTextField?.frame.origin
        let elementHeight = currentTextField?.frame.size.height
        let keyboardHeight = keyboardInfoFrame?.height
        
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardHeight!
        
        if(!CGRectContainsPoint(visibleRect, elementOrigin!))
        {
            let scrollPoint = CGPointMake(0, elementOrigin!.y - visibleRect.size.height + elementHeight!)
            
            scrollView?.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    /*
- (void)keyboardWasShown:(NSNotification *)notification {

NSDictionary* info = [notification userInfo];

CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

CGPoint buttonOrigin = self.signInButton.frame.origin;

CGFloat buttonHeight = self.signInButton.frame.size.height;

CGRect visibleRect = self.view.frame;

visibleRect.size.height -= keyboardSize.height;

if (!CGRectContainsPoint(visibleRect, buttonOrigin)){

CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);

[self.scrollView setContentOffset:scrollPoint animated:YES];

}

}

- (void)keyboardWillBeHidden:(NSNotification *)notification {

[self.scrollView setContentOffset:CGPointZero animated:YES];

}
*/

    /*
    func keyboardWasShown(notification: NSNotification)
    {
        let userInfo = notification.userInfo
        keyboardInfoFrame = userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue()
    }
    
    func moveScrollView()
    {
        let windowFrame = view.window?.convertRect(view.frame, fromView: view)
        let keyboardFrame = CGRectIntersection(windowFrame!, keyboardInfoFrame!)
        let coveredFrame = view.window?.convertRect(keyboardFrame, toView: view)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, coveredFrame!.size.height, 0)
        
        if let scrollViewView = scrollView
        {
            scrollViewView.contentInset = contentInsets
            scrollViewView.scrollIndicatorInsets = contentInsets
            
            scrollViewView.contentSize = CGSizeMake(scrollViewView.frame.size.width, scrollViewView.contentSize.height)
            
            if let textField = currentTextField
            {
                scrollViewView.scrollRectToVisible(textField.superview!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsetsZero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
*/
}
