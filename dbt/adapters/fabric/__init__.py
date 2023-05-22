from dbt.adapters.base import AdapterPlugin

from dbt.adapters.fabric.fabric_adapter import FabricAdapter
from dbt.adapters.fabric.fabric_connection_manager import FabricConnectionManager
from dbt.adapters.fabric.fabric_credentials import FabricCredentials
from dbt.include import fabric

Plugin = AdapterPlugin(
    adapter=FabricAdapter,
    credentials=FabricCredentials,
    include_path=fabric.PACKAGE_PATH,
    dependencies=["sqlserver"],
)

__all__ = [
    "Plugin",
    "FabricConnectionManager",
    "FabricAdapter",
    "FabricCredentials",
]
