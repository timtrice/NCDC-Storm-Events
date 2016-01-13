# Start assigning timezones by CZ_TIMEZONE
details <- details[CZ_TIMEZONE == "AKST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX,
                                              tz = "America/Anchorage")]
details <- details[CZ_TIMEZONE == "AKST", 
                   END_YMDHMS_L := force_tz(EDT_POSIX, 
                                            tz = "America/Anchorage")]

details <- details[CZ_TIMEZONE == "AST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Halifax")]
details <- details[CZ_TIMEZONE == "AST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "CST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Chicago")]
details <- details[CZ_TIMEZONE == "CST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "ChST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "Pacific/Guam")]
details <- details[CZ_TIMEZONE == "ChST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "Pacific/Guam")]

details <- details[CZ_TIMEZONE == "EST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/New_York")]
details <- details[CZ_TIMEZONE == "EST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "HST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "Pacific/Honolulu")]
details <- details[CZ_TIMEZONE == "HST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "Pacific/Honolulu")]

details <- details[CZ_TIMEZONE == "MST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Denver")]
details <- details[CZ_TIMEZONE == "MST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Los_Angeles")]
details <- details[CZ_TIMEZONE == "PST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "America/Los_Angeles")]

details <- details[CZ_TIMEZONE == "SST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "Pacific/Samoa")]
details <- details[CZ_TIMEZONE == "SST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                          tz = "Pacific/Samoa")]

details <- details[, BEGIN_YMDHMS_UTC := with_tz(BEGIN_YMDHMS_L, tz = "UTC")]
details <- details[, END_YMDHMS_UTC := with_tz(END_YMDHMS_L, tz = "UTC")]
