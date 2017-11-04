//
//  AddOrEditNotesViewController.m
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "AddOrEditNotesViewController.h"
#import "UITextView+Border.h"
#import "UIColor+Hexadecimal.h"
#import "UIViewController+Additions.h"
#import "KeychainItemWrapper.h"


@interface AddOrEditNotesViewController () {
    BOOL isEdit;
}
@property (weak, nonatomic) IBOutlet UIButton *mSaveBt;
@end
@implementation AddOrEditNotesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- Set
-(void)setup {
    [self.mAddAndEditView.mTitleOfNotesTxtFl setTextColor:enable_color];
    [self.mAddAndEditView.mDataAndTimeTxtFl setTextColor:enable_color];
    //edit or delete note
    if (self.notesInfoObj) {
        [self.mSaveBt setHidden:YES];
        [self creatLeftBarButtonItem];
        [self creatRightBarButtonItem];
        [self setNotesInformation];
        [self isEditable:NO];
    } else {//add new note
        [self.mSaveBt setHidden:NO];
        [self creatLeftBarButtonItem];
        [self.mAddAndEditView.mDescriptionOfNotesTxtV setText:@"Type description"];
        [self.mAddAndEditView.mColorView setBackgroundColor:[UIColor colorWithHexString:defoult_note_color]];
        [self isEditable:YES];
    }
}
- (void)setNotesInformation
{
    [self.mAddAndEditView.mTitleOfNotesTxtFl setText:self.notesInfoObj.title];
    self.notesInfoObj.color ? [self.mAddAndEditView.mColorView setBackgroundColor:[UIColor colorWithHexString:self.notesInfoObj.color]] : [self.mAddAndEditView.mColorView setBackgroundColor:[UIColor colorWithHexString:defoult_note_color]];
    if (self.notesInfoObj.descript) {
        [self.mAddAndEditView.mDescriptionOfNotesTxtV setText:self.notesInfoObj.descript];
    } else {
        [self.mAddAndEditView.mDescriptionOfNotesTxtV setText:@"Type description"];
    }
    if (self.notesInfoObj.dateStr) {
        [self.mAddAndEditView.mDataAndTimeTxtFl setText:self.notesInfoObj.dateStr];
        [self.mAddAndEditView.mAllowNotifSw setOn:self.notesInfoObj.notification];
        [self.mAddAndEditView.mAllowNotifLb setHidden:NO];
        [self.mAddAndEditView.mAllowNotifSw setHidden:NO];
    }
}

-(void)isEditable:(BOOL)isEnable {
    if (isEnable) {
        self.mAddAndEditView.alpha = 1.0;
    } else{
        self.mAddAndEditView.alpha = 0.5;
    }
    [self.mAddAndEditView setUserInteractionEnabled:isEnable];
    if (![self.mAddAndEditView.mDescriptionOfNotesTxtV.text isEqualToString:@"Type description"]) {
        [self.mAddAndEditView.mDescriptionOfNotesTxtV setTextColor:enable_color];
    }
}

-(void)creatLeftBarButtonItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonSelector)];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)creatRightBarButtonItem {
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStyleDone target:self action:@selector(editBarButtonSelector)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteBarButtonSelector)];
    self.navigationItem.rightBarButtonItems = @[deleteItem, editItem];
}

#pragma mark -- Selectors
-(void) backBarButtonSelector {
    if (isEdit) {
        if ([self isValidFields]) {
            [self.mAddAndEditView updateCurrentNote:self.notesInfoObj];
        }
    }
[self.navigationController popViewControllerAnimated:YES];
}
- (void)editBarButtonSelector {
    isEdit = YES;
    [self isEditable:isEdit];

}
- (void)deleteBarButtonSelector {
    
    [self.mAddAndEditView deteleCurrentNote:self.notesInfoObj];
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)saveAction:(UIButton *)sender {
    if ([self isValidFields]) {
        //save new note
        [self.mAddAndEditView insertNoteIntoDataBase];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)isValidFields {
    //is title filed contain only spases or empty
    if ( [[self.mAddAndEditView.mTitleOfNotesTxtFl.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        [self alertForWarning:mess_title];
        return NO;
    }
    //is description filed contain only spases or empty
    if ([[self.mAddAndEditView.mDescriptionOfNotesTxtV.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0 || [self.mAddAndEditView.mDescriptionOfNotesTxtV.text isEqualToString:@"Type description"]) {
        [self alertForWarning:mess_desc];
        return NO;
    }
    return YES;
}
@end
