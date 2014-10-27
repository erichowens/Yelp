//
//  DropDownCell.h
//  Yelp
//
//  Created by Erich Owens on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownCell;

@protocol DropDownCellDelegate <NSObject>

- (void)dropDownCell:(DropDownCell *)cell didUpdateValue:(BOOL)value;

@end


@interface DropDownCell : UITableViewCell
@property (nonatomic, weak) id<DropDownCellDelegate> delegate;

@end
