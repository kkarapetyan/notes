//
//  NotesInformationData.h
//  Notes
//
//  Created by Admin on 29/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesInformationTable.h"
#import "User.h"

@interface NotesInformationData : UIView

-(void)insertDataIntoDataBase:(NSString *)title
                  description:(NSString *)description
                         date:(NSDate *)date
                 notification:(BOOL)notification
                        color:(NSString *)color
              currentUsername:(NSString *)currentUsername;
-(void)updateDataInDataBase:(NotesInformationTable *) selectedDataObject
                      title:(NSString *)title
                description:(NSString *)description
                       date:(NSDate *)date
               notification:(BOOL)notification
                      color:(NSString *)color;
-(void)deleteDataFromDateBase:(NotesInformationTable *) selectedDataObject;
@end
