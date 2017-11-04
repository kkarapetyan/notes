//
//  NotesInformationData.m
//  Notes
//
//  Created by Admin on 29/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "NotesInformationData.h"

@implementation NotesInformationData


-(void)creatAccountIntoDataBase:(NSString *)userName
                  description:(NSString *)password
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    User * user = [[User alloc] init];
    user.userName = userName;
    user.password = password;
    [realm transactionWithBlock:^{
        [realm addObject:user];
    }];
}

-(void)insertDataIntoDataBase:(NSString *)title
                          description:(NSString *)description
                                 date:(NSDate *)date
                         notification:(BOOL)notification
                        color:(NSString *)color
                  currentUsername:(NSString *)currentUsername
{
    NSString * str = [NSString stringWithFormat:@"userName == '%@'", currentUsername];
    User *user = [[User objectsWhere:str] firstObject];
    NotesInformationTable * notesInfo = [[NotesInformationTable alloc] init];
    notesInfo.title = title;
    notesInfo.descript = description;
    notesInfo.notification = notification;
    notesInfo.date = date;
    notesInfo.dateStr = [self convertDateToString:date];
    notesInfo.color = color;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [user.notes addObject:notesInfo];
    }];
}

-(void)updateDataInDataBase:(NotesInformationTable *) selectedDataObject
                      title:(NSString *)title
                description:(NSString *)description
                       date:(NSDate *)date
               notification:(BOOL)notification
                      color:(NSString *)color
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        selectedDataObject.title = title;
        selectedDataObject.descript = description;
        selectedDataObject.notification = notification;
        selectedDataObject.date = date;
        selectedDataObject.dateStr = [self convertDateToString:date];
        selectedDataObject.color = color;
    }];
}

-(void)deleteDataFromDateBase:(NotesInformationTable *) selectedDataObject {
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [[RLMRealm defaultRealm]deleteObject:selectedDataObject];
        }];
}

-(NSString *)convertDateToString:(NSDate *)date {
    return  [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
}
@end
