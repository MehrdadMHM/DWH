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

```text
NYC Taxi Source
       ↓
Staging Layer
       ↓
Data Vault Layer
       ├── Hubs
       ├── Links
       ├── Satellites
       ├── Status Tracking
       └── PIT Tables
