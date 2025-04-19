from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, DateField, RadioField, SelectField, IntegerField, TextAreaField, EmailField, TelField
from wtforms.validators import DataRequired, InputRequired, EqualTo, Optional
from state_lga import state_lga_data
import datetime


class EditForm(FlaskForm):
    cadet_no = StringField('Cadet Number', validators=[DataRequired()])
    first_name = StringField('Name', validators=[DataRequired()])
    middle_name = StringField('Name', validators=[DataRequired()])
    last_name = StringField('Name', validators=[DataRequired()])
    religion = RadioField('Religion', choices=[('christianity', 'Christianity'), ('islam', 'Islam')], validators=[DataRequired()])
    gender = RadioField('Gender', choices=[('male', 'Male'), ('female', 'Female')], validators=[DataRequired()])
    state = SelectField('State of Origin', choices=[
        ('abia', 'Abia'), ('adamawa', 'Adamawa'), ('akwa_ibom', 'Akwa Ibom'), 
        ('anambra', 'Anambra'), ('bauchi', 'Bauchi'), ('bayelsa', 'Bayelsa'), 
        ('benue', 'Benue'), ('borno', 'Borno'), ('cross_river', 'Cross River'),
        ('delta', 'Delta'), ('ebonyi', 'Ebonyi'), ('edo', 'Edo'), 
        ('ekiti', 'Ekiti'), ('enugu', 'Enugu'), ('gombe', 'Gombe'), 
        ('imo', 'Imo'), ('jigawa', 'Jigawa'), ('kaduna', 'Kaduna'), 
        ('kano', 'Kano'), ('katsina', 'Katsina'), ('kebbi', 'Kebbi'), 
        ('kogi', 'Kogi'), ('kwara', 'Kwara'), ('lagos', 'Lagos'), 
        ('nasarawa', 'Nasarawa'), ('niger', 'Niger'), ('ogun', 'Ogun'), 
        ('ondo', 'Ondo'), ('osun', 'Osun'), ('oyo', 'Oyo'), 
        ('plateau', 'Plateau'), ('rivers', 'Rivers'), ('sokoto', 'Sokoto'), 
        ('taraba', 'Taraba'), ('yobe', 'Yobe'), ('zamfara', 'Zamfara'), 
        ('fct', 'FCT')
    ], validators=[DataRequired()])
    lga = SelectField('LGA', choices=[], validators=[DataRequired()])
    doe = DateField('Date of Enlistment', validators=[DataRequired()])
    dob = DateField('Date of Birth', validators=[DataRequired()])
    department = SelectField('Department', choices=[('defence and security studies', 'Defence and Security Studies'), 
                                                    ('geography', 'Geography'), 
                                                    ('history and war studies', 'History and War Studies'), 
                                                    ('french', 'French'), 
                                                    ('arabic', 'Arabic'), 
                                                    ('political science', 'Political Science'), 
                                                    ('psychology', 'Psychology'), 
                                                    ('civil engineering', 'Civil Engineering'), 
                                                    ('electrical electronics engineering', 'Electrical Electronics Engineering'), 
                                                    ('mechanical engineering', 'Mechanical Engineering'), 
                                                    ('mechatronics engineering', 'Mechatronics Engineering'), 
                                                    ('accounting', 'Accounting'), 
                                                    ('economics', 'Economics'), 
                                                    ('logistics and supply chain management', 'Logistics and Supply Chain Management'), 
                                                    ('management studies', 'Management Studies'), 
                                                    ('computer science', 'Computer Science'), 
                                                    ('cyber security', 'Cyber Security'), 
                                                    ('intelligence and security science', 'Intelligence and Security Science'), 
                                                    ('biology', 'Biology'), 
                                                    ('biotechnology', 'Biotechnology'), 
                                                    ('chemistry', 'Chemistry'), 
                                                    ('mathematical sciences', 'Mathematical Sciences'), 
                                                    ('physics', 'Physics')], 
                                                    validators=[DataRequired()])
    bn = SelectField('Battalion', choices=[('mogadishu', 'Mogadishu'), 
                                           ('dalet', 'Dalet'), 
                                           ('abyssinia', 'Abyssinia'), 
                                           ('burma', 'Burma')], 
                                           validators=[InputRequired()])
    service = SelectField('Arm of Service', choices=[('army', 'Army'), ('navy', 'Navy'), ('airforce', 'Airforce')], validators=[DataRequired()])
    regular_course = IntegerField('Course', validators=[DataRequired()])
    submit = SubmitField('Submit')
    

class EditMedicalRecordForm(FlaskForm):
    date_reported_sick = DateField('Date Reported Sick', 
                                   default=lambda: datetime.date.today(), 
                                   validators=[DataRequired()])
    history = TextAreaField('History', validators=[DataRequired()])
    examination = TextAreaField('Examination', validators=[DataRequired()])
    diagnosis = TextAreaField('Diagnosis', validators=[DataRequired()])
    plan = TextAreaField('Plan', validators=[DataRequired()])
    prescription = TextAreaField('Prescription')
    prescription_status = SelectField('Status', choices=[('waiting', 'Waiting'), ('in progress', 'In Progress'), ('completed', 'Completed')], default='waiting', validators=[DataRequired()])
    excuse_duty = SelectField('Excuse Duty', choices=[('nil', 'Nil'), 
                                                      ('excused boot', 'Excused Boot'), 
                                                      ('excused all parades', 'Excused all Parades'), 
                                                      ('excused marching', 'Excused Marching'), 
                                                      ('confinement', 'Confinement')], 
                                                      validators=[InputRequired()])
    excuse_duty_days = IntegerField('Days')
    admission_count = RadioField('Admit', choices=[('1', 'Yes'), ('0', 'No')], validators=[InputRequired()])

    submit = SubmitField('Submit')


class SearchForm(FlaskForm):
    searched = StringField('Searched', validators=[DataRequired() ])
    submit = SubmitField('Search')
    
class AddCadetForm(FlaskForm):
    cadet_no = StringField('Cadet Number', validators=[DataRequired()])
    first_name = StringField('Name', validators=[DataRequired()])
    middle_name = StringField('', validators=[DataRequired()])
    last_name = StringField('', validators=[DataRequired()])
    religion = RadioField('Religion', choices=[('christianity', 'Christianity'), 
                                               ('islam', 'Islam')], 
                                               validators=[InputRequired()])
    gender = RadioField('Gender', choices=[('male', 'Male'), ('female', 'Female')], validators=[DataRequired()])
    state = SelectField('State of Origin', choices=[
        ('abia', 'Abia'), ('adamawa', 'Adamawa'), ('akwa_ibom', 'Akwa Ibom'), 
        ('anambra', 'Anambra'), ('bauchi', 'Bauchi'), ('bayelsa', 'Bayelsa'), 
        ('benue', 'Benue'), ('borno', 'Borno'), ('cross_river', 'Cross River'),
        ('delta', 'Delta'), ('ebonyi', 'Ebonyi'), ('edo', 'Edo'), 
        ('ekiti', 'Ekiti'), ('enugu', 'Enugu'), ('gombe', 'Gombe'), 
        ('imo', 'Imo'), ('jigawa', 'Jigawa'), ('kaduna', 'Kaduna'), 
        ('kano', 'Kano'), ('katsina', 'Katsina'), ('kebbi', 'Kebbi'), 
        ('kogi', 'Kogi'), ('kwara', 'Kwara'), ('lagos', 'Lagos'), 
        ('nasarawa', 'Nasarawa'), ('niger', 'Niger'), ('ogun', 'Ogun'), 
        ('ondo', 'Ondo'), ('osun', 'Osun'), ('oyo', 'Oyo'), 
        ('plateau', 'Plateau'), ('rivers', 'Rivers'), ('sokoto', 'Sokoto'), 
        ('taraba', 'Taraba'), ('yobe', 'Yobe'), ('zamfara', 'Zamfara'), 
        ('fct', 'FCT')
    ], validators=[DataRequired()])
    lga = SelectField('LGA', choices=[], validators=[DataRequired()])
    doe = DateField('Date of Enlistment', validators=[DataRequired()])
    dob = DateField('Date of Birth', validators=[DataRequired()])
    department = SelectField('Department', choices=[('defence and security studies', 'Defence and Security Studies'), 
                                                    ('geography', 'Geography'), 
                                                    ('history and war studies', 'History and War Studies'), 
                                                    ('french', 'French'), 
                                                    ('arabic', 'Arabic'), 
                                                    ('political science', 'Political Science'), 
                                                    ('psychology', 'Psychology'), 
                                                    ('civil engineering', 'Civil Engineering'), 
                                                    ('electrical electronics engineering', 'Electrical Electronics Engineering'), 
                                                    ('mechanical engineering', 'Mechanical Engineering'), 
                                                    ('mechatronics engineering', 'Mechatronics Engineering'), 
                                                    ('accounting', 'Accounting'), 
                                                    ('economics', 'Economics'), 
                                                    ('logistics and supply chain management', 'Logistics and Supply Chain Management'), 
                                                    ('management studies', 'Management Studies'), 
                                                    ('computer science', 'Computer Science'), 
                                                    ('cyber security', 'Cyber Security'), 
                                                    ('intelligence and security science', 'Intelligence and Security Science'), 
                                                    ('biology', 'Biology'), 
                                                    ('biotechnology', 'Biotechnology'), 
                                                    ('chemistry', 'Chemistry'), 
                                                    ('mathematical sciences', 'Mathematical Sciences'), 
                                                    ('physics', 'Physics')], 
                                                    validators=[DataRequired()])
    bn = SelectField('Battalion', choices=[('mogadishu', 'Mogadishu'), ('dalet', 'Dalet'), ('abyssinia', 'Abyssinia'), ('burma', 'Burma')], validators=[InputRequired()])
    service = SelectField('Arm of Service', choices=[('army', 'Army'), ('navy', 'Navy'), ('airforce', 'Airforce')], validators=[DataRequired()])
    regular_course = IntegerField('Course', validators=[DataRequired()])
    
    submit = SubmitField('Submit')
    
    def __init__(self, *args, **kwargs):
        super(AddCadetForm, self).__init__(*args, **kwargs)
        
        # Dynamically populate the LGA choices based on the selected state
        if self.state.data:
            selected_state = self.state.data
            lgas = state_lga_data.get(selected_state, [])
            self.lga.choices = [(lga, lga) for lga in lgas]
        else:
            self.lga.choices = []
            

class MedicalRecordForm(FlaskForm):
    date_reported_sick = DateField('Date Reported Sick', 
                                   default=lambda: datetime.date.today(), 
                                   validators=[DataRequired()])
    history = TextAreaField('History', validators=[DataRequired()])
    examination = TextAreaField('Examination', validators=[DataRequired()])
    diagnosis = TextAreaField('Diagnosis', validators=[DataRequired()])
    plan = TextAreaField('Plan', validators=[DataRequired()])
    prescription = TextAreaField('Prescription')
    prescription_status = SelectField('Status', choices=[('waiting', 'Waiting'), ('in progress', 'In Progress'), ('completed', 'Completed')], default='waiting', validators=[DataRequired()])
    excuse_duty = SelectField('Excuse Duty', choices=[('nil', 'Nil'), 
                                                      ('excused boot', 'Excused Boot'), 
                                                      ('excused all parades', 'Excused all Parades'), 
                                                      ('excused marching', 'Excused Marching'), 
                                                      ('confinement', 'Confinement')], 
                                                      validators=[InputRequired()])
    excuse_duty_days = IntegerField('Days')
    admission_count = RadioField('Admit', choices=[('1', 'Yes'), ('0', 'No')], validators=[InputRequired()])

    submit = SubmitField('Submit')

class AdmissionForm(FlaskForm):
    cadet_no = StringField('Cadet Number', validators=[DataRequired()])
    submit = SubmitField('Add')

class StaffRegisterForm(FlaskForm):
    firstname = StringField('First Name', validators=[DataRequired()])
    middlename = StringField('Middle Name', validators=[DataRequired()])
    lastname = StringField('Last Name', validators=[DataRequired()])
    email = EmailField('Email', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    phone = TelField('Phone Number', validators=[DataRequired()])
    address = StringField('Address', validators=[DataRequired()])
    gender = RadioField('Gender', choices=[('male', 'Male'), 
                                           ('female', 'Female')], 
                                           validators=[InputRequired()])
    role = SelectField('Role', choices=[('admin', 'Admin'), 
                                        ('doctor', 'Doctor'), 
                                        ('nurse', 'Nurse'), 
                                        ('pharmacist', 'Pharmacist'),
                                        ('cadets_brigade', 'Cadets Brigade'),
                                        ('front_desk', 'Front Desk')],
                                        validators=[DataRequired()])
    
    status = SelectField('Status', choices=[('active', 'Active'), 
                                            ('inactive', 'Inactive')
                                            ], default='inactive', validators=[DataRequired()])
    
    appointment = StringField('Appointment', validators=[DataRequired()])
    date_of_birth = DateField('Date of Birth', validators=[DataRequired()])
    date_tos = DateField('Date taken on strenght', validators=[DataRequired()])
    
    submit = SubmitField('Register')

class LoginForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField("Login")

class CheckInForm(FlaskForm):
    cadet_id = StringField('Cadet ID', validators=[DataRequired()])
    check_in_time = DateField('Check-In Time', default=lambda: datetime.date.today(), validators=[DataRequired()])
    reason = TextAreaField('Reason for Visit', validators=[Optional()])
    doctor_id = SelectField('Assigned Doctor', choices=[], coerce=int, validators=[Optional()])
    status = SelectField('Status', choices=[('waiting', 'Waiting'), ('in progress', 'In Progress'), ('completed', 'Completed')], default='waiting', validators=[DataRequired()])
    
    submit = SubmitField('Check In')

    def __init__(self, doctors=None, *args, **kwargs):
        super(CheckInForm, self).__init__(*args, **kwargs)
        if doctors:
            self.doctor_id.choices = [(doctor.staff_id, f"{doctor.firstname} {doctor.lastname}") for doctor in doctors]