import os

import pytest
from _pytest.fixtures import FixtureRequest

pytest_plugins = ["dbt.tests.fixtures.project"]


def pytest_addoption(parser):
    parser.addoption(
        "--profile", action="store", default=os.getenv("PROFILE_NAME", "user"), type=str
    )


@pytest.fixture(scope="class")
def dbt_profile_target(request: FixtureRequest, dbt_profile_target_update):
    profile = request.config.getoption("--profile")

    if profile == "ci":
        target = _profile_ci()
    elif profile == "user":
        target = _profile_user()
    else:
        raise ValueError(f"Unknown profile: {profile}")

    target.update(dbt_profile_target_update)
    return target


@pytest.fixture(scope="class")
def dbt_profile_target_update():
    return {}


def _all_profiles_base():
    return {
        "type": "fabric",
        "driver": os.getenv("FABRIC_TEST_DRIVER", "ODBC Driver 18 for SQL Server"),
        "port": int(os.getenv("FABRIC_TEST_PORT", "1433")),
        "host": os.getenv("FABRIC_TEST_HOST"),
        "database": os.getenv("FABRIC_TEST_DB"),
        "retries": 0,
        "threads": 1,
        "encrypt": True,
        "trust_cert": True,
        "authentication": os.getenv("FABRIC_TEST_AUTH", "auto"),
        "client_id": os.getenv("FABRIC_TEST_CLIENT_ID"),
        "client_secret": os.getenv("FABRIC_TEST_CLIENT_SECRET"),
        "tenant_id": os.getenv("FABRIC_TEST_TENANT_ID"),
    }


def _profile_ci():
    return {
        **_all_profiles_base(),
        **{},
    }


def _profile_user():
    profile = {
        **_all_profiles_base(),
        **{},
    }
    return profile


@pytest.fixture(autouse=True)
def skip_by_profile_type(request: FixtureRequest):
    profile_type = request.config.getoption("--profile")

    if request.node.get_closest_marker("skip_profile"):
        if profile_type in request.node.get_closest_marker("skip_profile").args:
            pytest.skip(f"Skipped on '{profile_type}' profile")

    if request.node.get_closest_marker("only_with_profile"):
        if profile_type not in request.node.get_closest_marker("only_with_profile").args:
            pytest.skip(f"Skipped on '{profile_type}' profile")
