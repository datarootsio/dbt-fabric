from typing import ClassVar, Dict

from dbt.adapters.sqlserver import SQLServerColumn


class FabricColumn(SQLServerColumn):
    TYPE_LABELS: ClassVar[Dict[str, str]] = {
        "STRING": "VARCHAR(MAX)",
        "TIMESTAMP": "DATETIME2(6)",
        "FLOAT": "FLOAT",
        "INTEGER": "INT",
        "BOOLEAN": "BIT",
    }
