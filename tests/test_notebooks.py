"""
Notebook execution tests.

Validates that all Jupyter notebooks in the notebooks/ directory
can be executed without errors.
"""

import glob
import os

import nbformat
import pytest
from nbconvert.preprocessors import ExecutePreprocessor

NOTEBOOKS_DIR = os.path.join(os.path.dirname(__file__), "..", "notebooks")
NOTEBOOK_FILES = sorted(glob.glob(os.path.join(NOTEBOOKS_DIR, "*.ipynb")))
NOTEBOOK_IDS = [os.path.basename(nb) for nb in NOTEBOOK_FILES]


@pytest.mark.parametrize("notebook_path", NOTEBOOK_FILES, ids=NOTEBOOK_IDS)
def test_notebook_execution(notebook_path: str) -> None:
    """Execute a notebook and verify no cells raise exceptions."""
    with open(notebook_path) as f:
        nb = nbformat.read(f, as_version=4)

    ep = ExecutePreprocessor(timeout=300, kernel_name="python3")

    ep.preprocess(nb, {"metadata": {"path": NOTEBOOKS_DIR}})
