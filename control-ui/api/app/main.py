import json
import logging
import sys
from datetime import timedelta
from pathlib import Path
from typing import List
from fastapi import Depends
from fastapi.logger import logger
from fastapi.middleware.cors import CORSMiddleware