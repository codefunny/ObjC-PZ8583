//
//  dl_iso8583_defs_zhifu.c
//  iso8583_demo
//
//  Created by mark zheng on 15/6/9.
//  Copyright (c) 2015年 paylab. All rights reserved.
//

#include "dl_iso8583_defs_pos.h"

/******************************************************************************/

static DL_ISO8583_FIELD_DEF _iso8583_pos_fields[] = {
    /*   0 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Message Type Indicator
    /*   1 */ {kDL_ISO8583_BMP,  8,kDL_ISO8583_CONTVAR}, // Bitmap
    /*   2 */ {kDL_ISO8583_N  , 19,kDL_ISO8583_LLVAR  }, // Primary Account Number
    /*   3 */ {kDL_ISO8583_N  ,  6,kDL_ISO8583_FIXED  }, // Processing Code
    /*   4 */ {kDL_ISO8583_N  , 12,kDL_ISO8583_FIXED  }, // Amount, Txn
    /*   5 */ {kDL_ISO8583_N  , 12,kDL_ISO8583_FIXED  }, // Amount, Settlement
    /*   6 */ {kDL_ISO8583_N  , 12,kDL_ISO8583_FIXED  }, // Amount, Cardholder Billing
    /*   7 */ {kDL_ISO8583_N  , 10,kDL_ISO8583_FIXED  }, // Date and Time, Transmission
    /*   8 */ {kDL_ISO8583_N  ,  8,kDL_ISO8583_FIXED  }, // Amount, Cardholder Billing Fee
    /*   9 */ {kDL_ISO8583_N  ,  8,kDL_ISO8583_FIXED  }, // Conversion Rate, Settlement
    /*  10 */ {kDL_ISO8583_N  ,  8,kDL_ISO8583_FIXED  }, // Conversion Rate, Cardholder Billing
    /*  11 */ {kDL_ISO8583_N  ,  6,kDL_ISO8583_FIXED  }, // Systems Trace Audit Number
    /*  12 */ {kDL_ISO8583_N  ,  6,kDL_ISO8583_FIXED  }, // Time, Local Txn
    /*  13 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Date, Local Txn
    /*  14 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Date, Expiration
    /*  15 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Date, Settlement
    /*  16 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Date, Conversion
    /*  17 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Date, Capture
    /*  18 */ {kDL_ISO8583_N  ,  4,kDL_ISO8583_FIXED  }, // Merchant Type
    /*  19 */ {kDL_ISO8583_N  ,  3,kDL_ISO8583_FIXED  }, // Country Code, Acquiring Inst
    /*  20 */ {kDL_ISO8583_N  ,  3,kDL_ISO8583_FIXED  }, // Country Code, Primary Account Number
    /*  21 */ {kDL_ISO8583_N  ,  3,kDL_ISO8583_FIXED  }, // Country Code, Forwarding Inst
    /*  22 */ {kDL_ISO8583_N  ,  3,kDL_ISO8583_FIXED  }, // Point of Service Entry Mode
    /*  23 */ {kDL_ISO8583_N  ,  3,kDL_ISO8583_FIXED  }, // Application PAN number
    /*  24 */ {kDL_ISO8583_N  ,  3,kDL_ISO8583_FIXED  }, // Network International Identifier
    /*  25 */ {kDL_ISO8583_N  ,  2,kDL_ISO8583_FIXED  }, // Point of Service Condition Code
    /*  26 */ {kDL_ISO8583_N  ,  2,kDL_ISO8583_FIXED  }, // Point of Service PIN Capture Code
    /*  27 */ {kDL_ISO8583_N  ,  1,kDL_ISO8583_FIXED  }, // Authorization Identification Response Length
    /*  28 */ {kDL_ISO8583_XN ,  9,kDL_ISO8583_FIXED  }, // Amount, Txn Fee
    /*  29 */ {kDL_ISO8583_XN ,  9,kDL_ISO8583_FIXED  }, // Amount, Settlement Fee
    /*  30 */ {kDL_ISO8583_XN ,  9,kDL_ISO8583_FIXED  }, // Amount, Txn Processing Fee
    /*  31 */ {kDL_ISO8583_XN ,  9,kDL_ISO8583_FIXED  }, // Amount, Settlement Processing Fee
    /*  32 */ {kDL_ISO8583_N  , 11,kDL_ISO8583_LLVAR  }, // Acquirer Inst Id Code
    /*  33 */ {kDL_ISO8583_N  , 11,kDL_ISO8583_LLVAR  }, // Forwarding Inst Id Code
    /*  34 */ {kDL_ISO8583_NS , 28,kDL_ISO8583_LLVAR  }, // Primary Account Number, Extended
    /*  35 */ {kDL_ISO8583_Z  , 37,kDL_ISO8583_LLVAR  }, // Track 2 Data
    /*  36 */ {kDL_ISO8583_AN ,104,kDL_ISO8583_LLLVAR }, // Track 3 Data
    /*  37 */ {kDL_ISO8583_AN , 12,kDL_ISO8583_FIXED  }, // Retrieval Reference Number
    /*  38 */ {kDL_ISO8583_AN ,  6,kDL_ISO8583_FIXED  }, // Approval Code
    /*  39 */ {kDL_ISO8583_AN ,  2,kDL_ISO8583_FIXED  }, // Response Code
    /*  40 */ {kDL_ISO8583_ANS,  3,kDL_ISO8583_FIXED  }, // Service Restriction Code
    /*  41 */ {kDL_ISO8583_ANS,  8,kDL_ISO8583_FIXED  }, // Card Acceptor Terminal Id
    /*  42 */ {kDL_ISO8583_ANS, 15,kDL_ISO8583_FIXED  }, // Card Acceptor Id Code
    /*  43 */ {kDL_ISO8583_ANS, 40,kDL_ISO8583_FIXED  }, // Card Acceptor Name/Location
    /*  44 */ {kDL_ISO8583_ANS, 25,kDL_ISO8583_LLVAR  }, // Additional Response Data
    /*  45 */ {kDL_ISO8583_ANS, 76,kDL_ISO8583_LLVAR  }, // Track 1 Data
    /*  46 */ {kDL_ISO8583_ANS,999,kDL_ISO8583_LLLVAR }, // Additional Data - ISO
    /*  47 */ {kDL_ISO8583_ANS,128,kDL_ISO8583_LLLVAR }, // Additional Data - National
    /*  48 */ {kDL_ISO8583_N  , 62,kDL_ISO8583_LLLVAR }, // Additional Data - Private
    /*  49 */ {kDL_ISO8583_ANS,  3,kDL_ISO8583_FIXED  }, // Currency Code, Txn
    /*  50 */ {kDL_ISO8583_AN ,  3,kDL_ISO8583_FIXED  }, // Currency Code, Settlement
    /*  51 */ {kDL_ISO8583_AN ,  3,kDL_ISO8583_FIXED  }, // Currency Code, Cardholder Billing
    /*  52 */ {kDL_ISO8583_B  ,  8,kDL_ISO8583_FIXED  }, // Personal Id Number (PIN) Data
    /*  53 */ {kDL_ISO8583_N  , 16,kDL_ISO8583_FIXED  }, // Security Related Control Information
    /*  54 */ {kDL_ISO8583_ANS, 20,kDL_ISO8583_LLLVAR }, // Amounts, Additional
    /*  55 */ {kDL_ISO8583_B  ,255,kDL_ISO8583_LLLVAR }, // IC card data
    /*  56 */ {kDL_ISO8583_ANS,999,kDL_ISO8583_LLLVAR }, // Reserved for ISO use
    /*  57 */ {kDL_ISO8583_ANS,999,kDL_ISO8583_LLLVAR }, // Reserved for National use
    /*  58 */ {kDL_ISO8583_ANS,999,kDL_ISO8583_LLLVAR }, // Reserved for National use
    /*  59 */ {kDL_ISO8583_ANS,999,kDL_ISO8583_LLLVAR }, // Reserved for National use
    /*  60 */ {kDL_ISO8583_N,   20,kDL_ISO8583_LLLVAR }, // Reserved for Private use
    /*  61 */ {kDL_ISO8583_N,   29,kDL_ISO8583_LLLVAR }, // Reserved for Private use
    /*  62 */ {kDL_ISO8583_ANSB,400,kDL_ISO8583_LLLVAR }, // Reserved for Private use
    /*  63 */ {kDL_ISO8583_ANS, 99,kDL_ISO8583_LLLVAR }, // Reserved for Private use
    /*  64 */ {kDL_ISO8583_B  ,  8,kDL_ISO8583_FIXED  }, // Message Authentication Code Field
};

/******************************************************************************/

void DL_ISO8583_DEFS_POS_GetHandler ( DL_ISO8583_HANDLER *oHandler )
{
    DL_ISO8583_COMMON_SetHandler(_iso8583_pos_fields,
                                 (DL_UINT8)(sizeof(_iso8583_pos_fields)/sizeof(DL_ISO8583_FIELD_DEF)),
                                 oHandler);
    
    return;
}

/******************************************************************************/
