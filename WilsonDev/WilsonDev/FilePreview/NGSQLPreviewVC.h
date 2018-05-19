//
//  NGSQLPreviewVC.h
//  NewGSLib
//
//  Created by Wilson on 22/03/2018.
//  Copyright © 2018 NewGSLib. All rights reserved.
//

/**
 *  原生pdf
 */
#import <QuickLook/QuickLook.h>

@interface NGSQLPreviewVC : QLPreviewController

@property(nonatomic,strong) NSString *URLPath;

@end

