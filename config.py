from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker


application = Flask(__name__)
app=application

Base = declarative_base()
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///cadetdb.db"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'yemi_balogun'
app.config['UPLOAD_FOLDER'] = 'static/images'

# Initialize SQLAlchemy object
db = SQLAlchemy(app, session_options={"expire_on_commit": False})

# Create the engine with the timeout setting
engine = create_engine("sqlite:///cadetdb.db", connect_args={"timeout": 30})

# Create tables
Base.metadata.create_all(engine)

# Bind the engine to the sessionmaker
Session = sessionmaker(bind=engine)

# Create a session object
session = Session()

