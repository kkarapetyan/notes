//
//  ColorMapView.h
//  Notes
//
//  Created by Admin on 10/30/17.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRColorMapView.h"

@interface ColorMapView : UIView

@property (nonatomic, strong) IBOutlet UIBarButtonItem * mDoneBarBt;
@property (nonatomic, weak) IBOutlet HRColorMapView * mColorMapView;
@property (nonatomic, strong) UIColor* color;

@end
