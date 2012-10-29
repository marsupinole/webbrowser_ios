//
//  webbrowserViewController.h
//  webbrowser
//
//  Created by Mike Leveton on 10/25/12.
//  Copyright (c) 2012 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface webbrowserViewController : UIViewController <UIWebViewDelegate> //UIWebViewDelegate protocol

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* stop;
@property (nonatomic, retain) UILabel* pageTitle;
@property (nonatomic, retain) UITextField* addressField;

-(void)updateButtons;
-(void)loadAddress:(id)sender event:(UIEvent*)event;
-(void)updateTitle:(UIWebView*)aWebView;
-(void)updateAddress:(NSURLRequest*)request;
- (void)informError:(NSError*)error;  

@end
