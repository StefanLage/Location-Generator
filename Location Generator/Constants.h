//
//  Constants.h
//  Location Generator
//
//  Created by Stefan Lage on 27/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#define PYTHON_PATH                 @"/usr/bin/python"
#define GPX_SCRIPT_NAME             @"gpx-generator"
#define PYTHON_EXTENSION            @"py"
#define GPX_OPTION_ADDRESS          @"-a"
#define GPX_OPTION_CITY             @"-ci"
#define GPX_OPTION_COUNTRY          @"-co"
#define GPX_OPTION_OUTPUT           @"-o"
#define GPX_OPTION_PATH             @"-p"
#define GPX_OPTION_POSTAL_CODE      @"-pc"


#define GPX_PATH                [NSString stringWithFormat:@"%@/Documents/GPX_Generator/", NSHomeDirectory()]
#define GPX_URL                 [[NSURL alloc] initFileURLWithPath:GPX_PATH]
#define GENERATOR_ERROR         @"Location Unknown !"


#define NOTIFICATION_ERROR      @"gpx_error"
#define NOTIFICATION_GPX        @"gpx_generator"
#define NOTIFICATION_TITLE      @"Location Generator"
#define NOTIFICATION_MESSAGE    @"GPX file \"%@.gpx\" created"
#define GPX_DEFAULT_FILENAME    @"gpxFile"
#define REQUIRED_MSG            @"Please inform required fields!"
#define EMPTY_STRING            @""
