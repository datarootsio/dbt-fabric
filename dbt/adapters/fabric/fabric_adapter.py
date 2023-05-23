from dbt.adapters.sqlserver import SQLServerAdapter

from dbt.adapters.fabric.fabric_column import FabricColumn
from dbt.adapters.fabric.fabric_connection_manager import FabricConnectionManager


class FabricAdapter(SQLServerAdapter):
    ConnectionManager = FabricConnectionManager
    Column = FabricColumn

    @classmethod
    def convert_datetime_type(cls, agate_table, col_idx):
        return "datetime2(6)"

    @classmethod
    def convert_time_type(cls, agate_table, col_idx):
        return "time(6)"
