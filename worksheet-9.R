# Worksheet for SQLite lesson

# First you will need to copy the portal.sqlite file
# to your own workspace so that your changes to the file
# will not affect everyone else in the class!

file.copy('data/portal.sqlite', 'myportal.sqlite')

library(RSQLite)

# Create a connection object
con <- dbConnect(RSQLite::SQLite(), "myportal.sqlite")

#to view contents
dbListTables(con)
dbListFields(con, 'species')

# Read a table
#dbReadTable() or
library(dplyr)

species <- tbl(con, 'species')

## type species in console to view table

# Upload a new table
df <- data.frame(
  id = c(1, 2),
  name = c('Alice', 'Bob')
)

dbWriteTable(con, 'observers', df)

# remove existing observers table
dbRemoveTable(con, 'observers') 

# Recreate observers table

dbCreateTable(con, 'observers', list(
  id = 'integer primary key',
  name = 'text'
))

# add data to observers table
# with auto-generated id

df <- data.frame(
  name = c('Alice', 'Bob')
)

dbWriteTable(con, 'observers', df, append = TRUE)
##enter dbReadTable(con, 'observers') to view

# Try adding a new observer with existing id
##should work because id = 1 already used (for Alice) see dbReadTable result
df <- data.frame(
  id = c(1),
  name = c('J. Doe')
)

dbWriteTable(con, 'observers', df,
             append = TRUE)

# Try violating foreign key constraint
##this will fail because plot_id = Rodent is not found in table
dbExecute(con, 'PRAGMA foreign_keys = ON;')

df <- data.frame(
  month = 7,
  day = 16,
  year = 1977,
  plot_id = 'Rodent'
)

dbWriteTable(con, 'surveys', df,
             append = TRUE)

# Queries
# basic queries
...(con, "... year ... surveys")

dbGetQuery(con, "SELECT ... FROM ...")

dbGetQuery(con, "...
FROM surveys")

# limit query response
dbGetQuery(con, "SELECT year, species_id
FROM surveys
...")

# get only unique values
dbGetQuery(con, "SELECT ... species_id
FROM surveys")

dbGetQuery(con, "SELECT ...
FROM surveys")

# perform calculations 
dbGetQuery(con, "SELECT plot_id, species_id,
  sex, ...
FROM surveys")

dbGetQuery(con, "SELECT plot_id, species_id, sex,
  weight / 1000 ...
FROM surveys")

dbGetQuery(con, "SELECT plot_id, species_id, sex,
  ...
FROM surveys")

# filtering
# hint: use alternating single or double quotes to 
# include a character string within another
dbGetQuery(con, "SELECT *
FROM surveys
... species_id ...")

dbGetQuery(con, "SELECT *
FROM surveys
... year ...")

dbGetQuery(con, "SELECT *
FROM surveys
... year ... species_id ...")

dbGetQuery(con, "SELECT *
FROM surveys
WHERE ...
  ... species_id = 'DM'")

# Joins
# one to many 
dbGetQuery(con, "SELECT weight, plot_type
FROM surveys
...
  ... = ...")

# many to many
dbGetQuery(con, "SELECT weight, genus, plot_type
FROM surveys
... plots
  ON ...
... species
  ON ...")

