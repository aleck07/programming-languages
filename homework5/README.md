# Homework 5 

**Name:** Alec Krsek

**Date:** May 21, 2026

## Description

This assignment implements a volcano data processing program in Erlang. The program defines a `volcano` ADT with fields for name, elevation, last eruption year, and hazard level. It includes the following functions:

- **`new_volcano/4`** — creates a volcano tuple from name, elevation, last eruption year, and hazard level
- **`name/1`** — returns the name of a volcano
- **`elevation/1`** — returns the elevation of a volcano
- **`last_eruption/1`** — returns the last eruption year of a volcano
- **`hazard/1`** — returns the hazard level of a volcano
- **`load_volcanoes/1`** — reads a CSV file and parses each line into a volcano tuple
- **`erupted_since/2`** —  returns a list of volcanoes erupted since a given year.
- **`total_elevation/1`** — sums the elevation of given volcano list
- **`sort_by_elevation/1`** — sorts a list of volcanoes in ascending order by elevation (insertion sort)
- **`main/0`** — loads `hw5_data.csv` and prints the results of each operation

## Citations
No external sources and no AI was used.