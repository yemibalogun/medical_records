from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import declarative_base, sessionmaker
from dotenv import load_dotenv
import os

load_dotenv()

# Access your environment variables
secret_key = os.getenv('SECRET_KEY')
debug_mode = os.getenv('DEBUG')
db_url = os.getenv('DATABASE_URL')
    
application = Flask(__name__)
app=application
Base = declarative_base()
app.config["SQLALCHEMY_DATABASE_URI"] = db_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = secret_key
app.config['UPLOAD_FOLDER'] = 'static/images'
app.config['DEBUG'] = debug_mode

# Initialize SQLAlchemy object
db = SQLAlchemy(app, session_options={"expire_on_commit": False})

# Create the engine for PostgreSQL
engine = create_engine(app.config["SQLALCHEMY_DATABASE_URI"])

metadata = MetaData()

# Create tables in PostgreSQL
Base.metadata.create_all(engine)

# Bind the PostgreSQL engine to the sessionmaker
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create a session object for PostgreSQL
session = SessionLocal()

