//
//  webbrowserViewController.m
//  webbrowser
//
//  Created by Mike Leveton on 10/25/12.
//  Copyright (c) 2012 Mike Leveton. All rights reserved.
//

#import "webbrowserViewController.h"

static const CGFloat kNavBarHeight = 52.0f;
static const CGFloat kLabelHeight = 14.0f;
static const CGFloat kMargin = 10.0f;
static const CGFloat kSpacer = 2.0f;
static const CGFloat kLabelFontSize = 12.0f;
static const CGFloat kAddressHeight = 26.0f;

@interface webbrowserViewController ()

@end

@implementation webbrowserViewController

@synthesize webView; 
@synthesize toolbar; 
@synthesize back; 
@synthesize forward; 
@synthesize refresh; 
@synthesize stop; 
@synthesize pageTitle;
@synthesize addressField; 

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	NSAssert(self.back, @"Unconnected IBOutlet 'back'");
    NSAssert(self.forward, @"Unconnected IBOutlet 'forward'");
    NSAssert(self.refresh, @"Unconnected IBOutlet 'refresh'");
    NSAssert(self.stop, @"Unconnected IBOutlet 'stop'");
    NSAssert(self.webView, @"Unconnected IBOutlet 'webView'");
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSURL* url = [NSURL URLWithString:@"http://iosdeveloperzone.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self updateButtons];
    
    CGRect navBarFrame = self.view.bounds;
    navBarFrame.size.height = kNavBarHeight;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect labelFrame = CGRectMake(kMargin, kSpacer,
                                   navBar.bounds.size.width - 2*kMargin, kLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = UITextAlignmentCenter;
    [navBar addSubview:label];
    self.pageTitle = label;
    
    CGRect addressFrame = CGRectMake(kMargin, kSpacer*2.0 + kLabelHeight,
                                     labelFrame.size.width, kAddressHeight);
    UITextField *address = [[UITextField alloc] initWithFrame:addressFrame];
    address.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    address.borderStyle = UITextBorderStyleRoundedRect;
    address.font = [UIFont systemFontOfSize:17];
    address.keyboardType = UIKeyboardTypeURL;
    address.autocapitalizationType = UITextAutocapitalizationTypeNone;
    address.clearButtonMode = UITextFieldViewModeWhileEditing;
    [address addTarget:self
                action:@selector(loadAddress:event:)
      forControlEvents:UIControlEventEditingDidEndOnExit];
    [navBar addSubview:address];
    self.addressField = address;
    
    [self.view addSubview:navBar];
    
    CGRect webViewFrame = self.webView.frame;
    webViewFrame.origin.y = navBarFrame.origin.y + navBarFrame.size.height;
    webViewFrame.size.height = self.toolbar.frame.origin.y - webViewFrame.origin.y;
    self.webView.frame = webViewFrame;
    
    //Gesture Recognizers
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture:)];
    leftSwipe.numberOfTouchesRequired = 1;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardGesture:)];
    rightSwipe.numberOfTouchesRequired = 1;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webView addGestureRecognizer:rightSwipe];

}

- (void)viewDidUnload
{
    self.webView = nil;
    self.toolbar = nil;
    self.back = nil;
    self.forward = nil;
    self.refresh = nil;
    self.stop = nil;
    [super viewDidUnload];
    self.pageTitle = nil;
    self.addressField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self updateTitle:webView];
    NSURLRequest* request = [webView request];
    [self updateAddress:request];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    if([error code] != NSURLErrorCancelled)
    {
        [self informError:error];
    }
}

- (void)updateButtons
{
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
    self.stop.enabled = self.webView.loading;
}

- (void)loadAddress:(id)sender event:(UIEvent *)event
{
    NSString* urlString = self.addressField.text;
    NSURL* url = [NSURL URLWithString:urlString];
    if (!url.scheme)
    {
        NSString *ModifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:ModifiedURLString];
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)updateTitle:(UIWebView*)aWebView
{
    NSString* pageTitle = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.pageTitle.text = pageTitle;
}

- (void)updateAddress:(NSURLRequest*)request
{
    NSURL* url = [request mainDocumentURL];
    NSString* absoluteString = [url absoluteString];
    self.addressField.text = absoluteString;
}

- (void)informError:(NSError *)error
{
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:localizedDescription delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)backGesture:(UISwipeGestureRecognizer*)recognizer
{
    [self.webView goBack];
}

- (void)forwardGesture:(UISwipeGestureRecognizer*)recognizer
{
    [self.webView goForward];
}

@end
