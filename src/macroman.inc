{=======================================================================       }
{   File name:  ROMAN.TXT                                                      }
{                                                                              }
{   Contents:   Map (external version) from Mac OS Roman                       }
{               character set to Unicode 2.1 through Unicode 3.2               }
{                                                                              }
{   Copyright:  (c) 1994-2002 by Apple Computer, Inc., all rights              }
{               reserved.                                                      }
{                                                                              }
{   Contact:    charsets@apple.com                                             }
{                                                                              }
{   Changes:                                                                   }
{                                                                              }
{      b4,c1 2002-Dec-19    Update URLs, notes. Matches internal               }
{                           utom<b5>.                                          }
{       b03  1999-Sep-22    Update contact e-mail address. Matches             }
{                           internal utom<b4>, ufrm<b3>, and Text              }
{                           Encoding Converter version 1.5.                    }
{       b02  1998-Aug-18    Encoding changed for Mac OS 8.5; change            }
{                           mapping of 0xDB from CURRENCY SIGN to              }
{                           EURO SIGN. Matches internal utom<b3>,              }
{                           ufrm<b3>.                                          }
{       n08  1998-Feb-05    Minor update to header comments                    }
{       n06  1997-Dec-14    Add warning about future changes to 0xDB           }
{                           from CURRENCY SIGN to EURO SIGN. Clarify           }
{                           some header information                            }
{       n04  1997-Dec-01    Update to match internal utom<n3>, ufrm<n22>:      }
{                           Change standard mapping for 0xBD from U+2126       }
{                           to its canonical decomposition, U+03A9.            }
{       n03  1995-Apr-15    First version (after fixing some typos).           }
{                           Matches internal ufrm<n9>.                         }
{                                                                              }
{ Standard header:                                                             }
{ ----------------                                                             }
{                                                                              }
{   Apple, the Apple logo, and Macintosh are trademarks of Apple               }
{   Computer, Inc., registered in the United States and other countries.       }
{   Unicode is a trademark of Unicode Inc. For the sake of brevity,            }
{   throughout this document, "Macintosh" can be used to refer to              }
{   Macintosh computers and "Unicode" can be used to refer to the              }
{   Unicode standard.                                                          }
{                                                                              }
{   Apple makes no warranty or representation, either express or               }
{   implied, with respect to these tables, their quality, accuracy, or         }
{   fitness for a particular purpose. In no event will Apple be liable         }
{   for direct, indirect, special, incidental, or consequential damages        }
{   resulting from any defect or inaccuracy in this document or the            }
{   accompanying tables.                                                       }
{                                                                              }
{   These mapping tables and character lists are subject to change.            }
{   The latest tables should be available from the following:                  }
{                                                                              }
{   <http://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/>                    }
{                                                                              }
{   For general information about Mac OS encodings and these mapping           }
{   tables, see the file "README.TXT".                                         }
{                                                                              }
{ Format:                                                                      }
{ -------                                                                      }
{                                                                              }
{   Three tab-separated columns;                                               }
{   '#' begins a comment which continues to the end of the line.               }
{     Column #1 is the Mac OS Roman code (in hex as 0xNN)                      }
{     Column #2 is the corresponding Unicode (in hex as 0xNNNN)                }
{     Column #3 is a comment containing the Unicode name                       }
{                                                                              }
{   The entries are in Mac OS Roman code order.                                }
{                                                                              }
{   One of these mappings requires the use of a corporate character.           }
{   See the file "CORPCHAR.TXT" and notes below.                               }
{                                                                              }
{   Control character mappings are not shown in this table, following          }
{   the conventions of the standard UTC mapping tables. However, the           }
{   Mac OS Roman character set uses the standard control characters at         }
{   0x00-0x1F and 0x7F.                                                        }
{                                                                              }
{ Notes on Mac OS Roman:                                                       }
{ ----------------------                                                       }
{                                                                              }
{   This character set is used for at least the following Mac OS               }
{   localizations: U.S., British, Canadian French, French, Swiss               }
{   French, German, Swiss German, Italian, Swiss Italian, Dutch,               }
{   Swedish, Norwegian, Danish, Finnish, Spanish, Catalan,                     }
{   Portuguese, Brazilian, and the default International system.               }
{                                                                              }
{   Variants of Mac OS Roman are used for Croatian, Icelandic,                 }
{   Turkish, Romanian, and other encodings. Separate mapping tables            }
{   are available for these encodings.                                         }
{                                                                              }
{   Before Mac OS 8.5, code point 0xDB was CURRENCY SIGN, and was              }
{   mapped to U+00A4. In Mac OS 8.5 and later versions, code point             }
{   0xDB is changed to EURO SIGN and maps to U+20AC; the standard              }
{   Apple fonts are updated for Mac OS 8.5 to reflect this. There is           }
{   a "currency sign" variant of the Mac OS Roman encoding that still          }
{   maps 0xDB to U+00A4; this can be used for older fonts.                     }
{                                                                              }
{   Before Mac OS 8.5, the ROM bitmap versions of the fonts Chicago,           }
{   New York, Geneva, and Monaco did not implement the full Mac OS             }
{   Roman character set; they only supported character codes up to             }
{   0xD8. The TrueType versions of these fonts have always implemented         }
{   the full character set, as with the bitmap and TrueType versions           }
{   of the other standard Roman fonts.                                         }
{                                                                              }
{   In all Mac OS encodings, fonts such as Chicago which are used              }
{   as "system" fonts (for menus, dialogs, etc.) have four glyphs              }
{   at code points 0x11-0x14 for transient use by the Menu Manager.            }
{   These glyphs are not intended as characters for use in normal              }
{   text, and the associated code points are not generally                     }
{   interpreted as associated with these glyphs; they are usually              }
{   interpreted (if at all) as the control codes DC1-DC4.                      }
{                                                                              }
{ Unicode mapping issues and notes:                                            }
{ ---------------------------------                                            }
{                                                                              }
{   The following corporate zone Unicode character is used in this             }
{   mapping:                                                                   }
{                                                                              }
{     0xF8FF  Apple logo                                                       }
{                                                                              }
{   NOTE: The graphic image associated with the Apple logo character           }
{   is not authorized for use without permission of Apple, and                 }
{   unauthorized use might constitute trademark infringement.                  }
{                                                                              }
{ Details of mapping changes in each version:                                  }
{ -------------------------------------------                                  }
{                                                                              }
{   Changes from version n08 to version b02:                                   }
{                                                                              }
{   - Encoding changed for Mac OS 8.5; change mapping of 0xDB from             }
{   CURRENCY SIGN (U+00A4) to EURO SIGN (U+20AC).                              }
{                                                                              }
{   Changes from version n03 to version n04:                                   }
{                                                                              }
{   - Change mapping of 0xBD from U+2126 to its canonical                      }
{     decomposition, U+03A9.                                                   }
{                                                                              }
{#################                                                             }
RomantoUTF32: tchararray = (
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
{21} $0021,{ # EXCLAMATION MARK                                               }
{22} $0022,{ # QUOTATION MARK                                                 }
{23} $0023,{ # NUMBER SIGN                                                    }
{24} $0024,{ # DOLLAR SIGN                                                    }
{25} $0025,{ # PERCENT SIGN                                                   }
{26} $0026,{ # AMPERSAND                                                      }
{27} $0027,{ # APOSTROPHE                                                     }
{28} $0028,{ # LEFT PARENTHESIS                                               }
{29} $0029,{ # RIGHT PARENTHESIS                                              }
{2A} $002A,{ # ASTERISK                                                       }
{2B} $002B,{ # PLUS SIGN                                                      }
{2C} $002C,{ # COMMA                                                          }
{2D} $002D,{ # HYPHEN-MINUS                                                   }
{2E} $002E,{ # FULL STOP                                                      }
{2F} $002F,{ # SOLIDUS                                                        }
{30} $0030,{ # DIGIT ZERO                                                     }
{31} $0031,{ # DIGIT ONE                                                      }
{32} $0032,{ # DIGIT TWO                                                      }
{33} $0033,{ # DIGIT THREE                                                    }
{34} $0034,{ # DIGIT FOUR                                                     }
{35} $0035,{ # DIGIT FIVE                                                     }
{36} $0036,{ # DIGIT SIX                                                      }
{37} $0037,{ # DIGIT SEVEN                                                    }
{38} $0038,{ # DIGIT EIGHT                                                    }
{39} $0039,{ # DIGIT NINE                                                     }
{3A} $003A,{ # COLON                                                          }
{3B} $003B,{ # SEMICOLON                                                      }
{3C} $003C,{ # LESS-THAN SIGN                                                 }
{3D} $003D,{ # EQUALS SIGN                                                    }
{3E} $003E,{ # GREATER-THAN SIGN                                              }
{3F} $003F,{ # QUESTION MARK                                                  }
{40} $0040,{ # COMMERCIAL AT                                                  }
{41} $0041,{ # LATIN CAPITAL LETTER A                                         }
{42} $0042,{ # LATIN CAPITAL LETTER B                                         }
{43} $0043,{ # LATIN CAPITAL LETTER C                                         }
{44} $0044,{ # LATIN CAPITAL LETTER D                                         }
{45} $0045,{ # LATIN CAPITAL LETTER E                                         }
{46} $0046,{ # LATIN CAPITAL LETTER F                                         }
{47} $0047,{ # LATIN CAPITAL LETTER G                                         }
{48} $0048,{ # LATIN CAPITAL LETTER H                                         }
{49} $0049,{ # LATIN CAPITAL LETTER I                                         }
{4A} $004A,{ # LATIN CAPITAL LETTER J                                         }
{4B} $004B,{ # LATIN CAPITAL LETTER K                                         }
{4C} $004C,{ # LATIN CAPITAL LETTER L                                         }
{4D} $004D,{ # LATIN CAPITAL LETTER M                                         }
{4E} $004E,{ # LATIN CAPITAL LETTER N                                         }
{4F} $004F,{ # LATIN CAPITAL LETTER O                                         }
{50} $0050,{ # LATIN CAPITAL LETTER P                                         }
{51} $0051,{ # LATIN CAPITAL LETTER Q                                         }
{52} $0052,{ # LATIN CAPITAL LETTER R                                         }
{53} $0053,{ # LATIN CAPITAL LETTER S                                         }
{54} $0054,{ # LATIN CAPITAL LETTER T                                         }
{55} $0055,{ # LATIN CAPITAL LETTER U                                         }
{56} $0056,{ # LATIN CAPITAL LETTER V                                         }
{57} $0057,{ # LATIN CAPITAL LETTER W                                         }
{58} $0058,{ # LATIN CAPITAL LETTER X                                         }
{59} $0059,{ # LATIN CAPITAL LETTER Y                                         }
{5A} $005A,{ # LATIN CAPITAL LETTER Z                                         }
{5B} $005B,{ # LEFT SQUARE BRACKET                                            }
{5C} $005C,{ # REVERSE SOLIDUS                                                }
{5D} $005D,{ # RIGHT SQUARE BRACKET                                           }
{5E} $005E,{ # CIRCUMFLEX ACCENT                                              }
{5F} $005F,{ # LOW LINE                                                       }
{60} $0060,{ # GRAVE ACCENT                                                   }
{61} $0061,{ # LATIN SMALL LETTER A                                           }
{62} $0062,{ # LATIN SMALL LETTER B                                           }
{63} $0063,{ # LATIN SMALL LETTER C                                           }
{64} $0064,{ # LATIN SMALL LETTER D                                           }
{65} $0065,{ # LATIN SMALL LETTER E                                           }
{66} $0066,{ # LATIN SMALL LETTER F                                           }
{67} $0067,{ # LATIN SMALL LETTER G                                           }
{68} $0068,{ # LATIN SMALL LETTER H                                           }
{69} $0069,{ # LATIN SMALL LETTER I                                           }
{6A} $006A,{ # LATIN SMALL LETTER J                                           }
{6B} $006B,{ # LATIN SMALL LETTER K                                           }
{6C} $006C,{ # LATIN SMALL LETTER L                                           }
{6D} $006D,{ # LATIN SMALL LETTER M                                           }
{6E} $006E,{ # LATIN SMALL LETTER N                                           }
{6F} $006F,{ # LATIN SMALL LETTER O                                           }
{70} $0070,{ # LATIN SMALL LETTER P                                           }
{71} $0071,{ # LATIN SMALL LETTER Q                                           }
{72} $0072,{ # LATIN SMALL LETTER R                                           }
{73} $0073,{ # LATIN SMALL LETTER S                                           }
{74} $0074,{ # LATIN SMALL LETTER T                                           }
{75} $0075,{ # LATIN SMALL LETTER U                                           }
{76} $0076,{ # LATIN SMALL LETTER V                                           }
{77} $0077,{ # LATIN SMALL LETTER W                                           }
{78} $0078,{ # LATIN SMALL LETTER X                                           }
{79} $0079,{ # LATIN SMALL LETTER Y                                           }
{7A} $007A,{ # LATIN SMALL LETTER Z                                           }
{7B} $007B,{ # LEFT CURLY BRACKET                                             }
{7C} $007C,{ # VERTICAL LINE                                                  }
{7D} $007D,{ # RIGHT CURLY BRACKET                                            }
{7E} $007E,{ # TILDE                                                          }
{7F} $007F,{ #  DELETE                                                         }
{80} $00C4,{ # LATIN CAPITAL LETTER A WITH DIAERESIS                          }
{81} $00C5,{ # LATIN CAPITAL LETTER A WITH RING ABOVE                         }
{82} $00C7,{ # LATIN CAPITAL LETTER C WITH CEDILLA                            }
{83} $00C9,{ # LATIN CAPITAL LETTER E WITH ACUTE                              }
{84} $00D1,{ # LATIN CAPITAL LETTER N WITH TILDE                              }
{85} $00D6,{ # LATIN CAPITAL LETTER O WITH DIAERESIS                          }
{86} $00DC,{ # LATIN CAPITAL LETTER U WITH DIAERESIS                          }
{87} $00E1,{ # LATIN SMALL LETTER A WITH ACUTE                                }
{88} $00E0,{ # LATIN SMALL LETTER A WITH GRAVE                                }
{89} $00E2,{ # LATIN SMALL LETTER A WITH CIRCUMFLEX                           }
{8A} $00E4,{ # LATIN SMALL LETTER A WITH DIAERESIS                            }
{8B} $00E3,{ # LATIN SMALL LETTER A WITH TILDE                                }
{8C} $00E5,{ # LATIN SMALL LETTER A WITH RING ABOVE                           }
{8D} $00E7,{ # LATIN SMALL LETTER C WITH CEDILLA                              }
{8E} $00E9,{ # LATIN SMALL LETTER E WITH ACUTE                                }
{8F} $00E8,{ # LATIN SMALL LETTER E WITH GRAVE                                }
{90} $00EA,{ # LATIN SMALL LETTER E WITH CIRCUMFLEX                           }
{91} $00EB,{ # LATIN SMALL LETTER E WITH DIAERESIS                            }
{92} $00ED,{ # LATIN SMALL LETTER I WITH ACUTE                                }
{93} $00EC,{ # LATIN SMALL LETTER I WITH GRAVE                                }
{94} $00EE,{ # LATIN SMALL LETTER I WITH CIRCUMFLEX                           }
{95} $00EF,{ # LATIN SMALL LETTER I WITH DIAERESIS                            }
{96} $00F1,{ # LATIN SMALL LETTER N WITH TILDE                                }
{97} $00F3,{ # LATIN SMALL LETTER O WITH ACUTE                                }
{98} $00F2,{ # LATIN SMALL LETTER O WITH GRAVE                                }
{99} $00F4,{ # LATIN SMALL LETTER O WITH CIRCUMFLEX                           }
{9A} $00F6,{ # LATIN SMALL LETTER O WITH DIAERESIS                            }
{9B} $00F5,{ # LATIN SMALL LETTER O WITH TILDE                                }
{9C} $00FA,{ # LATIN SMALL LETTER U WITH ACUTE                                }
{9D} $00F9,{ # LATIN SMALL LETTER U WITH GRAVE                                }
{9E} $00FB,{ # LATIN SMALL LETTER U WITH CIRCUMFLEX                           }
{9F} $00FC,{ # LATIN SMALL LETTER U WITH DIAERESIS                            }
{A0} $2020,{ # DAGGER                                                         }
{A1} $00B0,{ # DEGREE SIGN                                                    }
{A2} $00A2,{ # CENT SIGN                                                      }
{A3} $00A3,{ # POUND SIGN                                                     }
{A4} $00A7,{ # SECTION SIGN                                                   }
{A5} $2022,{ # BULLET                                                         }
{A6} $00B6,{ # PILCROW SIGN                                                   }
{A7} $00DF,{ # LATIN SMALL LETTER SHARP S                                     }
{A8} $00AE,{ # REGISTERED SIGN                                                }
{A9} $00A9,{ # COPYRIGHT SIGN                                                 }
{AA} $2122,{ # TRADE MARK SIGN                                                }
{AB} $00B4,{ # ACUTE ACCENT                                                   }
{AC} $00A8,{ # DIAERESIS                                                      }
{AD} $2260,{ # NOT EQUAL TO                                                   }
{AE} $00C6,{ # LATIN CAPITAL LETTER AE                                        }
{AF} $00D8,{ # LATIN CAPITAL LETTER O WITH STROKE                             }
{B0} $221E,{ # INFINITY                                                       }
{B1} $00B1,{ # PLUS-MINUS SIGN                                                }
{B2} $2264,{ # LESS-THAN OR EQUAL TO                                          }
{B3} $2265,{ # GREATER-THAN OR EQUAL TO                                       }
{B4} $00A5,{ # YEN SIGN                                                       }
{B5} $00B5,{ # MICRO SIGN                                                     }
{B6} $2202,{ # PARTIAL DIFFERENTIAL                                           }
{B7} $2211,{ # N-ARY SUMMATION                                                }
{B8} $220F,{ # N-ARY PRODUCT                                                  }
{B9} $03C0,{ # GREEK SMALL LETTER PI                                          }
{BA} $222B,{ # INTEGRAL                                                       }
{BB} $00AA,{ # FEMININE ORDINAL INDICATOR                                     }
{BC} $00BA,{ # MASCULINE ORDINAL INDICATOR                                    }
{BD} $03A9,{ # GREEK CAPITAL LETTER OMEGA                                     }
{BE} $00E6,{ # LATIN SMALL LETTER AE                                          }
{BF} $00F8,{ # LATIN SMALL LETTER O WITH STROKE                               }
{C0} $00BF,{ # INVERTED QUESTION MARK                                         }
{C1} $00A1,{ # INVERTED EXCLAMATION MARK                                      }
{C2} $00AC,{ # NOT SIGN                                                       }
{C3} $221A,{ # SQUARE ROOT                                                    }
{C4} $0192,{ # LATIN SMALL LETTER F WITH HOOK                                 }
{C5} $2248,{ # ALMOST EQUAL TO                                                }
{C6} $2206,{ # INCREMENT                                                      }
{C7} $00AB,{ # LEFT-POINTING DOUBLE ANGLE QUOTATION MARK                      }
{C8} $00BB,{ # RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK                     }
{C9} $2026,{ # HORIZONTAL ELLIPSIS                                            }
{CA} $00A0,{ # NO-BREAK SPACE                                                 }
{CB} $00C0,{ # LATIN CAPITAL LETTER A WITH GRAVE                              }
{CC} $00C3,{ # LATIN CAPITAL LETTER A WITH TILDE                              }
{CD} $00D5,{ # LATIN CAPITAL LETTER O WITH TILDE                              }
{CE} $0152,{ # LATIN CAPITAL LIGATURE OE                                      }
{CF} $0153,{ # LATIN SMALL LIGATURE OE                                        }
{D0} $2013,{ # EN DASH                                                        }
{D1} $2014,{ # EM DASH                                                        }
{D2} $201C,{ # LEFT DOUBLE QUOTATION MARK                                     }
{D3} $201D,{ # RIGHT DOUBLE QUOTATION MARK                                    }
{D4} $2018,{ # LEFT SINGLE QUOTATION MARK                                     }
{D5} $2019,{ # RIGHT SINGLE QUOTATION MARK                                    }
{D6} $00F7,{ # DIVISION SIGN                                                  }
{D7} $25CA,{ # LOZENGE                                                        }
{D8} $00FF,{ # LATIN SMALL LETTER Y WITH DIAERESIS                            }
{D9} $0178,{ # LATIN CAPITAL LETTER Y WITH DIAERESIS                          }
{DA} $2044,{ # FRACTION SLASH                                                 }
{DB} $20AC,{ # EURO SIGN                                                      }
{DC} $2039,{ # SINGLE LEFT-POINTING ANGLE QUOTATION MARK                      }
{DD} $203A,{ # SINGLE RIGHT-POINTING ANGLE QUOTATION MARK                     }
{DE} $FB01,{ # LATIN SMALL LIGATURE FI                                        }
{DF} $FB02,{ # LATIN SMALL LIGATURE FL                                        }
{E0} $2021,{ # DOUBLE DAGGER                                                  }
{E1} $00B7,{ # MIDDLE DOT                                                     }
{E2} $201A,{ # SINGLE LOW-9 QUOTATION MARK                                    }
{E3} $201E,{ # DOUBLE LOW-9 QUOTATION MARK                                    }
{E4} $2030,{ # PER MILLE SIGN                                                 }
{E5} $00C2,{ # LATIN CAPITAL LETTER A WITH CIRCUMFLEX                         }
{E6} $00CA,{ # LATIN CAPITAL LETTER E WITH CIRCUMFLEX                         }
{E7} $00C1,{ # LATIN CAPITAL LETTER A WITH ACUTE                              }
{E8} $00CB,{ # LATIN CAPITAL LETTER E WITH DIAERESIS                          }
{E9} $00C8,{ # LATIN CAPITAL LETTER E WITH GRAVE                              }
{EA} $00CD,{ # LATIN CAPITAL LETTER I WITH ACUTE                              }
{EB} $00CE,{ # LATIN CAPITAL LETTER I WITH CIRCUMFLEX                         }
{EC} $00CF,{ # LATIN CAPITAL LETTER I WITH DIAERESIS                          }
{ED} $00CC,{ # LATIN CAPITAL LETTER I WITH GRAVE                              }
{EE} $00D3,{ # LATIN CAPITAL LETTER O WITH ACUTE                              }
{EF} $00D4,{ # LATIN CAPITAL LETTER O WITH CIRCUMFLEX                         }
{F0} $F8FF,{ # Apple logo                                                     }
{F1} $00D2,{ # LATIN CAPITAL LETTER O WITH GRAVE                              }
{F2} $00DA,{ # LATIN CAPITAL LETTER U WITH ACUTE                              }
{F3} $00DB,{ # LATIN CAPITAL LETTER U WITH CIRCUMFLEX                         }
{F4} $00D9,{ # LATIN CAPITAL LETTER U WITH GRAVE                              }
{F5} $0131,{ # LATIN SMALL LETTER DOTLESS I                                   }
{F6} $02C6,{ # MODIFIER LETTER CIRCUMFLEX ACCENT                              }
{F7} $02DC,{ # SMALL TILDE                                                    }
{F8} $00AF,{ # MACRON                                                         }
{F9} $02D8,{ # BREVE                                                          }
{FA} $02D9,{ # DOT ABOVE                                                      }
{FB} $02DA,{ # RING ABOVE                                                     }
{FC} $00B8,{ # CEDILLA                                                        }
{FD} $02DD,{ # DOUBLE ACUTE ACCENT                                            }
{FE} $02DB,{ # OGONEK                                                         }
{FF} $02C7 { # CARON                                                          }
);
