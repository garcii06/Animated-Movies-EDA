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
Talking about the Analysis, I will only recap the *interesting* things to notice in this section. General or overall panorama won't be shared in the read but is available in the queries file.
- 77 out of 85 movies have a duration of less than two hours.
- Short movies are define as movies between 1:00 and 1:30 hours.
- Long movies are define as movies between 1:31 and less than 2:00 hours.

#### GROSS IN MILLIONS
- There are only 46 of the 77 movies with gross registered.
- Movies with a duration between 1:30 and 2:00 hours have a greater gross.

#### RATING
- The average rating for long and short movies.
- If we include ties in rating, then all the movies between 1 and less than 2 hours, can be ranked in the top 10.

#### METASCORE
- The critic is more rigorous in the way they give a score.
- Including ties, only 25 movies enter the top 10.
 - Critics prefer longer movies, but only two of them are in the top 10 without ties. They are the first and second place.
 
#### OTHERS
- The analysis also includes topics like the general panorama, the genre and analysis by Director. All of them are in the sql file.
- Most of the gross come from the States, those who are anime-Japanese or productions of the States have a lower representation and lower gross.
 - This can be due to a lower currency exchange.
 - Not taking the global gross just domestic.
 
## Part 2. R Plots
Hello, this part is missing, I will try to do it ASAP.
<!-- `-->

