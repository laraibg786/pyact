import os
import subprocess
import sys


def main() -> None:
    result = subprocess.run(
        [os.path.dirname(__file__) + "/act"] + sys.argv[1:],
        stdout=sys.stdout,
        stderr=sys.stderr,
    )
    sys.exit(result.returncode)
