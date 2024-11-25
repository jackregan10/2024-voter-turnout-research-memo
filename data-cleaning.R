library(tidyverse)
library(readr)
library(dplyr)

## Load Data
household_income <- read.csv("data/income/ACSST5Y2022.S2001-Data.csv")
education <- read.csv("data/education/ACSST5Y2022.S1501-Data.csv")
voting_population <- read.csv("data/population/ACSDP5Y2022.DP05-Data.csv")



##Clean Data
household_income <- household_income|>
  select(NAME, S2001_C01_014E) |>
  slice(0:-1) |>
  mutate(NAME  = gsub(", North Carolina", "", NAME)) |>
  rename(County = NAME, Mean_Earnings = S2001_C01_014E)

voting_population <- voting_population |>
  select(NAME, DP05_0021E) |>
  slice(0:-1) |>
  mutate(NAME  = gsub(", North Carolina", "", NAME)) |>
  rename(County = NAME, Eligible_Population = DP05_0021E)

education <- education |>
  slice(0:-1) |>
  mutate(
    NAME  = gsub(", North Carolina", "", NAME),
    HS_Graduation_Rate = (as.numeric(S1501_C01_003E) + as.numeric(S1501_C01_004E) + 
      as.numeric(S1501_C01_005E) + as.numeric(S1501_C01_014E)) / 
      (as.numeric(S1501_C01_001E) + as.numeric(S1501_C01_006E))
  ) |>
  rename(County = NAME) |>
  select(County, HS_Graduation_Rate)
