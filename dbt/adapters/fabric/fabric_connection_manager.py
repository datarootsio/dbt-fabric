from dbt.adapters.sqlserver import SQLServerConnectionManager


class FabricConnectionManager(SQLServerConnectionManager):
    TYPE = "fabric"
