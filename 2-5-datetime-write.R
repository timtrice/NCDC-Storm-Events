# Write final dataset

# CSV
write.csv(final, "data/clean-details.csv", row.names = FALSE)

# RDS
saveRDS(final, "data/clean-details.rds")
