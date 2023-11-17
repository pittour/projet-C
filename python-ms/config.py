import os
from decouple import config
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
# SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(BASE_DIR, 'app.db')
SQLALCHEMY_DATABASE_URI = (
    "mysql+pymysql://"
    f"{config('DATABASE_USER')}:{config('DATABASE_USER_PASS')}@"
    f"{config('DATABASE_HOST')}/{config('DATABASE_NAME')}"
)
SQLALCHEMY_TRACK_MODIFICATIONS = False

DRUPAL_API_USER = config('DRUPAL_API_USER')
DRUPAL_API_PASS = config('DRUPAL_API_PASS')
HEADERS = {
    "Content-Type": "application/vnd.api+json",
    "Accept": "application/vnd.api+json",
}

# CACHE_TYPE = 'redis'
# CACHE_DEFAULT_TIMEOUT = 300 # 5 minutes, ajustez selon vos besoins
# CACHE_REDIS_URL = 'redis://localhost:6379/0'
