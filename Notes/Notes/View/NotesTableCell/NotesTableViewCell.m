//
//  NotesTableViewCell.m
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "NotesTableViewCell.h"
#import "UIView+Point.h"

@implementation NotesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mColorV circleView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
