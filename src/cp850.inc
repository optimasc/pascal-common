{                                                                              }
{    Name:     cp850_DOSLatin1 to Unicode table                                }
{    Unicode version: 2.0                                                      }
{    Table version: 2.00                                                       }
{    Table format:  Format A                                                   }
{    Date:          04/24/96                                                   }
{    Authors:       Lori Brownell <loribr@microsoft.com>                       }
{                   K.D. Chang    <a-kchang@microsoft.com>                     }
{    General notes: none                                                       }
{                                                                              }
{    Format: Three tab-separated columns                                       }
{        Column #1 is the cp850_DOSLatin1 code (in hex)                        }
{        Column #2 is the Unicode (in hex as 0xXXXX)                           }
{        Column #3 is the Unicode name (follows a comment sign, '#')           }
{                                                                              }
{    The entries are in cp850_DOSLatin1 order                                  }
{                                                                              }
cp850toUTF32: tchararray = (
{00} $0000,{ #NULL                                                            }
{01} $0001,{ #START OF HEADING                                                }
{02} $0002,{ #START OF TEXT                                                   }
{03} $0003,{ #END OF TEXT                                                     }
{04} $0004,{ #END OF TRANSMISSION                                             }
{05} $0005,{ #ENQUIRY                                                         }
{06} $0006,{ #ACKNOWLEDGE                                                     }
{07} $0007,{ #BELL                                                            }
{08} $0008,{ #BACKSPACE                                                       }
{09} $0009,{ #HORIZONTAL TABULATION                                           }
{0A} $000a,{ #LINE FEED                                                       }
{0B} $000b,{ #VERTICAL TABULATION                                             }
{0C} $000c,{ #FORM FEED                                                       }
{0D} $000d,{ #CARRIAGE RETURN                                                 }
{0E} $000e,{ #SHIFT OUT                                                       }
{0F} $000f,{ #SHIFT IN                                                        }
{10} $0010,{ #DATA LINK ESCAPE                                                }
{11} $0011,{ #DEVICE CONTROL ONE                                              }
{12} $0012,{ #DEVICE CONTROL TWO                                              }
{13} $0013,{ #DEVICE CONTROL THREE                                            }
{14} $0014,{ #DEVICE CONTROL FOUR                                             }
{15} $0015,{ #NEGATIVE ACKNOWLEDGE                                            }
{16} $0016,{ #SYNCHRONOUS IDLE                                                }
{17} $0017,{ #END OF TRANSMISSION BLOCK                                       }
{18} $0018,{ #CANCEL                                                          }
{19} $0019,{ #END OF MEDIUM                                                   }
{1A} $001a,{ #SUBSTITUTE                                                      }
{1B} $001b,{ #ESCAPE                                                          }
{1C} $001c,{ #FILE SEPARATOR                                                  }
{1D} $001d,{ #GROUP SEPARATOR                                                 }
{1E} $001e,{ #RECORD SEPARATOR                                                }
{1F} $001f,{ #UNIT SEPARATOR                                                  }
{20} $0020,{ #SPACE                                                           }
{21} $0021,{ #EXCLAMATION MARK                                                }
{22} $0022,{ #QUOTATION MARK                                                  }
{23} $0023,{ #NUMBER SIGN                                                     }
{24} $0024,{ #DOLLAR SIGN                                                     }
{25} $0025,{ #PERCENT SIGN                                                    }
{26} $0026,{ #AMPERSAND                                                       }
{27} $0027,{ #APOSTROPHE                                                      }
{28} $0028,{ #LEFT PARENTHESIS                                                }
{29} $0029,{ #RIGHT PARENTHESIS                                               }
{2A} $002a,{ #ASTERISK                                                        }
{2B} $002b,{ #PLUS SIGN                                                       }
{2C} $002c,{ #COMMA                                                           }
{2D} $002d,{ #HYPHEN-MINUS                                                    }
{2E} $002e,{ #FULL STOP                                                       }
{2F} $002f,{ #SOLIDUS                                                         }
{30} $0030,{ #DIGIT ZERO                                                      }
{31} $0031,{ #DIGIT ONE                                                       }
{32} $0032,{ #DIGIT TWO                                                       }
{33} $0033,{ #DIGIT THREE                                                     }
{34} $0034,{ #DIGIT FOUR                                                      }
{35} $0035,{ #DIGIT FIVE                                                      }
{36} $0036,{ #DIGIT SIX                                                       }
{37} $0037,{ #DIGIT SEVEN                                                     }
{38} $0038,{ #DIGIT EIGHT                                                     }
{39} $0039,{ #DIGIT NINE                                                      }
{3A} $003a,{ #COLON                                                           }
{3B} $003b,{ #SEMICOLON                                                       }
{3C} $003c,{ #LESS-THAN SIGN                                                  }
{3D} $003d,{ #EQUALS SIGN                                                     }
{3E} $003e,{ #GREATER-THAN SIGN                                               }
{3F} $003f,{ #QUESTION MARK                                                   }
{40} $0040,{ #COMMERCIAL AT                                                   }
{41} $0041,{ #LATIN CAPITAL LETTER A                                          }
{42} $0042,{ #LATIN CAPITAL LETTER B                                          }
{43} $0043,{ #LATIN CAPITAL LETTER C                                          }
{44} $0044,{ #LATIN CAPITAL LETTER D                                          }
{45} $0045,{ #LATIN CAPITAL LETTER E                                          }
{46} $0046,{ #LATIN CAPITAL LETTER F                                          }
{47} $0047,{ #LATIN CAPITAL LETTER G                                          }
{48} $0048,{ #LATIN CAPITAL LETTER H                                          }
{49} $0049,{ #LATIN CAPITAL LETTER I                                          }
{4A} $004a,{ #LATIN CAPITAL LETTER J                                          }
{4B} $004b,{ #LATIN CAPITAL LETTER K                                          }
{4C} $004c,{ #LATIN CAPITAL LETTER L                                          }
{4D} $004d,{ #LATIN CAPITAL LETTER M                                          }
{4E} $004e,{ #LATIN CAPITAL LETTER N                                          }
{4F} $004f,{ #LATIN CAPITAL LETTER O                                          }
{50} $0050,{ #LATIN CAPITAL LETTER P                                          }
{51} $0051,{ #LATIN CAPITAL LETTER Q                                          }
{52} $0052,{ #LATIN CAPITAL LETTER R                                          }
{53} $0053,{ #LATIN CAPITAL LETTER S                                          }
{54} $0054,{ #LATIN CAPITAL LETTER T                                          }
{55} $0055,{ #LATIN CAPITAL LETTER U                                          }
{56} $0056,{ #LATIN CAPITAL LETTER V                                          }
{57} $0057,{ #LATIN CAPITAL LETTER W                                          }
{58} $0058,{ #LATIN CAPITAL LETTER X                                          }
{59} $0059,{ #LATIN CAPITAL LETTER Y                                          }
{5A} $005a,{ #LATIN CAPITAL LETTER Z                                          }
{5B} $005b,{ #LEFT SQUARE BRACKET                                             }
{5C} $005c,{ #REVERSE SOLIDUS                                                 }
{5D} $005d,{ #RIGHT SQUARE BRACKET                                            }
{5E} $005e,{ #CIRCUMFLEX ACCENT                                               }
{5F} $005f,{ #LOW LINE                                                        }
{60} $0060,{ #GRAVE ACCENT                                                    }
{61} $0061,{ #LATIN SMALL LETTER A                                            }
{62} $0062,{ #LATIN SMALL LETTER B                                            }
{63} $0063,{ #LATIN SMALL LETTER C                                            }
{64} $0064,{ #LATIN SMALL LETTER D                                            }
{65} $0065,{ #LATIN SMALL LETTER E                                            }
{66} $0066,{ #LATIN SMALL LETTER F                                            }
{67} $0067,{ #LATIN SMALL LETTER G                                            }
{68} $0068,{ #LATIN SMALL LETTER H                                            }
{69} $0069,{ #LATIN SMALL LETTER I                                            }
{6A} $006a,{ #LATIN SMALL LETTER J                                            }
{6B} $006b,{ #LATIN SMALL LETTER K                                            }
{6C} $006c,{ #LATIN SMALL LETTER L                                            }
{6D} $006d,{ #LATIN SMALL LETTER M                                            }
{6E} $006e,{ #LATIN SMALL LETTER N                                            }
{6F} $006f,{ #LATIN SMALL LETTER O                                            }
{70} $0070,{ #LATIN SMALL LETTER P                                            }
{71} $0071,{ #LATIN SMALL LETTER Q                                            }
{72} $0072,{ #LATIN SMALL LETTER R                                            }
{73} $0073,{ #LATIN SMALL LETTER S                                            }
{74} $0074,{ #LATIN SMALL LETTER T                                            }
{75} $0075,{ #LATIN SMALL LETTER U                                            }
{76} $0076,{ #LATIN SMALL LETTER V                                            }
{77} $0077,{ #LATIN SMALL LETTER W                                            }
{78} $0078,{ #LATIN SMALL LETTER X                                            }
{79} $0079,{ #LATIN SMALL LETTER Y                                            }
{7A} $007a,{ #LATIN SMALL LETTER Z                                            }
{7B} $007b,{ #LEFT CURLY BRACKET                                              }
{7C} $007c,{ #VERTICAL LINE                                                   }
{7D} $007d,{ #RIGHT CURLY BRACKET                                             }
{7E} $007e,{ #TILDE                                                           }
{7F} $007f,{ #DELETE                                                          }
{80} $00c7,{ #LATIN CAPITAL LETTER C WITH CEDILLA                             }
{81} $00fc,{ #LATIN SMALL LETTER U WITH DIAERESIS                             }
{82} $00e9,{ #LATIN SMALL LETTER E WITH ACUTE                                 }
{83} $00e2,{ #LATIN SMALL LETTER A WITH CIRCUMFLEX                            }
{84} $00e4,{ #LATIN SMALL LETTER A WITH DIAERESIS                             }
{85} $00e0,{ #LATIN SMALL LETTER A WITH GRAVE                                 }
{86} $00e5,{ #LATIN SMALL LETTER A WITH RING ABOVE                            }
{87} $00e7,{ #LATIN SMALL LETTER C WITH CEDILLA                               }
{88} $00ea,{ #LATIN SMALL LETTER E WITH CIRCUMFLEX                            }
{89} $00eb,{ #LATIN SMALL LETTER E WITH DIAERESIS                             }
{8A} $00e8,{ #LATIN SMALL LETTER E WITH GRAVE                                 }
{8B} $00ef,{ #LATIN SMALL LETTER I WITH DIAERESIS                             }
{8C} $00ee,{ #LATIN SMALL LETTER I WITH CIRCUMFLEX                            }
{8D} $00ec,{ #LATIN SMALL LETTER I WITH GRAVE                                 }
{8E} $00c4,{ #LATIN CAPITAL LETTER A WITH DIAERESIS                           }
{8F} $00c5,{ #LATIN CAPITAL LETTER A WITH RING ABOVE                          }
{90} $00c9,{ #LATIN CAPITAL LETTER E WITH ACUTE                               }
{91} $00e6,{ #LATIN SMALL LIGATURE AE                                         }
{92} $00c6,{ #LATIN CAPITAL LIGATURE AE                                       }
{93} $00f4,{ #LATIN SMALL LETTER O WITH CIRCUMFLEX                            }
{94} $00f6,{ #LATIN SMALL LETTER O WITH DIAERESIS                             }
{95} $00f2,{ #LATIN SMALL LETTER O WITH GRAVE                                 }
{96} $00fb,{ #LATIN SMALL LETTER U WITH CIRCUMFLEX                            }
{97} $00f9,{ #LATIN SMALL LETTER U WITH GRAVE                                 }
{98} $00ff,{ #LATIN SMALL LETTER Y WITH DIAERESIS                             }
{99} $00d6,{ #LATIN CAPITAL LETTER O WITH DIAERESIS                           }
{9A} $00dc,{ #LATIN CAPITAL LETTER U WITH DIAERESIS                           }
{9B} $00f8,{ #LATIN SMALL LETTER O WITH STROKE                                }
{9C} $00a3,{ #POUND SIGN                                                      }
{9D} $00d8,{ #LATIN CAPITAL LETTER O WITH STROKE                              }
{9E} $00d7,{ #MULTIPLICATION SIGN                                             }
{9F} $0192,{ #LATIN SMALL LETTER F WITH HOOK                                  }
{A0} $00e1,{ #LATIN SMALL LETTER A WITH ACUTE                                 }
{A1} $00ed,{ #LATIN SMALL LETTER I WITH ACUTE                                 }
{A2} $00f3,{ #LATIN SMALL LETTER O WITH ACUTE                                 }
{A3} $00fa,{ #LATIN SMALL LETTER U WITH ACUTE                                 }
{A4} $00f1,{ #LATIN SMALL LETTER N WITH TILDE                                 }
{A5} $00d1,{ #LATIN CAPITAL LETTER N WITH TILDE                               }
{A6} $00aa,{ #FEMININE ORDINAL INDICATOR                                      }
{A7} $00ba,{ #MASCULINE ORDINAL INDICATOR                                     }
{A8} $00bf,{ #INVERTED QUESTION MARK                                          }
{A9} $00ae,{ #REGISTERED SIGN                                                 }
{AA} $00ac,{ #NOT SIGN                                                        }
{AB} $00bd,{ #VULGAR FRACTION ONE HALF                                        }
{AC} $00bc,{ #VULGAR FRACTION ONE QUARTER                                     }
{AD} $00a1,{ #INVERTED EXCLAMATION MARK                                       }
{AE} $00ab,{ #LEFT-POINTING DOUBLE ANGLE QUOTATION MARK                       }
{AF} $00bb,{ #RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK                      }
{B0} $2591,{ #LIGHT SHADE                                                     }
{B1} $2592,{ #MEDIUM SHADE                                                    }
{B2} $2593,{ #DARK SHADE                                                      }
{B3} $2502,{ #BOX DRAWINGS LIGHT VERTICAL                                     }
{B4} $2524,{ #BOX DRAWINGS LIGHT VERTICAL AND LEFT                            }
{B5} $00c1,{ #LATIN CAPITAL LETTER A WITH ACUTE                               }
{B6} $00c2,{ #LATIN CAPITAL LETTER A WITH CIRCUMFLEX                          }
{B7} $00c0,{ #LATIN CAPITAL LETTER A WITH GRAVE                               }
{B8} $00a9,{ #COPYRIGHT SIGN                                                  }
{B9} $2563,{ #BOX DRAWINGS DOUBLE VERTICAL AND LEFT                           }
{BA} $2551,{ #BOX DRAWINGS DOUBLE VERTICAL                                    }
{BB} $2557,{ #BOX DRAWINGS DOUBLE DOWN AND LEFT                               }
{BC} $255d,{ #BOX DRAWINGS DOUBLE UP AND LEFT                                 }
{BD} $00a2,{ #CENT SIGN                                                       }
{BE} $00a5,{ #YEN SIGN                                                        }
{BF} $2510,{ #BOX DRAWINGS LIGHT DOWN AND LEFT                                }
{C0} $2514,{ #BOX DRAWINGS LIGHT UP AND RIGHT                                 }
{C1} $2534,{ #BOX DRAWINGS LIGHT UP AND HORIZONTAL                            }
{C2} $252c,{ #BOX DRAWINGS LIGHT DOWN AND HORIZONTAL                          }
{C3} $251c,{ #BOX DRAWINGS LIGHT VERTICAL AND RIGHT                           }
{C4} $2500,{ #BOX DRAWINGS LIGHT HORIZONTAL                                   }
{C5} $253c,{ #BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL                      }
{C6} $00e3,{ #LATIN SMALL LETTER A WITH TILDE                                 }
{C7} $00c3,{ #LATIN CAPITAL LETTER A WITH TILDE                               }
{C8} $255a,{ #BOX DRAWINGS DOUBLE UP AND RIGHT                                }
{C9} $2554,{ #BOX DRAWINGS DOUBLE DOWN AND RIGHT                              }
{CA} $2569,{ #BOX DRAWINGS DOUBLE UP AND HORIZONTAL                           }
{CB} $2566,{ #BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL                         }
{CC} $2560,{ #BOX DRAWINGS DOUBLE VERTICAL AND RIGHT                          }
{CD} $2550,{ #BOX DRAWINGS DOUBLE HORIZONTAL                                  }
{CE} $256c,{ #BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL                     }
{CF} $00a4,{ #CURRENCY SIGN                                                   }
{D0} $00f0,{ #LATIN SMALL LETTER ETH                                          }
{D1} $00d0,{ #LATIN CAPITAL LETTER ETH                                        }
{D2} $00ca,{ #LATIN CAPITAL LETTER E WITH CIRCUMFLEX                          }
{D3} $00cb,{ #LATIN CAPITAL LETTER E WITH DIAERESIS                           }
{D4} $00c8,{ #LATIN CAPITAL LETTER E WITH GRAVE                               }
{D5} $0131,{ #LATIN SMALL LETTER DOTLESS I                                    }
{D6} $00cd,{ #LATIN CAPITAL LETTER I WITH ACUTE                               }
{D7} $00ce,{ #LATIN CAPITAL LETTER I WITH CIRCUMFLEX                          }
{D8} $00cf,{ #LATIN CAPITAL LETTER I WITH DIAERESIS                           }
{D9} $2518,{ #BOX DRAWINGS LIGHT UP AND LEFT                                  }
{DA} $250c,{ #BOX DRAWINGS LIGHT DOWN AND RIGHT                               }
{DB} $2588,{ #FULL BLOCK                                                      }
{DC} $2584,{ #LOWER HALF BLOCK                                                }
{DD} $00a6,{ #BROKEN BAR                                                      }
{DE} $00cc,{ #LATIN CAPITAL LETTER I WITH GRAVE                               }
{DF} $2580,{ #UPPER HALF BLOCK                                                }
{E0} $00d3,{ #LATIN CAPITAL LETTER O WITH ACUTE                               }
{E1} $00df,{ #LATIN SMALL LETTER SHARP S                                      }
{E2} $00d4,{ #LATIN CAPITAL LETTER O WITH CIRCUMFLEX                          }
{E3} $00d2,{ #LATIN CAPITAL LETTER O WITH GRAVE                               }
{E4} $00f5,{ #LATIN SMALL LETTER O WITH TILDE                                 }
{E5} $00d5,{ #LATIN CAPITAL LETTER O WITH TILDE                               }
{E6} $00b5,{ #MICRO SIGN                                                      }
{E7} $00fe,{ #LATIN SMALL LETTER THORN                                        }
{E8} $00de,{ #LATIN CAPITAL LETTER THORN                                      }
{E9} $00da,{ #LATIN CAPITAL LETTER U WITH ACUTE                               }
{EA} $00db,{ #LATIN CAPITAL LETTER U WITH CIRCUMFLEX                          }
{EB} $00d9,{ #LATIN CAPITAL LETTER U WITH GRAVE                               }
{EC} $00fd,{ #LATIN SMALL LETTER Y WITH ACUTE                                 }
{ED} $00dd,{ #LATIN CAPITAL LETTER Y WITH ACUTE                               }
{EE} $00af,{ #MACRON                                                          }
{EF} $00b4,{ #ACUTE ACCENT                                                    }
{F0} $00ad,{ #SOFT HYPHEN                                                     }
{F1} $00b1,{ #PLUS-MINUS SIGN                                                 }
{F2} $2017,{ #DOUBLE LOW LINE                                                 }
{F3} $00be,{ #VULGAR FRACTION THREE QUARTERS                                  }
{F4} $00b6,{ #PILCROW SIGN                                                    }
{F5} $00a7,{ #SECTION SIGN                                                    }
{F6} $00f7,{ #DIVISION SIGN                                                   }
{F7} $00b8,{ #CEDILLA                                                         }
{F8} $00b0,{ #DEGREE SIGN                                                     }
{F9} $00a8,{ #DIAERESIS                                                       }
{FA} $00b7,{ #MIDDLE DOT                                                      }
{FB} $00b9,{ #SUPERSCRIPT ONE                                                 }
{FC} $00b3,{ #SUPERSCRIPT THREE                                               }
{FD} $00b2,{ #SUPERSCRIPT TWO                                                 }
{FE} $25a0,{ #BLACK SQUARE                                                    }
{FF} $00a0 { #NO-BREAK SPACE                                                  }
);
