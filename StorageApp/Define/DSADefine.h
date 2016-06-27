//
//  DSADefine.h
//  StorageApp
//
//  Created by ascii on 16/6/23.
//  Copyright © 2016年 DSB. All rights reserved.
//

#ifndef DSADefine_h
#define DSADefine_h

#define UIColorFromRGB(rgbValue) \
        UIColor(red: ((float)((rgbValue & 0xFF0000) >> 16))/255.0 ,     \
                green: ((float)((rgbValue & 0x00FF00) >>  8))/255.0,    \
                blue: ((float)((rgbValue & 0x0000FF) >>  0))/255.0,     \
                alpha: 1)

#endif /* DSADefine_h */
