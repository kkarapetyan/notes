//
//  NotesInformationTable.h
//  Notes
//
//  Created by Admin on 29/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface NotesInformationTable : RLMObject

@property NSString * title;
@property NSString * descript;
@property NSString * dateStr;
@property NSDate * date;
@property NSString * color;
@property BOOL notification;

@end
RLM_ARRAY_TYPE(NotesInformationTable)
