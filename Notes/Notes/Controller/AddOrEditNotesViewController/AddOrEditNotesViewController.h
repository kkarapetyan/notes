//
//  AddOrEditNotesViewController.h
//  Notes
//
//  Created by Admin on 28/10/2017.
//  Copyright © 2017 Karine Karapetyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AddOrEditView.h"

@interface AddOrEditNotesViewController : BaseViewController
@property (weak, nonatomic) IBOutlet AddOrEditView *mAddAndEditView;
@property NotesInformationTable * notesInfoObj;

@end
