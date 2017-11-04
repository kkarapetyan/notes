//
//  AddOrEditView.m
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//


#import "AddOrEditView.h"
#import "UITextView+Border.h"
#import "UIView+Point.h"
#import "UIColor+Hexadecimal.h"
#import "NotesInformationData.h"
#import "HRColorPickerView.h"
#import "BaseViewController.h"
#import "KeychainItemWrapper.h"

#define maxRangeOfTitle 30
#define maxRangeOfDescription 200

@interface AddOrEditView ()<UITextFieldDelegate, UITextViewDelegate, DateDelegate> {
    
    NotesInformationData * notesInformationData;
    NSDate * pickerDate;
    NSString * hexColor;
}
@end

@implementation AddOrEditView {
    UIColor *_color;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(void)setup {

    notesInformationData = [[NotesInformationData alloc] init];
    self.mTitleOfNotesTxtFl.delegate = self;
    self.mDataAndTimeTxtFl.delegate = self;
    self.mDescriptionOfNotesTxtV.delegate = self;
    self.mDatePickerBackgroundView.dateDelegate = self;
    [self.mDescriptionOfNotesTxtV addBorder];
    [self.mColorView circleView];
    [self.mColorMapBackgroundView.mColorMapView addTarget:self
                           action:@selector(colorDidChange:)
                 forControlEvents:UIControlEventValueChanged];
}

- (void)colorDidChange:(HRColorPickerView *)colorPickerView {
    hexColor = [self hexStringForColor:colorPickerView.color];
    self.mColorView.backgroundColor = [UIColor colorWithHexString:hexColor];

}

- (NSString *)hexStringForColor:(UIColor *)color {
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

#pragma mark -- TextFiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= maxRangeOfTitle;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mDatePickerBackgroundView setHidden:NO];
        [self.mColorMapBackgroundView setHidden:YES];
    return NO;  // Hide both keyboard and blinking cursor.
    } else {
        return  YES;
    }
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqual:@"Type description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqual:@""]) {
        textView.text = @"Type description";
        textView.textColor = [UIColor grayColor];
    } else {
    }
    return  YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

   if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    //set max range of description
    if(range.length + range.location > textView.text.length) {
        return NO;
    }
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= maxRangeOfDescription;
}

#pragma mark -- Date Delegate
-(void)setDate:(NSDate *)choosenDate {
    //set date from datePickerView
    [self hideNotificationFiled:NO];
    pickerDate = choosenDate;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:choosenDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    NSLog(@"%@",dateString);
    [self.mDataAndTimeTxtFl setText:dateString];
}

-(void)hideNotificationFiled:(BOOL)hidden {
    [self.mAllowNotifLb setHidden:hidden];
    [self.mAllowNotifSw setHidden:hidden];
}

#pragma mark -- Actions
- (IBAction)allowNotificationSwitch:(UISwitch *)sender {
    
}
- (IBAction)chooseColorAction:(UIButton *)sender {
    [self.mColorMapBackgroundView setHidden:NO];
    [self.mDatePickerBackgroundView setHidden:YES];
}

-(void)insertNoteIntoDataBase {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLogin" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    [notesInformationData insertDataIntoDataBase:self.mTitleOfNotesTxtFl.text
                                             description:self.mDescriptionOfNotesTxtV.text
                                                    date:pickerDate
                                            notification:self.mAllowNotifSw.isOn
                                                   color:hexColor currentUsername:username];
}

-(void)updateCurrentNote:(NotesInformationTable *)selectedNotesInfoObj {
    if (!pickerDate) {
        pickerDate = selectedNotesInfoObj.date;
    }
    if (!hexColor) {
         hexColor = [self hexStringForColor:self.mColorView.backgroundColor];
    }
    [notesInformationData updateDataInDataBase:selectedNotesInfoObj
                                         title:self.mTitleOfNotesTxtFl.text
                                   description:self.mDescriptionOfNotesTxtV.text
                                          date:pickerDate
                                  notification:[self.mAllowNotifSw isOn]
                                         color:hexColor];
}

-(void)deteleCurrentNote:(NotesInformationTable *)selectedNotesInfoObj {
    [notesInformationData deleteDataFromDateBase:selectedNotesInfoObj];
}
@end
