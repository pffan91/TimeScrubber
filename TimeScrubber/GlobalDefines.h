//
//  GlobalDefines.h
//  ALLIE
//
//  Created by Vladyslav Semecnhenko on 3/31/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#define kServerPrefix @"https://testing.alliecam.com/api"
//#define kServerPrefix @"http://allie.ekosarev.http.netlab/api"
#define kDemoLogin @"demo@alliecam.com"
#define kDemoPassword @"123456"
#define kBambooBuildNumber @"###BambooBuildNumber###"

// Design
#define kColorScheme [UIColor colorWithRed:1.000 green:0.577 blue:0.000 alpha:1.000]
#define kColorGrey [UIColor colorWithRed:0.387 green:0.395 blue:0.405 alpha:1.000]
#define kColorTintNavBar [UIColor blackColor]

// misc
#define IsPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_PHONEPOD5() ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_PHONEPOD6() ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_PHONEPOD6p() ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

// Texts variables
#define kTermsOfServicePage @"terms-of-service"
#define kAboutPage @"about"
#define kPrivacyPolicyPage @"privacy-policy"
