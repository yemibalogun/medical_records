from sqlalchemy import  Column, String, Integer, ForeignKey, Float, Enum, Table, MetaData, Date, func, event, create_engine
from sqlalchemy.orm import relationship, validates
from sqlalchemy.exc import IntegrityError
from config import db, app # Importing from config.py
from datetime import datetime, date
from flask_migrate import Migrate
from flask_login import UserMixin
import uuid

metadata = MetaData()
migrate = Migrate(app, db)


class RegularCourse(db.Model):
    __tablename__="regular_courses"

    id = Column("id", Integer, primary_key=True)
    course_no = Column("course_no", Integer, nullable=False)
    cadet = relationship('Cadet', back_populates='regular_course')

    def __repr__(self):
        return f"({self.id} {self.course_no})"

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
    staff = relationship('Staff', back_populates='gender')
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
    __tablename__ = "medicals"

    id = Column(Integer, primary_key=True, autoincrement=True)
    date_reported_sick = Column(Date, nullable=False, default=func.now())
    history = Column(String, nullable=False)
    examination = Column(String, nullable=False)
    diagnosis = Column(String, nullable=False)
    plan = Column(String, nullable=False)
    prescription = Column(String, nullable=False)
    prescription_status = Column(String(50), nullable=False, default='waiting') 
    excuse_duty = Column(String, nullable=False)
    excuse_duty_days = Column(Integer, nullable=True, default=0)
    admission_count = Column(Integer, nullable=False, default=0)
    
    cadet_id = Column(Integer, ForeignKey("cadets.id"))
    cadet = relationship("Cadet", back_populates="medical")

    @property
    def is_confinement(self):
        return self.excuse_duty == 'confinement'
    
    @property
    def confinement_days(self):
        if self.is_confinement:
            return self.excuse_duty_days
        return 0
    
    def update_cadet_board_status(self):
        if self.cadet:
            total_confinement_days = sum(med.confinement_days for med in self.cadet.medical)
            self.cadet.update_board_status(total_confinement_days)

    def save(self):
        try:
            db.session.add(self)
            db.session.commit()
            self.update_cadet_board_status()
        except IntegrityError:
            db.session.rollback()
            raise

    def update(self):
        try:
            db.session.commit()
            self.update_cadet_board_status()
        except IntegrityError:
            db.session.rollback()
            raise

    def __repr__(self):
        return (f"<Medical(id={self.id}, date_reported_sick={self.date_reported_sick}, "
                f"diagnosis={self.diagnosis}, prescription={self.prescription}, prescription_status={self.prescription_status}, excuse_duty={self.excuse_duty}, "
                f"excuse_duty_days={self.excuse_duty_days}, admission_count={self.admission_count})>")

class Service(db.Model):
    __tablename__="services"

    id = Column('id', Integer, primary_key=True)
    service_type = Column('service_type', String, nullable=False)
    service_subjects = relationship('ServiceSubject', back_populates='service')

    cadet = relationship('Cadet', back_populates='service')

    def __repr__(self):
        return f"({self.id} {self.service_type})"
    
class Visit(db.Model):
    __tablename__= "visits"

    id = Column("id", Integer, primary_key=True)
    cadet_id = Column(Integer, ForeignKey('cadets.id'), nullable=False)
    check_in_time = Column("check_in_time", Date, nullable=False, default=func.now())
    status = Column(String(50), nullable=False, default='waiting')  # 'waiting', 'in progress', 'completed'
    reason = db.Column(db.String(255), nullable=True)  # Reason for the visit
    doctor_id = db.Column(db.Integer, db.ForeignKey('staffs.staff_id'), nullable=True)  # Assigned doctor's ID
    
    cadet = relationship('Cadet', back_populates='visit')
    assigned_doctor = relationship('Staff', backref='assigned_visits', foreign_keys=[doctor_id])

    def __repr__(self):
        return f"({self.id} {self.cadet_id} {self.check_in_time} {self.status} {self.reason} {self.doctor_id} )"


class Staff(db.Model, UserMixin):
    __tablename__ = "staffs"

    staff_id = Column("staff_id", Integer, primary_key=True, autoincrement=True, nullable=False)
    firstname = Column("firstname", String(255), nullable=False)
    middlename = Column("middlename", String(255), nullable=True)
    lastname = Column("lastname", String(255), nullable=False)
    email = Column("email", String(255), nullable=False, unique=True)
    password = Column("password", String(255), nullable=False)
    phone = Column("phone", String(255), nullable=False, unique=True)
    address = Column("address", String(255), nullable=False)
    gender_id = Column("gender_id", ForeignKey('genders.id'), nullable=False)
    gender = relationship('Gender', back_populates='staff')
    role = Column('role', String(50), nullable=False) 
    status = Column('status', String(20), nullable=False) 
    appointment = Column("appointment", String(255), nullable=False)
    date_of_birth = Column("date_of_birth", Date, nullable=False)
    date_tos = Column("date_tos", Date, nullable=False)
    date_of_joining = Column("date_of_joining", Date, nullable=False, default=date.today())
    visit_id = Column("visit_id", Integer, ForeignKey('visits.id'), nullable=True)

    def get_id(self):
        return str(self.staff_id)
    
    def __repr__(self):
        return f"({self.staff_id} {self.firstname} {self.middlename} {self.lastname} {self.email} {self.password} {self.phone} {self.address} {self.gender_id} {self.role} {self.status} {self.appointment} {self.date_of_birth} {self.date_tos} {self.date_of_joining})"

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
    date_of_enlistment = Column("date_of_enlistment", Date, nullable=False)
    date_of_birth = Column("date_of_birth", Date, nullable=False)
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
    medical = relationship('Medical', back_populates='cadet', lazy='joined')
    admission_count = Column("admission_count", Integer, nullable=False, default=0)
    board_status = Column("board_status", String, default='')
    admission_date = Column(Date, nullable=True)  # New field for admission date
    visit = relationship('Visit', back_populates='cadet')

    @property
    def total_days(self):
        # Sum up the confinement days from all related Medical records
        confinement_days = sum(med.confinement_days for med in self.medical)
        return self.admission_count + confinement_days
    
    def update_board_status(self):
        print(f"Updating board status for Cadet {self.id}: total_days={self.total_days}")
        if self.total_days > 42:
            self.board_status = 'board'
        else:
            self.board_status = ''
        print(f"Board status for Cadet {self.id} set to: {self.board_status}")

    def set_admission_count(self, count):
        self.admission_count = count
        self.update_board_status(self.confinement_days)

    #   Initialize and update the board status
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.update_board_status(self.confinement_days)

    @classmethod
    def admit_cadets(cls, cadet_ids):
        cadets = cls.query.filter(cls.id.in_(cadet_ids)).all()
        for cadet in cadets:
            cadet.admission_count += 1
            cadet.admission_date = datetime.now().date()  # Set admission date
            cadet.update_board_status(cadet.confinement_days)

        db.session.commit()

    # Establish relationships with Score and ServiceScore tables
    scores = relationship("Score", back_populates='cadet', uselist=False)
    service_scores = relationship("ServiceScore", back_populates='cadet', uselist=False)

    courses = relationship("Course", back_populates="cadet")
    profile_picture = relationship('ProfilePicture', back_populates='cadet')

    @validates('admission_count')
    def validate_admission_count(self, key, admission_count):
        if admission_count < 0:
            raise ValueError('Admission count cannot be negative.')
        return admission_count

    def __repr__(self):
        return (f"{self.id}, {self.cadet_no}, {self.first_name}, "
                f"{self.middle_name}, {self.last_name}, "
                f"{self.religion}, {self.state}, {self.lga}, "
                f"{self.date_of_enlistment}, {self.date_of_birth}, "
                f"{self.department_id}, {self.bn_id}, {self.gender_id}, "
                f"{self.service_id}, {self.regular_id}, {self.admission_count})")


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
    status = Column(Enum('core', 'elective', name="course_status_enum"), nullable=False) # Enum for course status (Core or Elective)

    department_id = Column("department_id", ForeignKey('departments.id'), nullable=False)
    department = relationship('Department', back_populates='courses')

    scores = relationship("Score", back_populates='course', uselist=False)
    cadet_id = Column(Integer, ForeignKey("cadets.id"))
    cadet = relationship("Cadet", back_populates="courses")
    def __repr__(self):
        return f"({self.course_code} {self.course_title} {self.units} {self.status})"

class Faculty(db.Model):
    __tablename__="faculties"

    id = Column("id", Integer, primary_key=True)
    faculty_name = Column("faculty_name", String, nullable=False)
    departments = relationship('Department', back_populates='faculty')

    def __repr__(self):
        return f"({self.id} {self.faculty_name})"
    
class ProfilePicture(db.Model):
    __tablename__ = "profile_pictures"

    id = Column("id", String(255), primary_key=True,default=str(uuid.uuid4())) # Unique ID for each picture
    filename = Column("filename", String(255), nullable=False) # Filename of the picture
    # Define the foreign key relationship with Cadet
    cadet_id = Column(Integer, ForeignKey('cadets.id'))
    cadet = relationship("Cadet", back_populates='profile_picture')
    
    def __repr__(self):
        return f"({self.id} {self.filename} {self.cadet_id})"

class ServiceSubject(db.Model):
    __tablename__="service_subjects"
    
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    subject_code = Column("subject_code", String(10))
    subject_title = Column("subject_title", String(255), nullable=False)
    status = Column(Enum('major', 'minor', 'tour', 'camp', name="service_subject_status_enum"), nullable=False) # Enum for course status (major or minor)

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

# Create the database tables (if they don't exist)
with app.app_context():
    db.create_all()