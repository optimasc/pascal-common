{                                                                              }
{ Name:     AtariST  to Unicode                                                  }
{ Unicode version:  4.0                                                         }
{ Table version:  1.0                                                           }
{ Table format:   Format A                                                      }
{ Date:     2003 November 13                                                     }
{ Authors:    Philippe Verdy <verdy_p@hotmail.com>                               }
{                                                                              }
{ Copyright (c) 1998 - 2003 Unicode, Inc.  All Rights reserved.                }
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
{ AtariST characters map into Unicode.                                         }
{                                                                              }
{ Format: Three tab-separated columns                                          }
{   Column 1 is the AtariST code (in hex as 0xXX)                               }
{   Column 2 is the Unicode (in hex as 0xXXXX)                                  }
{   Column 3 the Unicode name (follows a comment sign, '#')                     }
{   Column 4 is the actual character or <symbol> (follows a comment sign, '#')  }
{   Column 5 indicates backward compatible character set mappings               }
{                                                                              }
{ The entries are in AtariST order.                                            }
{                                                                              }
{ Version history                                                              }
{ 1.0 version new.                                                             }
{                                                                              }
{ Updated versions of this file may be found in:                               }
{   <ftp://ftp.unicode.org/Public/MAPPINGS/>                                    }
{                                                                              }
{ Any comments or problems, contact http://www.unicode.org/reporting.html      }
{                                                                              }
ataristtoUTF32: tchararray = (
{00} $0000,{ # NULL           # <NUL> ISO646                                       }
{01} $0001,{ # START OF HEADING       # <SOH> ISO646                             }
{02} $0002,{ # START OF TEXT          # <STX> ISO646                               }
{03} $0003,{ # END OF TEXT          # <ETX> ISO646                                 }
{04} $0004,{ # END OF TRANSMISSION        # <EOT> ISO646                          }
{05} $0005,{ # ENQUIRY          # <ENQ> ISO646                                     }
{06} $0006,{ # ACKNOWLEDGE          # <ACK> ISO646                                 }
{07} $0007,{ # BELL           # <BEL> ISO646                                       }
{08} $0008,{ # BACKSPACE          # <BS>  ISO646                                    }
{09} $0009,{ # HORIZONTAL TABULATION        # <TAB> ISO646                        }
{0A} $000A,{ # LINE FEED          # <LF>  ISO646                                    }
{0B} $000B,{ # VERTICAL TABULATION        # <VT>  ISO646                           }
{0C} $000C,{ # FORM FEED          # <FF>  ISO646                                    }
{0D} $000D,{ # CARRIAGE RETURN        # <CR>  ISO646                               }
{0E} $000E,{ # SHIFT OUT          # <SO>  ISO646                                    }
{0F} $000F,{ # SHIFT IN         # <SI>  ISO646                                     }
{10} $0010,{ # DATA LINK ESCAPE       # <DLE> ISO646                             }
{11} $0011,{ # DEVICE CONTROL ONE       # <DC1> ISO646                           }
{12} $0012,{ # DEVICE CONTROL TWO       # <DC2> ISO646                           }
{13} $0013,{ # DEVICE CONTROL THREE       # <DC3> ISO646                         }
{14} $0014,{ # DEVICE CONTROL FOUR        # <DC4> ISO646                          }
{15} $0015,{ # NEGATIVE ACKNOWLEDGE       # <NAK> ISO646                         }
{16} $0016,{ # SYNCHRONOUS IDLE       # <SYN> ISO646                             }
{17} $0017,{ # END OF TRANSMISSION BLOCK      # <ETB> ISO646                     }
{18} $0018,{ # CANCEL         # <CAN> ISO646                                      }
{19} $0019,{ # END OF MEDIUM          # <EM>  ISO646                                }
{1A} $001A,{ # SUBSTITUTE         # <SUB> ISO646                                  }
{1B} $001B,{ # ESCAPE         # <ESC> ISO646                                      }
{1C} $001C,{ # FILE SEPARATOR       # <FS>  ISO646                                }
{1D} $001D,{ # GROUP SEPARATOR        # <GS>  ISO646                               }
{1E} $001E,{ # RECORD SEPARATOR       # <RS>  ISO646                              }
{1F} $001F,{ # UNIT SEPARATOR       # <US>  ISO646                                }
{20} $0020,{ # SPACE            # <SP>  ISO646                                       }
{21} $0021,{ # EXCLAMATION MARK       # ! ASCII                                  }
{22} $0022,{ # QUOTATION MARK       # \ ASCII                                    }
{23} $0023,{ # NUMBER SIGN          # # ASCII                                      }
{24} $0024,{ # DOLLAR SIGN          # $ ASCII                                      }
{25} $0025,{ # PERCENT SIGN         # % ASCII                                     }
{26} $0026,{ # AMPERSAND          # & ASCII                                        }
{27} $0027,{ # APOSTROPHE         # ' ASCII                                       }
{28} $0028,{ # LEFT PARENTHESIS       # ( ASCII                                  }
{29} $0029,{ # RIGHT PARENTHESIS        # ) ASCII                                 }
{2A} $002A,{ # ASTERISK         # * ASCII                                         }
{2B} $002B,{ # PLUS SIGN          # + ASCII                                        }
{2C} $002C,{ # COMMA            # ' ASCII                                           }
{2D} $002D,{ # HYPHEN-MINUS         # - ASCII                                     }
{2E} $002E,{ # FULL STOP          # . ASCII                                        }
{2F} $002F,{ # SOLIDUS          # / ASCII                                          }
{30} $0030,{ # DIGIT ZERO         # 0 ASCII                                       }
{31} $0031,{ # DIGIT ONE          # 1 ASCII                                        }
{32} $0032,{ # DIGIT TWO          # 2 ASCII                                        }
{33} $0033,{ # DIGIT THREE          # 3 ASCII                                      }
{34} $0034,{ # DIGIT FOUR         # 4 ASCII                                       }
{35} $0035,{ # DIGIT FIVE         # 5 ASCII                                       }
{36} $0036,{ # DIGIT SIX          # 6 ASCII                                        }
{37} $0037,{ # DIGIT SEVEN          # 7 ASCII                                      }
{38} $0038,{ # DIGIT EIGHT          # 8 ASCII                                      }
{39} $0039,{ # DIGIT NINE         # 9 ASCII                                       }
{3A} $003A,{ # COLON            # : ASCII                                           }
{3B} $003B,{ # SEMICOLON          # ; ASCII                                        }
{3C} $003C,{ # LESS-THAN SIGN       # < ASCII                                    }
{3D} $003D,{ # EQUALS SIGN          # = ASCII                                      }
{3E} $003E,{ # GREATER-THAN SIGN        # > ASCII                                 }
{3F} $003F,{ # QUESTION MARK          # ? ASCII                                    }
{40} $0040,{ # COMMERCIAL AT          # @ ASCII                                    }
{41} $0041,{ # LATIN CAPITAL LETTER A     # A ASCII                             }
{42} $0042,{ # LATIN CAPITAL LETTER B     # B ASCII                             }
{43} $0043,{ # LATIN CAPITAL LETTER C     # C ASCII                             }
{44} $0044,{ # LATIN CAPITAL LETTER D     # D ASCII                             }
{45} $0045,{ # LATIN CAPITAL LETTER E     # E ASCII                             }
{46} $0046,{ # LATIN CAPITAL LETTER F     # F ASCII                             }
{47} $0047,{ # LATIN CAPITAL LETTER G     # G ASCII                             }
{48} $0048,{ # LATIN CAPITAL LETTER H     # H ASCII                             }
{49} $0049,{ # LATIN CAPITAL LETTER I     # I ASCII                             }
{4A} $004A,{ # LATIN CAPITAL LETTER J     # J ASCII                             }
{4B} $004B,{ # LATIN CAPITAL LETTER K     # K ASCII                             }
{4C} $004C,{ # LATIN CAPITAL LETTER L     # L ASCII                             }
{4D} $004D,{ # LATIN CAPITAL LETTER M     # M ASCII                             }
{4E} $004E,{ # LATIN CAPITAL LETTER N     # N ASCII                             }
{4F} $004F,{ # LATIN CAPITAL LETTER O     # O ASCII                             }
{50} $0050,{ # LATIN CAPITAL LETTER P     # P ASCII                             }
{51} $0051,{ # LATIN CAPITAL LETTER Q     # Q ASCII                             }
{52} $0052,{ # LATIN CAPITAL LETTER R     # R ASCII                             }
{53} $0053,{ # LATIN CAPITAL LETTER S     # S ASCII                             }
{54} $0054,{ # LATIN CAPITAL LETTER T     # T ASCII                             }
{55} $0055,{ # LATIN CAPITAL LETTER U     # U ASCII                             }
{56} $0056,{ # LATIN CAPITAL LETTER V     # V ASCII                             }
{57} $0057,{ # LATIN CAPITAL LETTER W     # W ASCII                             }
{58} $0058,{ # LATIN CAPITAL LETTER X     # X ASCII                             }
{59} $0059,{ # LATIN CAPITAL LETTER Y     # Y ASCII                             }
{5A} $005A,{ # LATIN CAPITAL LETTER Z     # Z ASCII                             }
{5B} $005B,{ # LEFT SQUARE BRACKET        # [ ASCII                               }
{5C} $005C,{ # REVERSE SOLIDUS        # \ ASCII                                   }
{5D} $005D,{ # RIGHT SQUARE BRACKET       # ] ASCII                              }
{5E} $005E,{ # CIRCUMFLEX ACCENT        # ^ ASCII                                 }
{5F} $005F,{ # LOW LINE         # _ ASCII                                         }
{60} $0060,{ # GRAVE ACCENT         # ` ASCII                                     }
{61} $0061,{ # LATIN SMALL LETTER A       # a ASCII                              }
{62} $0062,{ # LATIN SMALL LETTER B       # b ASCII                              }
{63} $0063,{ # LATIN SMALL LETTER C       # c ASCII                              }
{64} $0064,{ # LATIN SMALL LETTER D       # d ASCII                              }
{65} $0065,{ # LATIN SMALL LETTER E       # e ASCII                              }
{66} $0066,{ # LATIN SMALL LETTER F       # f ASCII                              }
{67} $0067,{ # LATIN SMALL LETTER G       # g ASCII                              }
{68} $0068,{ # LATIN SMALL LETTER H       # h ASCII                              }
{69} $0069,{ # LATIN SMALL LETTER I       # i ASCII                              }
{6A} $006A,{ # LATIN SMALL LETTER J       # j ASCII                              }
{6B} $006B,{ # LATIN SMALL LETTER K       # k ASCII                              }
{6C} $006C,{ # LATIN SMALL LETTER L       # l ASCII                              }
{6D} $006D,{ # LATIN SMALL LETTER M       # m ASCII                              }
{6E} $006E,{ # LATIN SMALL LETTER N       # n ASCII                              }
{6F} $006F,{ # LATIN SMALL LETTER O       # o ASCII                              }
{70} $0070,{ # LATIN SMALL LETTER P       # p ASCII                              }
{71} $0071,{ # LATIN SMALL LETTER Q       # q ASCII                              }
{72} $0072,{ # LATIN SMALL LETTER R       # r ASCII                              }
{73} $0073,{ # LATIN SMALL LETTER S       # s ASCII                              }
{74} $0074,{ # LATIN SMALL LETTER T       # t ASCII                              }
{75} $0075,{ # LATIN SMALL LETTER U       # u ASCII                              }
{76} $0076,{ # LATIN SMALL LETTER V       # v ASCII                              }
{77} $0077,{ # LATIN SMALL LETTER W       # w ASCII                              }
{78} $0078,{ # LATIN SMALL LETTER X       # x ASCII                              }
{79} $0079,{ # LATIN SMALL LETTER Y       # y ASCII                              }
{7A} $007A,{ # LATIN SMALL LETTER Z       # z ASCII                              }
{7B} $007B,{ # LEFT CURLY BRACKET       #   ASCII                                }
{7C} $007C,{ # VERTICAL LINE          # | ASCII                                    }
{7D} $007D,{ # RIGHT CURLY BRACKET        #   ASCII                               }
{7E} $007E,{ # TILDE            # ~ ASCII                                           }
{7F} $007F,{ # DELETE         # <DEL> ISO646                                      }
{80} $00C7,{ # LATIN CAPITAL LETTER C WITH CEDILLA    # Ç CP437,CP850           }
{81} $00FC,{ # LATIN SMALL LETTER U WITH DIAERESIS    # ü CP437,CP850           }
{82} $00E9,{ # LATIN SMALL LETTER E WITH ACUTE    # é CP437,CP850               }
{83} $00E2,{ # LATIN SMALL LETTER A WITH CIRCUMFLEX   # â CP437,CP850          }
{84} $00E4,{ # LATIN SMALL LETTER A WITH DIAERESIS    # ä CP437,CP850           }
{85} $00E0,{ # LATIN SMALL LETTER A WITH GRAVE    # à CP437,CP850               }
{86} $00E5,{ # LATIN SMALL LETTER A WITH RING ABOVE   # å CP437,CP850          }
{87} $00E7,{ # LATIN SMALL LETTER C WITH CEDILLA    # ç CP437,CP850             }
{88} $00EA,{ # LATIN SMALL LETTER E WITH CIRCUMFLEX   # ê CP437,CP850          }
{89} $00EB,{ # LATIN SMALL LETTER E WITH DIAERESIS    # ë CP437,CP850           }
{8A} $00E8,{ # LATIN SMALL LETTER E WITH GRAVE    # è CP437,CP850               }
{8B} $00EF,{ # LATIN SMALL LETTER I WITH DIAERESIS    # ï CP437,CP850           }
{8C} $00EE,{ # LATIN SMALL LETTER I WITH CIRCUMFLEX   # î CP437,CP850          }
{8D} $00EC,{ # LATIN SMALL LETTER I WITH GRAVE    # ì CP437,CP850               }
{8E} $00C4,{ # LATIN CAPITAL LETTER A WITH DIAERESIS    # Ä CP437,CP850         }
{8F} $00C5,{ # LATIN CAPITAL LETTER A WITH RING ABOVE # Å CP437,CP850         }
{90} $00C9,{ # LATIN CAPITAL LETTER E WITH ACUTE    # É CP437,CP850             }
{91} $00E6,{ # LATIN SMALL LIGATURE AE      # æ CP437,CP850                      }
{92} $00C6,{ # LATIN CAPITAL LIGATURE AE      # Æ CP437,CP850                    }
{93} $00F4,{ # LATIN SMALL LETTER O WITH CIRCUMFLEX   # ô CP437,CP850          }
{94} $00F6,{ # LATIN SMALL LETTER O WITH DIAERESIS    # ö CP437,CP850           }
{95} $00F2,{ # LATIN SMALL LETTER O WITH GRAVE    # ò CP437,CP850               }
{96} $00FB,{ # LATIN SMALL LETTER U WITH CIRCUMFLEX   # û CP437,CP850          }
{97} $00F9,{ # LATIN SMALL LETTER U WITH GRAVE    # ù CP437,CP850               }
{98} $00FF,{ # LATIN SMALL LETTER Y WITH DIAERESIS    # ÿ CP437,CP850           }
{99} $00D6,{ # LATIN SMALL LETTER O WITH DIAERESIS    # Ö CP437,CP850           }
{9A} $00DC,{ # LATIN SMALL LETTER U WITH DIAERESIS    # Ü CP437,CP850           }
{9B} $00A2,{ # CENT SIGN          # ¢ CP437                                        }
{9C} $00A3,{ # POUND SIGN         # £ CP437,CP850                                 }
{9D} $00A5,{ # YEN SIGN         # ¥ CP437                                         }
{9E} $03B2,{ # GREEK SMALL LETTER BETA      # ß AtariST                          }
{9F} $0192,{ # LATIN SMALL LETTER F WITH HOOK   # &#402;  CP437,CP850           }
{A0} $00E1,{ # LATIN SMALL LETTER A WITH ACUTE    # á CP437,CP850               }
{A1} $00ED,{ # LATIN SMALL LETTER I WITH ACUTE    # í CP437,CP850               }
{A2} $00F3,{ # LATIN SMALL LETTER O WITH ACUTE    # ó CP437,CP850               }
{A3} $00FA,{ # LATIN SMALL LETTER U WITH ACUTE    # ú CP437,CP850               }
{A4} $00F1,{ # LATIN SMALL LETTER N WITH TILDE    # ñ CP437,CP850               }
{A5} $00D1,{ # LATIN CAPITAL LETTER N WITH TILDE    # Ñ CP437,CP850             }
{A6} $00AA,{ # FEMININE ORDINAL INDICATOR     # ª CP437,CP850                   }
{A7} $00BA,{ # MASCULINE ORDINAL INDICATOR      # º CP437,CP850                  }
{A8} $00BF,{ # INVERTED QUESTION MARK     # ¿ CP437,CP850                       }
{A9} $2310,{ # REVERSED NOT SIGN        # &#8976; CP437                           }
{AA} $00AC,{ # NOT SIGN         # ¬ CP437,CP850                                   }
{AB} $00BD,{ # VULGAR FRACTION ONE HALF     # ½ CP437,CP850                     }
{AC} $00BC,{ # VULGAR FRACTION ONE QUARTER      # ¼ CP437,CP850                  }
{AD} $00A1,{ # INVERTED EXCLAMATION MARK      # ¡ CP437,CP850                    }
{AE} $00AB,{ # LEFT-POINTING DOUBLE ANGLE QUOTATION MARK  # « CP437,CP850      }
{AF} $00BB,{ # RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK # » CP437,CP850     }
{B0} $00E3,{ # LATIN SMALL LETTER A WITH TILDE    # ã AtariST                   }
{B1} $00F5,{ # LATIN SMALL LETTER O WITH TILDE    # õ AtariST                   }
{B2} $00D8,{ # LATIN CAPITAL LETTER O WITH STROKE   # Ø AtariST                }
{B3} $00F8,{ # LATIN SMALL LETTER O WITH STROKE   # ø AtariST                  }
{B4} $0153,{ # LATIN SMALL LIGATURE OE      # &#339;  AtariST                     }
{B5} $0152,{ # LATIN CAPITAL LIGATURE OE      # &#338;  AtariST                   }
{B6} $00C0,{ # LATIN CAPITAL LETTER A WITH GRAVE    # À AtariST                 }
{B7} $00C3,{ # LATIN CAPITAL LETTER A WITH TILDE    # Ã AtariST                 }
{B8} $00D5,{ # LATIN CAPITAL LETTER O WITH TILDE    # Õ AtariST                 }
{B9} $00A8,{ # SPACING DIAERESIS        # ¨ AtariST                               }
{BA} $00B4,{ # SPACING ACUTE ACCENT       # ´ AtariST                            }
{BB} $2020,{ # DAGGER         # &#8224; AtariST                                   }
{BC} $00B6,{ # PILCROW SIGN         # ¶ AtariST                                   }
{BD} $00A9,{ # COPYRIGHT SIGN       # © AtariST                                  }
{BE} $00AE,{ # REGISTERED SIGN        # ® AtariST                                 }
{BF} $2122,{ # TRADE MARK SIGN        # &#8482; AtariST                           }
{C0} $0133,{ # LATIN SMALL LIGATURE IJ      # &#307;  AtariST                     }
{C1} $0132,{ # LATIN CAPITAL LIGATURE IJ      # &#306;  AtariST                   }
{C2} $05D0,{ # HEBREW LETTER ALEF       # &#1488; AtariST                        }
{C3} $05D1,{ # HEBREW LETTER BET        # &#1489; AtariST                         }
{C4} $05D2,{ # HEBREW LETTER GIMEL        # &#1490; AtariST                       }
{C5} $05D3,{ # HEBREW LETTER DALET        # &#1491; AtariST                       }
{C6} $05D4,{ # HEBREW LETTER HE       # &#1492; AtariST                          }
{C7} $05D5,{ # HEBREW LETTER VAV        # &#1493; AtariST                         }
{C8} $05D6,{ # HEBREW LETTER ZAYIN        # &#1494; AtariST                       }
{C9} $05D7,{ # HEBREW LETTER HET        # &#1495; AtariST                         }
{CA} $05D8,{ # HEBREW LETTER TET        # &#1496; AtariST                         }
{CB} $05D9,{ # HEBREW LETTER YOD        # &#1497; AtariST                         }
{CC} $05DB,{ # HEBREW LETTER KAF        # &#1499; AtariST                         }
{CD} $05DC,{ # HEBREW LETTER LAMED        # &#1500; AtariST                       }
{CE} $05DE,{ # HEBREW LETTER MEM        # &#1502; AtariST                         }
{CF} $05E0,{ # HEBREW LETTER NUN        # &#1504; AtariST                         }
{D0} $05E1,{ # HEBREW LETTER SAMEKH       # &#1505; AtariST                      }
{D1} $05E2,{ # HEBREW LETTER AYIN       # &#1506; AtariST                        }
{D2} $05E4,{ # HEBREW LETTER PE       # &#1508; AtariST                          }
{D3} $05E6,{ # HEBREW LETTER TSADI        # &#1510; AtariST                       }
{D4} $05E7,{ # HEBREW LETTER QOF        # &#1511; AtariST                         }
{D5} $05E8,{ # HEBREW LETTER RESH       # &#1512; AtariST                        }
{D6} $05E9,{ # HEBREW LETTER SHIN       # &#1513; AtariST                        }
{D7} $05EA,{ # HEBREW LETTER TAV        # &#1514; AtariST                         }
{D8} $05DF,{ # HEBREW LETTER FINAL NUN      # &#1503; AtariST                    }
{D9} $05DA,{ # HEBREW LETTER FINAL KAF      # &#1498; AtariST                    }
{DA} $05DD,{ # HEBREW LETTER FINAL MEM      # &#1501; AtariST                    }
{DB} $05E3,{ # HEBREW LETTER FINAL PE     # &#1507; AtariST                     }
{DC} $05E5,{ # HEBREW LETTER FINAL TSADI      # &#1509; AtariST                  }
{DD} $00A7,{ # SECTION SIGN         # § AtariST                                   }
{DE} $2227,{ # LOGICAL AND          # &#8743; AtariST                              }
{DF} $221E,{ # INFINITY         # &#8734; AtariST                                 }
{E0} $03B1,{ # GREEK SMALL LETTER ALPHA     # &#945;  CP437,CP850                }
{E1} $00DF,{ # LATIN SMALL LETTER SHARP S     # ß CP437,CP850                   }
{E2} $0393,{ # GREEK CAPITAL LETTER GAMMA     # &#915;  CP437,CP850              }
{E3} $03C0,{ # GREEK SMALL LETTER PI        # &#960;  CP437,CP850                  }
{E4} $03A3,{ # GREEK CAPITAL LETTER SIGMA     # &#931;  CP437,CP850              }
{E5} $03C3,{ # GREEK SMALL LETTER SIGMA     # &#963;  CP437,CP850                }
{E6} $00B5,{ # MICRO SIGN         # µ CP437,CP850                                 }
{E7} $03C4,{ # GREEK SMALL LETTER TAU     # &#964;  CP437,CP850                  }
{E8} $03A6,{ # GREEK CAPITAL LETTER PHI     # &#934;  CP437,CP850                }
{E9} $0398,{ # GREEK CAPITAL LETTER THETA     # &#920;  CP437,CP850              }
{EA} $03A9,{ # GREEK CAPITAL LETTER OMEGA     # &#937;  CP437,CP850              }
{EB} $03B4,{ # GREEK SMALL LETTER DELTA     # &#948;  CP437,CP850                }
{EC} $222E,{ # CONTOUR INTEGRAL       # &#8750; AtariST                          }
{ED} $03C6,{ # GREEP SMALL LETTER PHI     # &#966;  CP437,CP850                  }
{EE} $03B5,{ # GREEK SMALL LETTER EPSILON     # &#949;  CP437,CP850              }
{EF} $2229,{ # INTERSECTION         # &#8745; CP437,CP850                         }
{F0} $2261,{ # IDENTICAL TO         # &#8801; CP437,CP850                         }
{F1} $00B1,{ # PLUS-MINUS SIGN        # ± CP437,CP850                             }
{F2} $2265,{ # GREATER-THAN OR EQUAL TO     # &#8805; CP437,CP850               }
{F3} $2264,{ # LESS-THAN OR EQUAL TO        # &#8804; CP437,CP850                 }
{F4} $2320,{ # TOP HALF INTEGRAL        # &#8992; CP437,CP850                     }
{F5} $2321,{ # BOTTOM HALF INTEGRAL       # &#8993; CP437,CP850                  }
{F6} $00F7,{ # DIVISION SIGN          # ÷ CP437,CP850                              }
{F7} $2248,{ # ALMOST EQUAL TO        # &#8776; CP437,CP850                       }
{F8} $00B0,{ # DEGREE SIGN          # ° CP437,CP850                                }
{F9} $2219,{ # BULLET OPERATOR        # &#8729; CP437,CP850                       }
{FA} $00B7,{ # MIDDLE DOT         # · CP437,CP850                                 }
{FB} $221A,{ # SQUARE ROOT          # &#8730; CP437,CP850                          }
{FC} $207F,{ # SUPERSCRIPT LATIN SMALL LETTER N   # &#8319; CP437,CP850        }
{FD} $00B2,{ # SUPERSCRIPT TWO        # ² CP437,CP850                             }
{FE} $22B3,{ # SUPERSCRIPT THREE        # ³ AtariST                               }
{FF} $00AF { # MACRON         # ¯ AtariST                                         }
);
