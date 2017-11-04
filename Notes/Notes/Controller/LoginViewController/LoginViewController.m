//
//  LoginViewController.m
//  Notes
//
//  Created by Admin on 11/2/17.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "LoginViewController.h"
#import "NotesViewController.h"
#import "NotesInformationTable.h"
#import "User.h"
#import "UIViewController+Additions.h"
#import "AESCrypt.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mUsernameTxtFl;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTxtFl;
@property (weak, nonatomic) IBOutlet UIButton *mLoginBt;
@property (weak, nonatomic) IBOutlet UIButton *mCreateAccountBt;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.mUsernameTxtFl setText:@""];
    [self.mPasswordTxtFl setText:@""];

}
- (IBAction)loginAction:(UIButton *)sender {
    
    NSString * str = [NSString stringWithFormat:@"userName == '%@' && password == '%@'", self.mUsernameTxtFl.text, [AESCrypt encrypt:@"" password:self.mPasswordTxtFl.text]];
    User *user = [[User objectsWhere:str] firstObject];
    if (user) {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLogin" accessGroup:nil];
        [keychainItem setObject:self.mPasswordTxtFl.text forKey:(__bridge id)kSecValueData];
        [keychainItem setObject:self.mUsernameTxtFl.text forKey:(__bridge id)kSecAttrAccount];
        
        [self goToNotesController];
    } else {
        [self alertForWarning:mess_incorr_username_pass];
    }
}

- (IBAction)createAccount:(UIButton *)sender {
    if ([self isValidFileds]) {
        
        NSString * str = [NSString stringWithFormat:@"userName == '%@'", self.mUsernameTxtFl.text];
        User *user = [[User objectsWhere:str] firstObject];
        if (!user) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            User * user = [[User alloc] init];
            user.userName = self.mUsernameTxtFl.text;
            user.password = [AESCrypt encrypt:@"" password:self.mPasswordTxtFl.text];
            [realm transactionWithBlock:^{
                [realm addObject:user];
            }];
            User * currentUser = [[User alloc] init];
            currentUser = user;
            KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLogin" accessGroup:nil];
            
            [keychainItem setObject:self.mPasswordTxtFl.text forKey:(__bridge id)kSecValueData];
            [keychainItem setObject:self.mUsernameTxtFl.text forKey:(__bridge id)kSecAttrAccount];
            
            [self goToNotesController];
        } else {
             [self alertForWarning:mess_user_exist];
        }
    }
}

-(void)goToNotesController {
    [self.mPasswordTxtFl resignFirstResponder];
    [self.mUsernameTxtFl resignFirstResponder];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotesViewController *newViewCont = [storyboard instantiateViewControllerWithIdentifier:@"NotesViewContr"];
    [self.navigationController pushViewController:newViewCont animated:YES];
}

-(BOOL)isValidFileds {
    if (self.mUsernameTxtFl.text.length == 0) {
        [self alertForWarning:mess_user_empty];
        return NO;

    } else if (self.mPasswordTxtFl.text.length == 0) {
        [self alertForWarning:mess_password_empty];
        return NO;

    } else if ([[self.mUsernameTxtFl.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0 || [[self.mPasswordTxtFl.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0 ) {
        [self alertForWarning:mess_contain_spaces];
        return NO;

    } else if (self.mPasswordTxtFl.text.length < 5) {
        [self alertForWarning:mess_password_char_count];
        return NO;

    }
    return YES;
}

#pragma mark -- TextFiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    UIResponder * nextResponder = [[[textField superview] superview]  viewWithTag:textField.tag + 1];
    if (textField.tag == 0 ) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;

}

@end
