//
//  UIViewController+Additions.m
//  Notes
//
//  Created by Admin on 31/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (void)alertForWarning:(NSString*)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [ac addAction:okAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

@end
