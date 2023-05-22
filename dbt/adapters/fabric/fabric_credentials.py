from dataclasses import dataclass

from dbt.adapters.sqlserver import SQLServerCredentials


@dataclass
class FabricCredentials(SQLServerCredentials):
    @property
    def type(self):
        return "fabric"
