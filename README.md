# Animated-Movies-DEA 🎞🎟🎫
Data Exploration Analysis from an animated movies dataset. The data has a total of 85 rows with some NULLs.

## Part 1. SQL Exploration and Analysis
### Data Cleaning and Transforming
Although the dataset can be considered as small, several transformations and cleaning steps were done to use it.
#### Transformations 🚧
- Convert the `Rating` column into only one decimal.
- Convert the `Gross in Millions` column into an only numeric datatype, take out the string characters.
- Convert the `Runtime` column into an only numeric datatype.
  - Split the `Runtime` into `RuntimeHour` and `RuntimeMinutes`
- Split the `Genre` column into Main and Secondary columns.
  - Trim both columns generated.
- Drop the `Description` column as there is no analysis to be done with it.

#### Handle of NULLs 🧼
Before doing any analysis, we need to know the consistency by the number of NULLs in our data, according to it we can consider leaving the original values, filling values, dropping rows, etc.
- In `GrossInM` column, we have 35 NULLs out of 85 records, so in this case filling it out with average or dropping the rows can't be a good idea. We leave all the original values.
- In `Metascore` column, we only have 5 NULLs, in this case we filled it with the average of the result set.

### Analysis of the Data 🧐
Hello, this part is missing `only in this readme` I will try to do it ASAP, although you can check the queries that *already have information*.
## Part 2. R Plots
Hello, this part is missing, I will try to do it ASAP.
<!-- `-->

