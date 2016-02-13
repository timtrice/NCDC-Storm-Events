## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(collapse = TRUE, 
                      comment = "#>", 
                      fig.width = 7)
library(NCDCStormEvents)

## ------------------------------------------------------------------------
ds_list <- get_listings()

## ---- fig.height = 5, fig.cap = "Details, Fatalities and Locations by Year, Size"----
library(ggplot2)

base_plot <- list( 
    geom_bar(stat = "identity", position = position_dodge()), 
    facet_grid(Type ~ ., scales = "free_y"), 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5)), 
    scale_fill_discrete(name = "Type"), 
    xlab("Year"))

ggplot(ds_list, aes(x = factor(Year), y = Size, fill = factor(Type))) + 
    scale_y_continuous(label = function(x){x * 10^-6}) + 
    ggtitle("Details, Fatalities and Locations by Year, Size") + 
    ylab("Size (MB)") + 
    base_plot

## ---- fig.height = 5, fig.cap = "Details, Fatalities and Locations by Year (1950-1995), Size"----
tmp <- ds_list[Year <= 1995,]

ggplot(tmp, aes(x = factor(Year), y = Size, fill = factor(Type))) + 
    scale_y_continuous(label = function(x){x * 10^-3}) + 
    ggtitle("Details, Fatalities and Locations by Year (1950-1995), Size") + 
    ylab("Size (KB)") + 
    base_plot

## ------------------------------------------------------------------------
year <- 1950
type <- "details"

x <- ds_list[Year == year & Type == type, Size]

