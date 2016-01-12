# For consistency, I'll make all abbr's upper case
details <- details[, CZ_TIMEZONE := toupper(CZ_TIMEZONE)]

# Now start going through each timezone, correct inconsistencies. 
print(gmt <- details[CZ_TIMEZONE == "GMT", .(STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "GMT", CZ_TIMEZONE := "CST"]

print(unk <- details[CZ_TIMEZONE == "UNK", .(CZ_NAME, STATE, BEGIN_DATETIME)])

# Hampden, MA
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "HAMPDEN" & 
            STATE == "MASSACHUSETTS", 
        CZ_TIMEZONE := "EST"]

# LOVE, OK
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "LOVE" & 
            STATE == "OKLAHOMA", 
        CZ_TIMEZONE := "CST"]

# Rush, IN
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "RUSH" & 
            STATE == "INDIANA", 
        CZ_TIMEZONE := "EST"]

# McLennan, TX
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "MCLENNAN" & 
            STATE == "TEXAS", 
        CZ_TIMEZONE := "CST"]

# OCONEE, GA
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "OCONEE" & 
            STATE == "GEORGIA", 
        CZ_TIMEZONE := "EST"]

# COLES, IL
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "COLES" & 
            STATE == "ILLINOIS", 
        CZ_TIMEZONE := "CST"]

# PERKINS, SD
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "PERKINS" & 
            STATE == "SOUTH DAKOTA", 
        CZ_TIMEZONE := "MST"]

# HAWAII, HAWAII
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "HAWAII" & 
            STATE == "HAWAII", 
        CZ_TIMEZONE := "HST"]

# ARMSTRONG, TEXAS
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "ARMSTRONG" & 
            STATE == "TEXAS", 
        CZ_TIMEZONE := "CST"]

print(sct <- details[CZ_TIMEZONE == "SCT", .(CZ_NAME, STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "SCT" & 
            CZ_NAME == "SHAWANO" & 
            STATE == "WISCONSIN", 
        CZ_TIMEZONE := "CST"]

print(sst <- details[CZ_TIMEZONE == "SST", .(CZ_NAME, STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "SST" & 
            STATE == "GUAM", 
        CZ_TIMEZONE := "ChST"]

details[CZ_TIMEZONE == "SST" & 
            CZ_NAME == "GUAM COASTAL WATERS", 
        CZ_TIMEZONE := "ChST"]

print(csc <- details[CZ_TIMEZONE == "CSC", .(CZ_NAME, STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "CSC", CZ_TIMEZONE := "CST"]

print(gst10 <- details[CZ_TIMEZONE == "GST10", .(CZ_NAME, STATE, 
                                                 BEGIN_DATETIME)])

details[CZ_TIMEZONE == "GST10", CZ_TIMEZONE := "ChST"]

# AKST-9 to AKST
details[CZ_TIMEZONE == "AKST-9", CZ_TIMEZONE := "AKST"]
# AST-4 to AST
details[CZ_TIMEZONE == "AST-4", CZ_TIMEZONE := "AST"]
# CST-6 to CST
details[CZ_TIMEZONE == "CST-6", CZ_TIMEZONE := "CST"]
# EST-5 to EST
details[CZ_TIMEZONE == "EST-5", CZ_TIMEZONE := "EST"]
# HST-10 to HST
details[CZ_TIMEZONE == "HST-10", CZ_TIMEZONE := "HST"]
# MST-7 to MST
details[CZ_TIMEZONE == "MST-7", CZ_TIMEZONE := "MST"]
# PST-8 to PST
details[CZ_TIMEZONE == "PST-8", CZ_TIMEZONE := "PST"]
# SST-11 to SST
details[CZ_TIMEZONE == "SST-11", CZ_TIMEZONE := "SST"]

details[CZ_TIMEZONE == "CDT", CZ_TIMEZONE := "CST"]
details[CZ_TIMEZONE == "EDT", CZ_TIMEZONE := "EST"]
details[CZ_TIMEZONE == "MDT", CZ_TIMEZONE := "MST"]
details[CZ_TIMEZONE == "PDT", CZ_TIMEZONE := "PST"]
