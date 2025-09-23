import glob
import os
import sys

import setuptools

if sys.platform == "win32" or os.getenv("SYS_PLATFORM") == "win32":
    data_files = [("Scripts", glob.glob("bin/*.exe"))]
else:
    data_files = [("bin", glob.glob("bin/*"))]

setuptools.setup(data_files=data_files)
