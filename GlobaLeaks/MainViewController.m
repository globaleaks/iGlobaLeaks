//
//  MainViewController.m
//  GlobaLeaks
//
//  Created by Lorenzo on 14/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    client = [[GLClient alloc] init];
    
    BOOL myBool = YES;
    NSNumber *passedValue = [NSNumber numberWithBool:myBool];
    //dispatch_async(dispatch_get_main_queue(), ^{
        [self loadNode:passedValue];
    //});
    //[NSThread detachNewThreadSelector:@selector(loadNode:) toTarget:self withObject:passedValue];
}

- (void)showReloadButton {
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                    target:self
                                    action:@selector(reload)];
    navItem.rightBarButtonItem = refreshItem;
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    navItem.rightBarButtonItem = activityItem;
}

-(void)loadNode:(NSNumber*)use_cache{
    [self showActivityIndicator];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
        NSDictionary *json = [client loadNode:[use_cache boolValue]];
            //TODO keep downloading those in the main view?
            dispatch_async(dispatch_get_main_queue(), ^{
        if(json != nil){
            titleLabel.text = [json objectForKey:@"name"];
            descriptionLabel.text = [json objectForKey:@"description"];
                    }
        else {
            titleLabel.text = @"ERROR!";
            descriptionLabel.text = [NSString stringWithFormat:@"Cannot connect to GlobaLeaks node %@ Is it the right URL? Edit GLiOS settings, prepend \"http://\" or \"https://\" protocol and verify that your node is up and running.", [[NSUserDefaults standardUserDefaults] stringForKey:@"Site"]];
        }
                UIImage *img = [UIImage imageWithData:[client getImage:[use_cache boolValue] withId:@"globaleaks_logo"]];
        if (img != nil) [logo setImage:img];
        [client loadData:[use_cache boolValue] ofType:@"receivers"];
        [client loadData:[use_cache boolValue] ofType:@"contexts"];
        [self showReloadButton];
        });
    });
}

-(void)reload {
    BOOL myBool = NO;
    NSNumber *passedValue = [NSNumber numberWithBool:myBool];
    [NSThread detachNewThreadSelector:@selector(loadNode:) toTarget:self withObject:passedValue];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
