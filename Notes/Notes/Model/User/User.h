//
//  User.h
//  Notes
//
//  Created by Admin on 11/2/17.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import <Realm/Realm.h>
#import "NotesInformationTable.h"

@interface User : RLMObject
@property NSString * userName;
@property NSString * password;
@property RLMArray<NotesInformationTable> * notes;

@end
