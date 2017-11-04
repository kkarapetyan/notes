//
//  NotesTableViewCell.h
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mTitleOfNotesLb;
@property (weak, nonatomic) IBOutlet UILabel *mDescriptionOfNotesLb;
@property (weak, nonatomic) IBOutlet UIView *mColorV;
@property (weak, nonatomic) IBOutlet UIImageView *mNotificationImgV;
@property (weak, nonatomic) IBOutlet UILabel *mDateOfNotesLb;
@end
