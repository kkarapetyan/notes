//
//  UITextField+Content.m
//  DCC
//
//  Created by Admin on 14/06/16.
//  Copyright © 2016 Karine Karapetyan. All rights reserved.
//

#import "UITextField+Content.h"

@implementation UITextField (Content)

- (void) addEgdeInsetsOnTextFields {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   12, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
