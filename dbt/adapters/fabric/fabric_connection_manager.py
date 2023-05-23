import datetime
from typing import Optional, Any, Tuple

from dbt.adapters.sqlserver import SQLServerConnectionManager
from pyodbc import Connection


class FabricConnectionManager(SQLServerConnectionManager):
    TYPE = "fabric"

    def add_query(self, sql: str, auto_begin: bool = True, bindings: Optional[Any] = None,
                  abridge_sql_log: bool = False) -> Tuple[Connection, Any]:
        if bindings:
            bindings = [binding if not isinstance(binding, datetime.datetime) else binding.isoformat() for binding in bindings]
        return super().add_query(sql, auto_begin, bindings, abridge_sql_log)
