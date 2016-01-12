# Start assigning timezones by CZ_TIMEZONE
details <- details[CZ_TIMEZONE == "AKST", 
             BEGIN_YMDHMS := force_tz(BEGIN_DATETIME,
                                      tz = "America/Anchorage")]
details <- details[CZ_TIMEZONE == "AKST", 
             END_YMDHMS := force_tz(END_DATETIME, 
                                    tz = "America/Anchorage")]

details <- details[CZ_TIMEZONE == "AST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "America/Halifax")]
details <- details[CZ_TIMEZONE == "AST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "CST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "America/Chicago")]
details <- details[CZ_TIMEZONE == "CST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "ChST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "Pacific/Guam")]
details <- details[CZ_TIMEZONE == "ChST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "Pacific/Guam")]

details <- details[CZ_TIMEZONE == "EST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "America/New_York")]
details <- details[CZ_TIMEZONE == "EST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "HST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "Pacific/Honolulu")]
details <- details[CZ_TIMEZONE == "HST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "Pacific/Honolulu")]

details <- details[CZ_TIMEZONE == "MST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "America/Denver")]
details <- details[CZ_TIMEZONE == "MST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "America/Los_Angeles")]
details <- details[CZ_TIMEZONE == "PST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "America/Los_Angeles")]

details <- details[CZ_TIMEZONE == "SST", 
                   BEGIN_YMDHMS := force_tz(BEGIN_DATETIME, 
                                            tz = "Pacific/Samoa")]
details <- details[CZ_TIMEZONE == "SST", 
                   END_YMDHMS:= with_tz(END_DATETIME, 
                                        tz = "Pacific/Samoa")]

details <- details[, BEGIN_YMDHMS_UTC := with_tz(BEGIN_YMDHMS, tz = "UTC")]
details <- details[, END_YMDHMS_UTC := with_tz(END_YMDHMS, tz = "UTC")]

