library(tidyverse)
library(readr)
library(dplyr)
library(janitor)

## Load Data
household_income <- read.csv("data/income/ACSST5Y2022.S2001-Data.csv")
education <- read.csv("data/education/ACSST5Y2022.S1501-Data.csv")
voting_population <- read.csv("data/population/ACSDP5Y2022.DP05-Data.csv")
ballot_count <- read.csv("data/ballots-counted-nc-counties.csv")
local_news <- read.csv("data/local-news-data.csv")

#Clean Data
household_income <- household_income|>
  select(NAME, S2001_C01_014E) |>
  slice(-1:-2) |>
  mutate(NAME  = gsub(", North Carolina", "", NAME))|>
  rename("County" = NAME, Mean_Earnings = S2001_C01_014E)

voting_population <- voting_population |>
  select(NAME, DP05_0021E) |>
  slice(0:-1) |>
  mutate(NAME  = gsub(", North Carolina", "", NAME)) |>
  rename("County" = NAME, Eligible_Population = DP05_0021E)

education <- education |>
  slice(0:-1) |>
  mutate(
    NAME  = gsub(", North Carolina", "", NAME),
    HS_Graduation_Rate = (as.numeric(S1501_C01_003E) + as.numeric(S1501_C01_004E) + 
      as.numeric(S1501_C01_005E) + as.numeric(S1501_C01_014E)) / 
      (as.numeric(S1501_C01_001E) + as.numeric(S1501_C01_006E))
  ) |>
  rename("County" = NAME) |>
  select(County, HS_Graduation_Rate)

ballot_count <- ballot_count |> 
  mutate(across(where(is.character), ~ gsub("\u00A0", " ", .))) |>
  rename(Counted_Ballots = Counted.Ballots)

local_news <- local_news |> 
  mutate(across(where(is.character), ~ gsub("\u00A0", " ", .))) |>
  rename(Local_News_Outlets = Local.News.Outlets)

#Join Data
data_list <- list(education, ballot_count, local_news, voting_population, household_income)
data <- reduce(data_list, full_join, by = "County")

regression_data <- write.csv(data, "data/regression-data.csv")