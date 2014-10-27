//
//  Business.h
//  Yelp
//
//  Created by Erich Owens on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;

// the API we parse from returns an array of dictionaries. Wouldn't it be neat
// to have a factory method that just turns them into an array of our business objects?

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries;


@end
