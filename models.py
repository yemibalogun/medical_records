from sqlalchemy import  Column, String, Integer, ForeignKey, MetaData, Date, func
from sqlalchemy.orm import relationship, validates
from sqlalchemy.exc import IntegrityError
from config import db, app # Importing from config.py
from datetime import datetime, date
from flask_migrate import Migrate
from flask_login import UserMixin

metadata = MetaData()
migrate = Migrate(app, db)


class RegularCourse(db.Model):
    __tablename__="regular_courses"

    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
    course_no = Column("course_no", Integer, nullable=False)
    cadet = relationship('Cadet', back_populates='regular_course')

    def __repr__(self):
        return f"({self.id} {self.course_no})"

class Department(db.Model):
    __tablename__="departments"

    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
    department_name = Column("department_name", String, nullable=False)
    faculty_id = Column("faculty_id", ForeignKey('faculties.id'), nullable=False)
    faculty = relationship('Faculty', back_populates='departments')
    cadets = relationship('Cadet', back_populates='department')

    def __repr__(self):
        return f"({self.id} {self.department_name} {self.faculty_id})"

    
class Gender(db.Model):
    __tablename__="genders"
        
    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
    gender_type = Column("gender_type", String, nullable=False)
    staff = relationship('Staff', back_populates='gender')
    cadet = relationship('Cadet', back_populates='gender')
    
    def __repr__(self):
        return f"({self.id} {self.gender_type})"


class Battalion(db.Model):
    __tablename__="battalions"

    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
    bn = Column("bn", String, nullable=False)
    cadet = relationship('Cadet', back_populates='bn')

    def __repr__(self):
        return f"({self.id} {self.bn})"
    

class Medical(db.Model):
    __tablename__ = "medicals"
    
    id = Column(Integer, primary_key=True, autoincrement=True, nullable=False)
    date_reported_sick = Column(Date, nullable=False, default=func.now())
    history = Column(String, nullable=False)
    examination = Column(String, nullable=False)
    diagnosis = Column(String, nullable=False)
    plan = Column(String, nullable=False)
    prescription = Column(String, nullable=False, default="")
    prescription_status = Column(String(50), nullable=False, default='waiting') 
    excuse_duty = Column(String, nullable=True)
    excuse_duty_days = Column(Integer, nullable=False, default=0)
    admission_count = Column(Integer, nullable=False, default=0)
    
    cadet_id = Column(Integer, ForeignKey("cadets.id"))
    cadet = relationship("Cadet", back_populates="medical")

    @property
    def is_confinement(self):
        return self.excuse_duty == 'confinement'
    
    @property
    def confinement_days(self):
        return self.excuse_duty_days if self.is_confinement else 0
    
    def update_cadet_board_status(self):
        if self.cadet:
            self.cadet.update_board_status()

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
        return f"<Medical(id={self.id}, date_reported_sick={self.date_reported_sick}, diagnosis={self.diagnosis}, prescription_status={self.prescription_status}, excuse_duty={self.excuse_duty})>"

class Service(db.Model):
    __tablename__="services"

    id = Column('id', Integer, primary_key=True, autoincrement=True, nullable=False)
    service_type = Column('service_type', String, nullable=False)

    cadet = relationship('Cadet', back_populates='service')

    def __repr__(self):
        return f"({self.id} {self.service_type})"
    
class Visit(db.Model):
    __tablename__= "visits"

    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
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
    status = Column('status', String(20), nullable=False, default='inactive') 
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
    
    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
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
    board_status = Column("board_status", String, default='', nullable=False)
    admission_date = Column(Date, nullable=True)  # New field for admission date
    visit = relationship('Visit', back_populates='cadet')

    @property
    def total_days(self):
        admission_count = self.admission_count or 0 
        print(f"Admission Count: {admission_count}")
        confinement_days = sum(med.confinement_days or 0 for med in self.medical)
        print(f"Confinement Days: {confinement_days}")
        return admission_count + confinement_days

    def update_board_status(self):
        print(f"Updating board status for Cadet {self.id}: total_days={self.total_days}")
        if self.total_days > 42:
            self.board_status = 'board'
        else:
            self.board_status = ''
        print(f"Board status for Cadet {self.id} set to: {self.board_status}")

    def set_admission_count(self, count):
        self.admission_count = count
        self.update_board_status()

    @classmethod
    def admit_cadets(cls, cadet_ids):
        cadets = cls.query.filter(cls.id.in_(cadet_ids)).all()
        for cadet in cadets:
            cadet.admission_count += 1
            cadet.admission_date = datetime.now().date()  # Set admission date
            cadet.update_board_status()

        db.session.commit()

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

class Faculty(db.Model):
    __tablename__="faculties"

    id = Column("id", Integer, primary_key=True, autoincrement=True, nullable=False)
    faculty_name = Column("faculty_name", String, nullable=False)
    departments = relationship('Department', back_populates='faculty')

    def __repr__(self):
        return f"({self.id} {self.faculty_name})"

# Create the database tables (if they don't exist)
with app.app_context():
    db.create_all()


