{                                                                              }
{ Name:             ISO 8859-5:1999 to Unicode                                 }
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
{       ISO/IEC 8859-5:1999 characters map into Unicode.                       }
{                                                                              }
{ Format:  Three tab-separated columns                                         }
{    Column #1 is the ISO/IEC 8859-5 code (in hex as 0xXX)                      }
{    Column #2 is the Unicode (in hex as 0xXXXX)                                }
{    Column #3 the Unicode name (follows a comment sign, '#')                   }
{                                                                              }
{ The entries are in ISO/IEC 8859-5 order.                                     }
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
i8859_5toUTF32: tchararray = (
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
{A1} $0401,{ #  CYRILLIC CAPITAL LETTER IO                                     }
{A2} $0402,{ #  CYRILLIC CAPITAL LETTER DJE                                    }
{A3} $0403,{ #  CYRILLIC CAPITAL LETTER GJE                                    }
{A4} $0404,{ #  CYRILLIC CAPITAL LETTER UKRAINIAN IE                           }
{A5} $0405,{ #  CYRILLIC CAPITAL LETTER DZE                                    }
{A6} $0406,{ #  CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I               }
{A7} $0407,{ #  CYRILLIC CAPITAL LETTER YI                                     }
{A8} $0408,{ #  CYRILLIC CAPITAL LETTER JE                                     }
{A9} $0409,{ #  CYRILLIC CAPITAL LETTER LJE                                    }
{AA} $040A,{ #  CYRILLIC CAPITAL LETTER NJE                                    }
{AB} $040B,{ #  CYRILLIC CAPITAL LETTER TSHE                                   }
{AC} $040C,{ #  CYRILLIC CAPITAL LETTER KJE                                    }
{AD} $00AD,{ #  SOFT HYPHEN                                                    }
{AE} $040E,{ #  CYRILLIC CAPITAL LETTER SHORT U                                }
{AF} $040F,{ #  CYRILLIC CAPITAL LETTER DZHE                                   }
{B0} $0410,{ #  CYRILLIC CAPITAL LETTER A                                      }
{B1} $0411,{ #  CYRILLIC CAPITAL LETTER BE                                     }
{B2} $0412,{ #  CYRILLIC CAPITAL LETTER VE                                     }
{B3} $0413,{ #  CYRILLIC CAPITAL LETTER GHE                                    }
{B4} $0414,{ #  CYRILLIC CAPITAL LETTER DE                                     }
{B5} $0415,{ #  CYRILLIC CAPITAL LETTER IE                                     }
{B6} $0416,{ #  CYRILLIC CAPITAL LETTER ZHE                                    }
{B7} $0417,{ #  CYRILLIC CAPITAL LETTER ZE                                     }
{B8} $0418,{ #  CYRILLIC CAPITAL LETTER I                                      }
{B9} $0419,{ #  CYRILLIC CAPITAL LETTER SHORT I                                }
{BA} $041A,{ #  CYRILLIC CAPITAL LETTER KA                                     }
{BB} $041B,{ #  CYRILLIC CAPITAL LETTER EL                                     }
{BC} $041C,{ #  CYRILLIC CAPITAL LETTER EM                                     }
{BD} $041D,{ #  CYRILLIC CAPITAL LETTER EN                                     }
{BE} $041E,{ #  CYRILLIC CAPITAL LETTER O                                      }
{BF} $041F,{ #  CYRILLIC CAPITAL LETTER PE                                     }
{C0} $0420,{ #  CYRILLIC CAPITAL LETTER ER                                     }
{C1} $0421,{ #  CYRILLIC CAPITAL LETTER ES                                     }
{C2} $0422,{ #  CYRILLIC CAPITAL LETTER TE                                     }
{C3} $0423,{ #  CYRILLIC CAPITAL LETTER U                                      }
{C4} $0424,{ #  CYRILLIC CAPITAL LETTER EF                                     }
{C5} $0425,{ #  CYRILLIC CAPITAL LETTER HA                                     }
{C6} $0426,{ #  CYRILLIC CAPITAL LETTER TSE                                    }
{C7} $0427,{ #  CYRILLIC CAPITAL LETTER CHE                                    }
{C8} $0428,{ #  CYRILLIC CAPITAL LETTER SHA                                    }
{C9} $0429,{ #  CYRILLIC CAPITAL LETTER SHCHA                                  }
{CA} $042A,{ #  CYRILLIC CAPITAL LETTER HARD SIGN                              }
{CB} $042B,{ #  CYRILLIC CAPITAL LETTER YERU                                   }
{CC} $042C,{ #  CYRILLIC CAPITAL LETTER SOFT SIGN                              }
{CD} $042D,{ #  CYRILLIC CAPITAL LETTER E                                      }
{CE} $042E,{ #  CYRILLIC CAPITAL LETTER YU                                     }
{CF} $042F,{ #  CYRILLIC CAPITAL LETTER YA                                     }
{D0} $0430,{ #  CYRILLIC SMALL LETTER A                                        }
{D1} $0431,{ #  CYRILLIC SMALL LETTER BE                                       }
{D2} $0432,{ #  CYRILLIC SMALL LETTER VE                                       }
{D3} $0433,{ #  CYRILLIC SMALL LETTER GHE                                      }
{D4} $0434,{ #  CYRILLIC SMALL LETTER DE                                       }
{D5} $0435,{ #  CYRILLIC SMALL LETTER IE                                       }
{D6} $0436,{ #  CYRILLIC SMALL LETTER ZHE                                      }
{D7} $0437,{ #  CYRILLIC SMALL LETTER ZE                                       }
{D8} $0438,{ #  CYRILLIC SMALL LETTER I                                        }
{D9} $0439,{ #  CYRILLIC SMALL LETTER SHORT I                                  }
{DA} $043A,{ #  CYRILLIC SMALL LETTER KA                                       }
{DB} $043B,{ #  CYRILLIC SMALL LETTER EL                                       }
{DC} $043C,{ #  CYRILLIC SMALL LETTER EM                                       }
{DD} $043D,{ #  CYRILLIC SMALL LETTER EN                                       }
{DE} $043E,{ #  CYRILLIC SMALL LETTER O                                        }
{DF} $043F,{ #  CYRILLIC SMALL LETTER PE                                       }
{E0} $0440,{ #  CYRILLIC SMALL LETTER ER                                       }
{E1} $0441,{ #  CYRILLIC SMALL LETTER ES                                       }
{E2} $0442,{ #  CYRILLIC SMALL LETTER TE                                       }
{E3} $0443,{ #  CYRILLIC SMALL LETTER U                                        }
{E4} $0444,{ #  CYRILLIC SMALL LETTER EF                                       }
{E5} $0445,{ #  CYRILLIC SMALL LETTER HA                                       }
{E6} $0446,{ #  CYRILLIC SMALL LETTER TSE                                      }
{E7} $0447,{ #  CYRILLIC SMALL LETTER CHE                                      }
{E8} $0448,{ #  CYRILLIC SMALL LETTER SHA                                      }
{E9} $0449,{ #  CYRILLIC SMALL LETTER SHCHA                                    }
{EA} $044A,{ #  CYRILLIC SMALL LETTER HARD SIGN                                }
{EB} $044B,{ #  CYRILLIC SMALL LETTER YERU                                     }
{EC} $044C,{ #  CYRILLIC SMALL LETTER SOFT SIGN                                }
{ED} $044D,{ #  CYRILLIC SMALL LETTER E                                        }
{EE} $044E,{ #  CYRILLIC SMALL LETTER YU                                       }
{EF} $044F,{ #  CYRILLIC SMALL LETTER YA                                       }
{F0} $2116,{ #  NUMERO SIGN                                                    }
{F1} $0451,{ #  CYRILLIC SMALL LETTER IO                                       }
{F2} $0452,{ #  CYRILLIC SMALL LETTER DJE                                      }
{F3} $0453,{ #  CYRILLIC SMALL LETTER GJE                                      }
{F4} $0454,{ #  CYRILLIC SMALL LETTER UKRAINIAN IE                             }
{F5} $0455,{ #  CYRILLIC SMALL LETTER DZE                                      }
{F6} $0456,{ #  CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I                 }
{F7} $0457,{ #  CYRILLIC SMALL LETTER YI                                       }
{F8} $0458,{ #  CYRILLIC SMALL LETTER JE                                       }
{F9} $0459,{ #  CYRILLIC SMALL LETTER LJE                                      }
{FA} $045A,{ #  CYRILLIC SMALL LETTER NJE                                      }
{FB} $045B,{ #  CYRILLIC SMALL LETTER TSHE                                     }
{FC} $045C,{ #  CYRILLIC SMALL LETTER KJE                                      }
{FD} $00A7,{ #  SECTION SIGN                                                   }
{FE} $045E,{ #  CYRILLIC SMALL LETTER SHORT U                                  }
{FF} $045F { #  CYRILLIC SMALL LETTER DZHE                                     }
);