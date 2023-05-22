# dbt-fabric

dbt adapter for Microsoft Fabric Data Warehouses

## Current state

The following features have been identified to not be functional:

* Everything related to the management of users and their permissions
* Seeds

This list is probably incomplete.

## Installation

```bash
pip install git+https://github.com/datarootsio/dbt-fabric.git@main
```

## Documentation & configuration

The documentation is the same as for [dbt-sqlserver](https://github.com/dbt-msft/dbt-sqlserver).
You can only use `cli` or `auto` for authentication.
