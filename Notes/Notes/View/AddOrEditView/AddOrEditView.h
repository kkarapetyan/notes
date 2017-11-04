//
//  AddOrEditView.h
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NotesInformationTable.h"
#import "DatePickerView.h"
#import "ColorMapView.h"


@interface AddOrEditView : UIView

@property (nonatomic, weak) IBOutlet UITextField * mTitleOfNotesTxtFl;
@property (nonatomic, weak) IBOutlet UITextField * mDataAndTimeTxtFl;
@property (nonatomic, weak) IBOutlet UITextView * mDescriptionOfNotesTxtV;
@property (nonatomic, weak) IBOutlet UILabel * mAllowNotifLb;
@property (nonatomic, weak) IBOutlet UISwitch * mAllowNotifSw;
@property (nonatomic, weak) IBOutlet UIButton * mChooseColorBt;
@property (nonatomic, weak) IBOutlet DatePickerView * mDatePickerBackgroundView;
@property (nonatomic, weak) IBOutlet ColorMapView * mColorMapBackgroundView;
@property (nonatomic, weak) IBOutlet UIView * mColorView;

-(void)insertNoteIntoDataBase;
-(void)updateCurrentNote:(NotesInformationTable *)selectedNotesInfoObj;
-(void)deteleCurrentNote:(NotesInformationTable *)selectedNotesInfoObj;
@end
