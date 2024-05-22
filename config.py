from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
    
application = Flask(__name__)
app=application
Base = declarative_base()
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql+psycopg2://yemibalogun:mocalate@localhost/medical_record"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'yemi_balogun'
app.config['UPLOAD_FOLDER'] = 'static/images'

# Initialize SQLAlchemy object
db = SQLAlchemy(app, session_options={"expire_on_commit": False})

# Create the engine for PostgreSQL
engine = create_engine(app.config["SQLALCHEMY_DATABASE_URI"])

# Create tables in PostgreSQL
Base.metadata.create_all(engine)

# Bind the PostgreSQL engine to the sessionmaker
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create a session object for PostgreSQL
session = SessionLocal()

