//
//  Movie.h
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *urlImage;

- (id)initWithDictionary:(NSDictionary *) dictionary;

@end
