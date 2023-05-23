# dbt-fabric

dbt adapter for Microsoft Fabric Data Warehouses

Note that this is not an official adapter.
As mentioned in [the docs](https://learn.microsoft.com/en-us/fabric/data-warehouse/connectivity#connect-using-dbt) Microsoft will release an official adapter.

## Current state

This adapter is in a very early phase as the Fabric DWH is also still very new and lacks some T-SQL syntax.
Star the repo to follow along as we continue to develop this adapter.

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
