//
//  MenuViewController.m
//  GlobaLeaks
//
//  Created by Lorenzo on 14/07/2013.
//  Copyright (c) 2013 Lorenzo Primiterra. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()
@property (nonatomic, strong) NSArray *itemID;
@property (nonatomic, strong) NSArray *itemNames;

@end

@implementation MenuViewController
@synthesize itemID, itemNames;

- (void)awakeFromNib
{
    self.itemID = [NSArray arrayWithObjects:@"Main", @"Whistle", @"Search", @"Settings", @"About", @"Help", nil];
    self.itemNames = [NSArray arrayWithObjects:NSLocalizedString(@"Current node", @""), NSLocalizedString(@"Blow the whistle!", @""), NSLocalizedString(@"Seach ticket", @""), NSLocalizedString(@"Settings", @""), NSLocalizedString(@"About", @""), NSLocalizedString(@"Help", @""), nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.itemID.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.itemNames objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.itemID objectAtIndex:indexPath.row]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Search submission", @"") message:NSLocalizedString(@"Enter your receipt number or search in your phonebook", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Phonebook", @""), NSLocalizedString(@"OK", @""), nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        textField = [alertView textFieldAtIndex:0];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [alertView show];
    }
    else {
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.itemID objectAtIndex:indexPath.row]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //0 phonebook
    //1 enter
    if (buttonIndex == 0){
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1){
        if ([textField.text length] != 0 ) {
        }
        else {
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [table selectRowAtIndexPath:topIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:table didSelectRowAtIndexPath:0];
        }
    }
    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    //NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //TODO: if multiple numbers, let the user choose
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    //remove all ( ) - and spaes
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phone);
    //textField.text = phone;

    //GLClient *client = [[GLClient alloc] init];
    //[client login:phone];
    CFRelease(phoneNumbers);
}
@end
