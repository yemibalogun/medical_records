from sqlalchemy import  Column, String, Integer, ForeignKey, Float, Enum, Table, MetaData, Date
from sqlalchemy.orm import relationship
from config import db, app
from datetime import datetime, date
from flask_migrate import Migrate

metadata = MetaData()
migrate = Migrate(app, db)


score_table = Table('score_table', metadata,
    Column('first_semester_score', Float, default=0.0),
    Column('second_semester_score', Float, default=0.0),
    Column('academic_year', Integer, default=lambda: datetime.now().year if datetime.now().month >= 9 else datetime.now().year - 1),
    Column('course_id', Integer, ForeignKey('courses.id')),
    Column('cadet_id', Integer, ForeignKey('cadets.id'))
)


class Score(db.Model):
    __tablename__ = "scores"

    id = Column(Integer, primary_key=True)
    first_semester_score = Column(Float, default=0.0)
    second_semester_score = Column(Float, default=0.0)
    academic_year = Column(Integer, default=lambda: datetime.now().year if datetime.now().month >= 9 else datetime.now().year - 1)

    course_id = Column(Integer, ForeignKey('courses.id'))
    course = relationship('Course', back_populates='scores')

    cadet_id = Column(Integer, ForeignKey('cadets.id'))
    cadet = relationship('Cadet', back_populates='scores')

    def __repr__(self):
        return f"({self.id} {self.first_semester_score} {self.second_semester_score} {self.academic_year} {self.course_id} {self.cadet_id})"


class Course(db.Model):
    __tablename__="courses"
    
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    course_code = Column("course_code", String(10))
    course_title = Column("course_title", String(255), nullable=False)
    units = Column("units", Integer, nullable=False)
    status = Column(Enum('core', 'elective'), nullable=False) # Enum for course status (Core or Elective)

    department_id = Column("department_id", ForeignKey('departments.id'), nullable=False)
    department = relationship('Department', back_populates='courses')

    scores = relationship("Score", back_populates='course', uselist=False)
    cadet_id = Column(Integer, ForeignKey("cadets.id"))
    cadet = relationship("Cadet", back_populates="courses")
    def __repr__(self):
        return f"({self.course_code} {self.course_title} {self.units} {self.status})"


class RegularCourse(db.Model):
    __tablename__="regular_courses"

    id = Column("id", Integer, primary_key=True)
    course_no = Column("course_no", Integer, nullable=False)
    cadet = relationship('Cadet', back_populates='regular_course')

    def __repr__(self):
        return f"({self.id} {self.course_no})"

class Faculty(db.Model):
    __tablename__="faculties"

    id = Column("id", Integer, primary_key=True)
    faculty_name = Column("faculty_name", String, nullable=False)
    departments = relationship('Department', back_populates='faculty')

    def __repr__(self):
        return f"({self.id} {self.faculty_name})"


class Department(db.Model):
    __tablename__="departments"

    id = Column("id", Integer, primary_key=True)
    department_name = Column("department_name", String, nullable=False)
    faculty_id = Column("faculty_id", ForeignKey('faculties.id'), nullable=False)
    faculty = relationship('Faculty', back_populates='departments')
    cadets = relationship('Cadet', back_populates='department')

    courses = relationship('Course', back_populates='department')

    def __repr__(self):
        return f"({self.id} {self.department_name} {self.faculty_id})"

    
class Gender(db.Model):
    __tablename__="genders"
        
    id = Column("id", Integer, primary_key=True)
    gender_type = Column("gender_type", String, nullable=False)
    cadet = relationship('Cadet', back_populates='gender')
    
    def __repr__(self):
        return f"({self.id} {self.gender_type})"


class Battalion(db.Model):
    __tablename__="battalions"

    id = Column("id", Integer, primary_key=True, autoincrement=True)
    bn = Column("bn", String, nullable=False)
    cadet = relationship('Cadet', back_populates='bn')

    def __repr__(self):
        return f"({self.id} {self.bn})"
    

class Medical(db.Model):
    __tablename__="medicals"

    id = Column("id", Integer, primary_key=True, autoincrement=True)
    date_reported_sick = Column("date_reported_sick", Date, nullable=False, default=date.today)
    diagnosis = Column("diagnosis", String, nullable=False)
    excuse_duty_type = Column("excuse_duty", String, nullable=False)
    excuse_duty_days = Column("days", Integer, nullable=False)
    admitted = Column("admitted", String, nullable=False, default='no')
    discharged = Column("discharged", String, nullable=False, default='no')
    # relationship
    cadet_id = Column(Integer, ForeignKey("cadets.id"))
    cadet = relationship("Cadet", back_populates="medical")

    def __repr__(self):
        return f"({self.id} {self.date_reported_sick} {self.diagnosis} {self.excuse_duty_type} {self.excuse_duty_days} {self.admitted} {self.discharged})"

class Service(db.Model):
    __tablename__="services"

    id = Column('id', Integer, primary_key=True)
    service_type = Column('service_type', String, nullable=False)
    service_subjects = relationship('ServiceSubject', back_populates='service')

    cadet = relationship('Cadet', back_populates='service')

    def __repr__(self):
        return f"({self.id} {self.service_type})"


class ServiceSubject(db.Model):
    __tablename__="service_subjects"
    
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    subject_code = Column("subject_code", String(10))
    subject_title = Column("subject_title", String(255), nullable=False)
    status = Column(Enum('major', 'minor', 'tour', 'camp'), nullable=False) # Enum for course status (major or minor)

    service_id = Column("service_id", ForeignKey('services.id'))
    service = relationship('Service', back_populates='service_subjects')

    service_score = relationship("ServiceScore", back_populates='service_subject', uselist=False)

    def __repr__(self):
        return f"({self.subject_code} {self.subject_title} {self.status})"

service_score_table = Table('service_score_table', metadata,
    Column('first_term_score', Float, default=0.0),
    Column('second_term_score', Float, default=0.0),
    Column('service_year', Integer, default=lambda: datetime.now().year if datetime.now().month >= 9 else datetime.now().year - 1),
    Column('subject_id', Integer, ForeignKey('service_subjects.id')),
    Column('cadet_id', Integer, ForeignKey('cadets.id'))
)

class ServiceScore(db.Model):
    __tablename__ = "service_scores"

    id = Column(Integer, primary_key=True)
    first_term_score = Column(Float, default=0.0)
    second_term_score = Column(Float, default=0.0)
    service_year = Column(Integer, default=lambda: datetime.now().year if datetime.now().month >= 9 else datetime.now().year - 1)

    service_subject_id = Column(Integer, ForeignKey('service_subjects.id'))
    service_subject = relationship('ServiceSubject', back_populates='service_score')

    cadet_id = Column(Integer, ForeignKey('cadets.id'))
    cadet = relationship('Cadet', back_populates='service_scores')

    def __repr__(self):
        return f"({self.id} {self.first_term_score} {self.second_term_score} {self.service_year} {self.service_subject_id} {self.cadet_id})"

        
class Cadet(db.Model):
    __tablename__= "cadets"
    
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    cadet_no = Column("cadet_no", String, unique=True, nullable=False)
    first_name = Column("first_name", String, nullable=False)
    middle_name = Column("middle_name", String, nullable=True)
    last_name = Column("last_name", String, nullable=False)
    religion = Column("religion", String, nullable=False)
    state = Column("state", String, nullable=False)
    lga = Column("lga", String, nullable=False)
    date_of_enlistment = Column("date_of_enlistment", String, nullable=False)
    date_of_birth = Column("date_of_birth", String, nullable=False)
    department_id = Column('department_id', ForeignKey('departments.id'), nullable=False)
    department = relationship('Department', back_populates='cadets')
    bn_id = Column("bn_id", ForeignKey('battalions.id'), nullable=False)
    bn = relationship('Battalion', back_populates='cadet')
    gender_id = Column("gender_id", ForeignKey('genders.id'), nullable=False)
    gender = relationship('Gender', back_populates='cadet')
    service_id = Column("service_id", ForeignKey('services.id'), nullable=False)
    service = relationship('Service', back_populates='cadet')
    regular_id = Column("regular_id", ForeignKey('regular_courses.id'), nullable=False)
    regular_course = relationship('RegularCourse', back_populates='cadet')
    medical = relationship('Medical', back_populates='cadet')

    # Add CGPA column
    cgpa = Column(Float, default=0.0)

    # Establish relationships with Score and ServiceScore tables
    scores = relationship("Score", back_populates='cadet', uselist=False)
    service_scores = relationship("ServiceScore", back_populates='cadet', uselist=False)

    courses = relationship("Course", back_populates="cadet")

    @property
    def total_units(self):
        # Calculate total units based on related models or other criteria
        return sum([course.units for course in self.courses])

    def __repr__(self):
        return f"({self.id} {self.cadet_no} {self.first_name} {self.middle_name} {self.last_name} {self.religion} {self.state} {self.lga} {self.date_of_enlistment} {self.date_of_birth} {self.department_id} {self.bn_id} {self.gender_id} {self.service_id} {self.regular_id})"


# Create the database tables (if they don't exist)
with app.app_context():
    db.create_all()