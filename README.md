# dbt Databricks Data Vault

A practical Data Vault 2.0 implementation built with dbt and Databricks using NYC Taxi trip data.

## Project Overview

This project demonstrates how raw taxi data can be transformed into a scalable Data Vault model using dbt.

The pipeline includes:

- Staging and data standardization
- Hash key generation
- Hashdiff calculation
- Incremental loading
- Hubs, Links, and Satellites
- PIT and status-tracking tables
- dbt model lineage

## Architecture
## Main Models

### Staging

- `stg_taxi_rides`

### Hubs

- `hub_vendor`
- `hub_destination`

### Links

- `link_trip_connection`

### Satellites

- `sat_link_trip`

### Supporting Models

- `sts_link_trip`
- `pit_taxi_trip`

## Technologies

- dbt
- Databricks
- SQL
- Data Vault 2.0
- GitHub

## Running the Project

Run all models:

```bash
dbt run
```

Run the tests:

```bash
dbt test
```

Build and test the complete project:

```bash
dbt build
```

## Purpose

The purpose of this project is to demonstrate a practical and maintainable implementation of Data Vault 2.0 concepts with dbt and Databricks.
