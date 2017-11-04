//
//  DatePickerView.h
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateDelegate <NSObject>
@optional
-(void)setDate:(NSDate *)choosenDate;
@end

@interface DatePickerView : UIView

@property (nonatomic, weak) IBOutlet UIDatePicker * mDatePickerV;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* mDoneBarBt;

@property (nonatomic, weak) id<DateDelegate> dateDelegate;

@end
