//
//  webbrowserAppDelegate.h
//  webbrowser
//
//  Created by Mike Leveton on 10/25/12.
//  Copyright (c) 2012 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class webbrowserViewController;

@interface webbrowserAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) webbrowserViewController *viewController;

@end
