"""
Pytest configuration and shared fixtures for PySpark tests.
"""

import pytest
from pyspark.sql import SparkSession


@pytest.fixture(scope="session")
def spark() -> SparkSession:
    """
    Create a SparkSession for testing.

    Uses session scope to reuse the same Spark context across all tests,
    which significantly speeds up test execution.
    """
    spark = (
        SparkSession.builder.appName("pytest-pyspark")
        .master("local[2]")
        .config("spark.sql.shuffle.partitions", "2")
        .config("spark.ui.enabled", "false")
        .config("spark.driver.memory", "1g")
        .getOrCreate()
    )

    spark.sparkContext.setLogLevel("WARN")

    yield spark

    spark.stop()


@pytest.fixture(scope="session")
def sc(spark: SparkSession):
    """Get SparkContext from the SparkSession fixture."""
    return spark.sparkContext
