//
//  UITextView+Border.m
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "UITextView+Border.h"

@implementation UITextView (Border)

-(void)addBorder {
    self.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 4.0f;
}


@end
