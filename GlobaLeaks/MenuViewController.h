//
//  MenuViewController.h
//  GlobaLeaks
//
//  Created by Lorenzo on 14/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate> {
    UITextField *textField;
    IBOutlet UITableView *table;
}

@end
