//
//  DatePickerView.m
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView 

- (IBAction)doneBarButtonAction:(UIBarButtonItem *)sender {
    [self setHidden:YES];
    [self.dateDelegate setDate:self.mDatePickerV.date];
    NSLog(@"Date = %@", self.mDatePickerV.date);
}

@end
