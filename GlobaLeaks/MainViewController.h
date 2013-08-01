//
//  MainViewController.h
//  GlobaLeaks
//
//  Created by Lorenzo on 14/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "GLClient.h"

@interface MainViewController : UIViewController <UINavigationBarDelegate> {
    IBOutlet UINavigationBar *navBar;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UINavigationItem *navItem;
    GLClient *client;
    IBOutlet UIImageView *logo;
}

- (IBAction)revealMenu:(id)sender;

@end
