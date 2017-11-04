//
//  NotesViewController.m
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "NotesViewController.h"
#import "NotesTableViewCell.h"
#import "AddOrEditNotesViewController.h"
#import "LoginViewController.h"
#import "NotesInformationTable.h"
#import "UIColor+Hexadecimal.h"
#import "KeychainItemWrapper.h"
#import <UserNotifications/UserNotifications.h>


@interface NotesViewController () {
    RLMArray * currentNotesArr;
    NotesInformationTable * notesInfoObj;
    KeychainItemWrapper *keychainItem;
}

@property (weak, nonatomic) IBOutlet UITableView *mNotesTbV;
@property (weak, nonatomic) IBOutlet UIButton *mAddBt;
@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self creatRightBarButtonItem];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scheduleLocalNotifications:description:date:identifier:) name:@"SnoozeNotifcation" object:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //get from keychain current username
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLogin" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    User * user = [[User objectsWhere:[NSString stringWithFormat:@"userName == '%@'",username]] firstObject];
    currentNotesArr = user.notes;
    //remove all notifications
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    //delete lines of table if row empty
    self.mNotesTbV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mNotesTbV reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)creatRightBarButtonItem {
    UIBarButtonItem *logOutItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStyleDone target:self action:@selector(logoutSelector)];
    self.navigationItem.rightBarButtonItem = logOutItem;
}

-(void)logoutSelector {
    //remove keychainItem
    [keychainItem resetKeychainItem];
    //remove all notifications of current user
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    [self goToNextControllerWithIdentifier:@"LoginViewCont"
                          objectForpassing:nil];
}
    

#pragma mark - UITable View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentNotesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"notesCellIdentifier";
    NotesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NotesInformationTable * information = [currentNotesArr objectAtIndex:indexPath.row];
    [cell.mTitleOfNotesLb setText:information.title];
    [cell.mDescriptionOfNotesLb setText:information.descript];
    information.color ? [cell.mColorV setBackgroundColor:[UIColor colorWithHexString:information.color]] : [cell.mColorV setBackgroundColor:[UIColor colorWithHexString:defoult_note_color]];
   
    if (information.dateStr) {//when set date of note
      NSString * dataStr = [NSDateFormatter localizedStringFromDate:information.date
                                       dateStyle:NSDateFormatterShortStyle
                                       timeStyle:NSDateFormatterShortStyle];
        [cell.mDateOfNotesLb setText:dataStr];
        [cell.mNotificationImgV setHidden:NO];
        if (information.notification) {//set image of notification
            [cell.mNotificationImgV setImage:activ_notif];
        } else {
            [cell.mNotificationImgV setImage:inactiv_notif];
        }
    } else {
        [cell.mNotificationImgV setHidden:YES];
    }
    if (information.date && information.notification) {
       
        NSDate * dateTimeOfNotification = information.date;
        if ([dateTimeOfNotification timeIntervalSinceNow] > 0) {
            
            NSString * identifierForNote = [NSString stringWithFormat:@"%@_%ld", [keychainItem objectForKey:(__bridge id)kSecAttrAccount], (long)indexPath.row];
            //set notification
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    // Notifications allowed
                    [self scheduleLocalNotifications:cell.mTitleOfNotesLb.text
                                         description:cell.mDescriptionOfNotesLb.text
                                                date:dateTimeOfNotification
                                          identifier:identifierForNote];
                } else {
                    // Notifications not allowed
                }
            }];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotesInformationTable * notesInfoObj = [currentNotesArr objectAtIndex:indexPath.row];
    [self goToNextControllerWithIdentifier:@"AddOrEditNotesViewCont" objectForpassing:notesInfoObj];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotesInformationTable * information = [currentNotesArr objectAtIndex:indexPath.row];
    // device is iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(!information.dateStr) {
            return iPad_tbcell_without_notif_height;//there aren't notification
        }
        return iPad_tbcell_height;
    } else {//device is iPhone
        if(!information.dateStr) {
            return iPhone_tbcell_without_notif_height;//there aren't notification
        }
        return iPhone_tbcell_height;
    }
}

-(void)goToNextControllerWithIdentifier:(NSString *)identifier objectForpassing:(NotesInformationTable *) notesInfoObj  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([identifier isEqualToString:@"AddOrEditNotesViewCont"]) {
        AddOrEditNotesViewController * addOreditViewCont = [storyboard instantiateViewControllerWithIdentifier:identifier];
        addOreditViewCont.notesInfoObj = notesInfoObj;
        [self.navigationController pushViewController:addOreditViewCont animated:YES];
    } else {
        LoginViewController * loginViewCont = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewCont"];
        [self.navigationController pushViewController:loginViewCont animated:YES];

    }
}


#pragma mark -- Action
- (IBAction)addNotesAction:(UIButton *)sender {
    [self goToNextControllerWithIdentifier:@"AddOrEditNotesViewCont" objectForpassing:nil];
}

#pragma mark - Custom Methods
- (void)scheduleLocalNotifications:(NSString *)title description:(NSString *)description date:(NSDate *)date identifier:(NSString *)identifier{
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = title;
    content.body = description;
    content.categoryIdentifier = @"UYLReminderCategory";
    content.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:[date timeIntervalSinceNow] repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
}
@end
