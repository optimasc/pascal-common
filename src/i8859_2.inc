{                                                                              }
{ Name:             ISO 8859-2:1999 to Unicode                                 }
{ Unicode version:  3.0                                                        }
{ Table version:    1.0                                                        }
{ Table format:     Format A                                                   }
{ Date:             1999 July 27                                               }
{ Authors:          Ken Whistler <kenw@sybase.com>                             }
{                                                                              }
{ Copyright (c) 1991-1999 Unicode, Inc.  All Rights reserved.                  }
{                                                                              }
{ This file is provided as-is by Unicode, Inc. (The Unicode Consortium).       }
{ No claims are made as to fitness for any particular purpose.  No             }
{ warranties of any kind are expressed or implied.  The recipient              }
{ agrees to determine applicability of information provided.  If this          }
{ file has been provided on optical media by Unicode, Inc., the sole           }
{ remedy for any claim will be exchange of defective media within 90           }
{ days of receipt.                                                             }
{                                                                              }
{ Unicode, Inc. hereby grants the right to freely use the information          }
{ supplied in this file in the creation of products supporting the             }
{ Unicode Standard, and to make copies of this file in any form for            }
{ internal or external distribution as long as this notice remains             }
{ attached.                                                                    }
{                                                                              }
{ General notes:                                                               }
{                                                                              }
{ This table contains the data the Unicode Consortium has on how               }
{       ISO/IEC 8859-2:1999 characters map into Unicode.                       }
{                                                                              }
{ Format:  Three tab-separated columns                                         }
{    Column #1 is the ISO/IEC 8859-2 code (in hex as 0xXX)                      }
{    Column #2 is the Unicode (in hex as 0xXXXX)                                }
{    Column #3 the Unicode name (follows a comment sign, '#')                   }
{                                                                              }
{ The entries are in ISO/IEC 8859-2 order.                                     }
{                                                                              }
{ Version history                                                              }
{ 1.0 version updates 0.1 version by adding mappings for all                   }
{ control characters.                                                          }
{                                                                              }
{ Updated versions of this file may be found in:                               }
{   <ftp://ftp.unicode.org/Public/MAPPINGS/>                                    }
{                                                                              }
{ Any comments or problems, contact <errata@unicode.org>                       }
{ Please note that <errata@unicode.org> is an archival address;                }
{ notices will be checked, but do not expect an immediate response.            }
{                                                                              }
i8859_2toUTF32: tchararray = (
{00} $0000,{ #  NULL                                                           }
{01} $0001,{ #  START OF HEADING                                               }
{02} $0002,{ #  START OF TEXT                                                  }
{03} $0003,{ #  END OF TEXT                                                    }
{04} $0004,{ #  END OF TRANSMISSION                                            }
{05} $0005,{ #  ENQUIRY                                                        }
{06} $0006,{ #  ACKNOWLEDGE                                                    }
{07} $0007,{ #  BELL                                                           }
{08} $0008,{ #  BACKSPACE                                                      }
{09} $0009,{ #  HORIZONTAL TABULATION                                          }
{0A} $000A,{ #  LINE FEED                                                      }
{0B} $000B,{ #  VERTICAL TABULATION                                            }
{0C} $000C,{ #  FORM FEED                                                      }
{0D} $000D,{ #  CARRIAGE RETURN                                                }
{0E} $000E,{ #  SHIFT OUT                                                      }
{0F} $000F,{ #  SHIFT IN                                                       }
{10} $0010,{ #  DATA LINK ESCAPE                                               }
{11} $0011,{ #  DEVICE CONTROL ONE                                             }
{12} $0012,{ #  DEVICE CONTROL TWO                                             }
{13} $0013,{ #  DEVICE CONTROL THREE                                           }
{14} $0014,{ #  DEVICE CONTROL FOUR                                            }
{15} $0015,{ #  NEGATIVE ACKNOWLEDGE                                           }
{16} $0016,{ #  SYNCHRONOUS IDLE                                               }
{17} $0017,{ #  END OF TRANSMISSION BLOCK                                      }
{18} $0018,{ #  CANCEL                                                         }
{19} $0019,{ #  END OF MEDIUM                                                  }
{1A} $001A,{ #  SUBSTITUTE                                                     }
{1B} $001B,{ #  ESCAPE                                                         }
{1C} $001C,{ #  FILE SEPARATOR                                                 }
{1D} $001D,{ #  GROUP SEPARATOR                                                }
{1E} $001E,{ #  RECORD SEPARATOR                                               }
{1F} $001F,{ #  UNIT SEPARATOR                                                 }
{20} $0020,{ #  SPACE                                                          }
{21} $0021,{ #  EXCLAMATION MARK                                               }
{22} $0022,{ #  QUOTATION MARK                                                 }
{23} $0023,{ #  NUMBER SIGN                                                    }
{24} $0024,{ #  DOLLAR SIGN                                                    }
{25} $0025,{ #  PERCENT SIGN                                                   }
{26} $0026,{ #  AMPERSAND                                                      }
{27} $0027,{ #  APOSTROPHE                                                     }
{28} $0028,{ #  LEFT PARENTHESIS                                               }
{29} $0029,{ #  RIGHT PARENTHESIS                                              }
{2A} $002A,{ #  ASTERISK                                                       }
{2B} $002B,{ #  PLUS SIGN                                                      }
{2C} $002C,{ #  COMMA                                                          }
{2D} $002D,{ #  HYPHEN-MINUS                                                   }
{2E} $002E,{ #  FULL STOP                                                      }
{2F} $002F,{ #  SOLIDUS                                                        }
{30} $0030,{ #  DIGIT ZERO                                                     }
{31} $0031,{ #  DIGIT ONE                                                      }
{32} $0032,{ #  DIGIT TWO                                                      }
{33} $0033,{ #  DIGIT THREE                                                    }
{34} $0034,{ #  DIGIT FOUR                                                     }
{35} $0035,{ #  DIGIT FIVE                                                     }
{36} $0036,{ #  DIGIT SIX                                                      }
{37} $0037,{ #  DIGIT SEVEN                                                    }
{38} $0038,{ #  DIGIT EIGHT                                                    }
{39} $0039,{ #  DIGIT NINE                                                     }
{3A} $003A,{ #  COLON                                                          }
{3B} $003B,{ #  SEMICOLON                                                      }
{3C} $003C,{ #  LESS-THAN SIGN                                                 }
{3D} $003D,{ #  EQUALS SIGN                                                    }
{3E} $003E,{ #  GREATER-THAN SIGN                                              }
{3F} $003F,{ #  QUESTION MARK                                                  }
{40} $0040,{ #  COMMERCIAL AT                                                  }
{41} $0041,{ #  LATIN CAPITAL LETTER A                                         }
{42} $0042,{ #  LATIN CAPITAL LETTER B                                         }
{43} $0043,{ #  LATIN CAPITAL LETTER C                                         }
{44} $0044,{ #  LATIN CAPITAL LETTER D                                         }
{45} $0045,{ #  LATIN CAPITAL LETTER E                                         }
{46} $0046,{ #  LATIN CAPITAL LETTER F                                         }
{47} $0047,{ #  LATIN CAPITAL LETTER G                                         }
{48} $0048,{ #  LATIN CAPITAL LETTER H                                         }
{49} $0049,{ #  LATIN CAPITAL LETTER I                                         }
{4A} $004A,{ #  LATIN CAPITAL LETTER J                                         }
{4B} $004B,{ #  LATIN CAPITAL LETTER K                                         }
{4C} $004C,{ #  LATIN CAPITAL LETTER L                                         }
{4D} $004D,{ #  LATIN CAPITAL LETTER M                                         }
{4E} $004E,{ #  LATIN CAPITAL LETTER N                                         }
{4F} $004F,{ #  LATIN CAPITAL LETTER O                                         }
{50} $0050,{ #  LATIN CAPITAL LETTER P                                         }
{51} $0051,{ #  LATIN CAPITAL LETTER Q                                         }
{52} $0052,{ #  LATIN CAPITAL LETTER R                                         }
{53} $0053,{ #  LATIN CAPITAL LETTER S                                         }
{54} $0054,{ #  LATIN CAPITAL LETTER T                                         }
{55} $0055,{ #  LATIN CAPITAL LETTER U                                         }
{56} $0056,{ #  LATIN CAPITAL LETTER V                                         }
{57} $0057,{ #  LATIN CAPITAL LETTER W                                         }
{58} $0058,{ #  LATIN CAPITAL LETTER X                                         }
{59} $0059,{ #  LATIN CAPITAL LETTER Y                                         }
{5A} $005A,{ #  LATIN CAPITAL LETTER Z                                         }
{5B} $005B,{ #  LEFT SQUARE BRACKET                                            }
{5C} $005C,{ #  REVERSE SOLIDUS                                                }
{5D} $005D,{ #  RIGHT SQUARE BRACKET                                           }
{5E} $005E,{ #  CIRCUMFLEX ACCENT                                              }
{5F} $005F,{ #  LOW LINE                                                       }
{60} $0060,{ #  GRAVE ACCENT                                                   }
{61} $0061,{ #  LATIN SMALL LETTER A                                           }
{62} $0062,{ #  LATIN SMALL LETTER B                                           }
{63} $0063,{ #  LATIN SMALL LETTER C                                           }
{64} $0064,{ #  LATIN SMALL LETTER D                                           }
{65} $0065,{ #  LATIN SMALL LETTER E                                           }
{66} $0066,{ #  LATIN SMALL LETTER F                                           }
{67} $0067,{ #  LATIN SMALL LETTER G                                           }
{68} $0068,{ #  LATIN SMALL LETTER H                                           }
{69} $0069,{ #  LATIN SMALL LETTER I                                           }
{6A} $006A,{ #  LATIN SMALL LETTER J                                           }
{6B} $006B,{ #  LATIN SMALL LETTER K                                           }
{6C} $006C,{ #  LATIN SMALL LETTER L                                           }
{6D} $006D,{ #  LATIN SMALL LETTER M                                           }
{6E} $006E,{ #  LATIN SMALL LETTER N                                           }
{6F} $006F,{ #  LATIN SMALL LETTER O                                           }
{70} $0070,{ #  LATIN SMALL LETTER P                                           }
{71} $0071,{ #  LATIN SMALL LETTER Q                                           }
{72} $0072,{ #  LATIN SMALL LETTER R                                           }
{73} $0073,{ #  LATIN SMALL LETTER S                                           }
{74} $0074,{ #  LATIN SMALL LETTER T                                           }
{75} $0075,{ #  LATIN SMALL LETTER U                                           }
{76} $0076,{ #  LATIN SMALL LETTER V                                           }
{77} $0077,{ #  LATIN SMALL LETTER W                                           }
{78} $0078,{ #  LATIN SMALL LETTER X                                           }
{79} $0079,{ #  LATIN SMALL LETTER Y                                           }
{7A} $007A,{ #  LATIN SMALL LETTER Z                                           }
{7B} $007B,{ #  LEFT CURLY BRACKET                                             }
{7C} $007C,{ #  VERTICAL LINE                                                  }
{7D} $007D,{ #  RIGHT CURLY BRACKET                                            }
{7E} $007E,{ #  TILDE                                                          }
{7F} $007F,{ #  DELETE                                                         }
{80} $0080,{ #  <control>                                                      }
{81} $0081,{ #  <control>                                                      }
{82} $0082,{ #  <control>                                                      }
{83} $0083,{ #  <control>                                                      }
{84} $0084,{ #  <control>                                                      }
{85} $0085,{ #  <control>                                                      }
{86} $0086,{ #  <control>                                                      }
{87} $0087,{ #  <control>                                                      }
{88} $0088,{ #  <control>                                                      }
{89} $0089,{ #  <control>                                                      }
{8A} $008A,{ #  <control>                                                      }
{8B} $008B,{ #  <control>                                                      }
{8C} $008C,{ #  <control>                                                      }
{8D} $008D,{ #  <control>                                                      }
{8E} $008E,{ #  <control>                                                      }
{8F} $008F,{ #  <control>                                                      }
{90} $0090,{ #  <control>                                                      }
{91} $0091,{ #  <control>                                                      }
{92} $0092,{ #  <control>                                                      }
{93} $0093,{ #  <control>                                                      }
{94} $0094,{ #  <control>                                                      }
{95} $0095,{ #  <control>                                                      }
{96} $0096,{ #  <control>                                                      }
{97} $0097,{ #  <control>                                                      }
{98} $0098,{ #  <control>                                                      }
{99} $0099,{ #  <control>                                                      }
{9A} $009A,{ #  <control>                                                      }
{9B} $009B,{ #  <control>                                                      }
{9C} $009C,{ #  <control>                                                      }
{9D} $009D,{ #  <control>                                                      }
{9E} $009E,{ #  <control>                                                      }
{9F} $009F,{ #  <control>                                                      }
{A0} $00A0,{ #  NO-BREAK SPACE                                                 }
{A1} $0104,{ #  LATIN CAPITAL LETTER A WITH OGONEK                             }
{A2} $02D8,{ #  BREVE                                                          }
{A3} $0141,{ #  LATIN CAPITAL LETTER L WITH STROKE                             }
{A4} $00A4,{ #  CURRENCY SIGN                                                  }
{A5} $013D,{ #  LATIN CAPITAL LETTER L WITH CARON                              }
{A6} $015A,{ #  LATIN CAPITAL LETTER S WITH ACUTE                              }
{A7} $00A7,{ #  SECTION SIGN                                                   }
{A8} $00A8,{ #  DIAERESIS                                                      }
{A9} $0160,{ #  LATIN CAPITAL LETTER S WITH CARON                              }
{AA} $015E,{ #  LATIN CAPITAL LETTER S WITH CEDILLA                            }
{AB} $0164,{ #  LATIN CAPITAL LETTER T WITH CARON                              }
{AC} $0179,{ #  LATIN CAPITAL LETTER Z WITH ACUTE                              }
{AD} $00AD,{ #  SOFT HYPHEN                                                    }
{AE} $017D,{ #  LATIN CAPITAL LETTER Z WITH CARON                              }
{AF} $017B,{ #  LATIN CAPITAL LETTER Z WITH DOT ABOVE                          }
{B0} $00B0,{ #  DEGREE SIGN                                                    }
{B1} $0105,{ #  LATIN SMALL LETTER A WITH OGONEK                               }
{B2} $02DB,{ #  OGONEK                                                         }
{B3} $0142,{ #  LATIN SMALL LETTER L WITH STROKE                               }
{B4} $00B4,{ #  ACUTE ACCENT                                                   }
{B5} $013E,{ #  LATIN SMALL LETTER L WITH CARON                                }
{B6} $015B,{ #  LATIN SMALL LETTER S WITH ACUTE                                }
{B7} $02C7,{ #  CARON                                                          }
{B8} $00B8,{ #  CEDILLA                                                        }
{B9} $0161,{ #  LATIN SMALL LETTER S WITH CARON                                }
{BA} $015F,{ #  LATIN SMALL LETTER S WITH CEDILLA                              }
{BB} $0165,{ #  LATIN SMALL LETTER T WITH CARON                                }
{BC} $017A,{ #  LATIN SMALL LETTER Z WITH ACUTE                                }
{BD} $02DD,{ #  DOUBLE ACUTE ACCENT                                            }
{BE} $017E,{ #  LATIN SMALL LETTER Z WITH CARON                                }
{BF} $017C,{ #  LATIN SMALL LETTER Z WITH DOT ABOVE                            }
{C0} $0154,{ #  LATIN CAPITAL LETTER R WITH ACUTE                              }
{C1} $00C1,{ #  LATIN CAPITAL LETTER A WITH ACUTE                              }
{C2} $00C2,{ #  LATIN CAPITAL LETTER A WITH CIRCUMFLEX                         }
{C3} $0102,{ #  LATIN CAPITAL LETTER A WITH BREVE                              }
{C4} $00C4,{ #  LATIN CAPITAL LETTER A WITH DIAERESIS                          }
{C5} $0139,{ #  LATIN CAPITAL LETTER L WITH ACUTE                              }
{C6} $0106,{ #  LATIN CAPITAL LETTER C WITH ACUTE                              }
{C7} $00C7,{ #  LATIN CAPITAL LETTER C WITH CEDILLA                            }
{C8} $010C,{ #  LATIN CAPITAL LETTER C WITH CARON                              }
{C9} $00C9,{ #  LATIN CAPITAL LETTER E WITH ACUTE                              }
{CA} $0118,{ #  LATIN CAPITAL LETTER E WITH OGONEK                             }
{CB} $00CB,{ #  LATIN CAPITAL LETTER E WITH DIAERESIS                          }
{CC} $011A,{ #  LATIN CAPITAL LETTER E WITH CARON                              }
{CD} $00CD,{ #  LATIN CAPITAL LETTER I WITH ACUTE                              }
{CE} $00CE,{ #  LATIN CAPITAL LETTER I WITH CIRCUMFLEX                         }
{CF} $010E,{ #  LATIN CAPITAL LETTER D WITH CARON                              }
{D0} $0110,{ #  LATIN CAPITAL LETTER D WITH STROKE                             }
{D1} $0143,{ #  LATIN CAPITAL LETTER N WITH ACUTE                              }
{D2} $0147,{ #  LATIN CAPITAL LETTER N WITH CARON                              }
{D3} $00D3,{ #  LATIN CAPITAL LETTER O WITH ACUTE                              }
{D4} $00D4,{ #  LATIN CAPITAL LETTER O WITH CIRCUMFLEX                         }
{D5} $0150,{ #  LATIN CAPITAL LETTER O WITH DOUBLE ACUTE                       }
{D6} $00D6,{ #  LATIN CAPITAL LETTER O WITH DIAERESIS                          }
{D7} $00D7,{ #  MULTIPLICATION SIGN                                            }
{D8} $0158,{ #  LATIN CAPITAL LETTER R WITH CARON                              }
{D9} $016E,{ #  LATIN CAPITAL LETTER U WITH RING ABOVE                         }
{DA} $00DA,{ #  LATIN CAPITAL LETTER U WITH ACUTE                              }
{DB} $0170,{ #  LATIN CAPITAL LETTER U WITH DOUBLE ACUTE                       }
{DC} $00DC,{ #  LATIN CAPITAL LETTER U WITH DIAERESIS                          }
{DD} $00DD,{ #  LATIN CAPITAL LETTER Y WITH ACUTE                              }
{DE} $0162,{ #  LATIN CAPITAL LETTER T WITH CEDILLA                            }
{DF} $00DF,{ #  LATIN SMALL LETTER SHARP S                                     }
{E0} $0155,{ #  LATIN SMALL LETTER R WITH ACUTE                                }
{E1} $00E1,{ #  LATIN SMALL LETTER A WITH ACUTE                                }
{E2} $00E2,{ #  LATIN SMALL LETTER A WITH CIRCUMFLEX                           }
{E3} $0103,{ #  LATIN SMALL LETTER A WITH BREVE                                }
{E4} $00E4,{ #  LATIN SMALL LETTER A WITH DIAERESIS                            }
{E5} $013A,{ #  LATIN SMALL LETTER L WITH ACUTE                                }
{E6} $0107,{ #  LATIN SMALL LETTER C WITH ACUTE                                }
{E7} $00E7,{ #  LATIN SMALL LETTER C WITH CEDILLA                              }
{E8} $010D,{ #  LATIN SMALL LETTER C WITH CARON                                }
{E9} $00E9,{ #  LATIN SMALL LETTER E WITH ACUTE                                }
{EA} $0119,{ #  LATIN SMALL LETTER E WITH OGONEK                               }
{EB} $00EB,{ #  LATIN SMALL LETTER E WITH DIAERESIS                            }
{EC} $011B,{ #  LATIN SMALL LETTER E WITH CARON                                }
{ED} $00ED,{ #  LATIN SMALL LETTER I WITH ACUTE                                }
{EE} $00EE,{ #  LATIN SMALL LETTER I WITH CIRCUMFLEX                           }
{EF} $010F,{ #  LATIN SMALL LETTER D WITH CARON                                }
{F0} $0111,{ #  LATIN SMALL LETTER D WITH STROKE                               }
{F1} $0144,{ #  LATIN SMALL LETTER N WITH ACUTE                                }
{F2} $0148,{ #  LATIN SMALL LETTER N WITH CARON                                }
{F3} $00F3,{ #  LATIN SMALL LETTER O WITH ACUTE                                }
{F4} $00F4,{ #  LATIN SMALL LETTER O WITH CIRCUMFLEX                           }
{F5} $0151,{ #  LATIN SMALL LETTER O WITH DOUBLE ACUTE                         }
{F6} $00F6,{ #  LATIN SMALL LETTER O WITH DIAERESIS                            }
{F7} $00F7,{ #  DIVISION SIGN                                                  }
{F8} $0159,{ #  LATIN SMALL LETTER R WITH CARON                                }
{F9} $016F,{ #  LATIN SMALL LETTER U WITH RING ABOVE                           }
{FA} $00FA,{ #  LATIN SMALL LETTER U WITH ACUTE                                }
{FB} $0171,{ #  LATIN SMALL LETTER U WITH DOUBLE ACUTE                         }
{FC} $00FC,{ #  LATIN SMALL LETTER U WITH DIAERESIS                            }
{FD} $00FD,{ #  LATIN SMALL LETTER Y WITH ACUTE                                }
{FE} $0163,{ #  LATIN SMALL LETTER T WITH CEDILLA                              }
{FF} $02D9 { #  DOT ABOVE                                                      }
);