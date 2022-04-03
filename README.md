# Startcart Recommendation System
### Project Introduction

```bash
The project is to create an ETL process to sync the data from a Mysql transactional database into
a Redshift data warehouse. The data comes from an Brazilian E-commerce company called Olist.
The Aws components involved in this project are RDS, Redshift, Glue, Lambda, Data Pipeline, Quicksight,
etc. I use Star schema for dimensional modeling of the data warehouse. I use Dbeaver to connect both
the RDS instance and the Redshift cluster.

The first step of the mechanism is to use Data Pipeline to establish connection with RDS Mysql database 
and pull the transactional data as csv file formats, which will be saved in S3. Then I implement both 
initial ETL and incremental ETL to load the data from S3 into Redshift data warehouse. For the historical
data, I write SQL queries to load them directly into the data warehouse. For the incremental data, I use 
lambda function, event trigger and glue job with python shell script to automatically perfrom ETL and
load data on a periodic basis.
```

### ER Diagram

![ER-diagram](https://user-images.githubusercontent.com/31687491/161413393-4a775ced-fc7a-4bc5-96cc-8b5fd52e292d.png)


### Project Architecture

![project-architecture](https://user-images.githubusercontent.com/31687491/161413563-e758bd78-843a-45a3-96bf-678533a58b7e.png)



