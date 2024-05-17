from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, DateField, RadioField, SelectField, IntegerField, FloatField, TextAreaField, EmailField, TelField
from wtforms.validators import DataRequired, InputRequired, ValidationError, EqualTo
from course_code import choices
import datetime

class EditForm(FlaskForm):
    cadet_no = StringField('Cadet Number', validators=[DataRequired()])
    first_name = StringField('Name', validators=[DataRequired()])
    middle_name = StringField('Name', validators=[DataRequired()])
    last_name = StringField('Name', validators=[DataRequired()])
    religion = RadioField('Religion', choices=[('christianity', 'Christianity'), ('islam', 'Islam')], validators=[DataRequired()])
    gender = RadioField('Gender', choices=[('male', 'Male'), ('female', 'Female')], validators=[DataRequired()])
    state = StringField('State of Origin', validators=[DataRequired()])
    lga = StringField('LGA', validators=[DataRequired()])
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

class SearchForm(FlaskForm):
    searched = StringField('Searched', validators=[DataRequired() ])
    submit = SubmitField('Search')
    
class AddCadetForm(FlaskForm):
    cadet_no = StringField('Cadet Number', validators=[DataRequired()])
    first_name = StringField('Name', validators=[DataRequired()])
    middle_name = StringField('', validators=[DataRequired()])
    last_name = StringField('', validators=[DataRequired()])
    religion = RadioField('Religion', choices=[('christianity', 'Christianity'), ('islam', 'Islam')], validators=[DataRequired()])
    gender = RadioField('Gender', choices=[('male', 'Male'), ('female', 'Female')], validators=[DataRequired()])
    state = StringField('State of Origin', validators=[DataRequired()])
    lga = StringField('LGA', validators=[DataRequired()])
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

# Define a custom validator to check if the score is not more than 100
def validate_score(form, field):
    if field.data > 100:
        raise ValidationError('Score should not be more than 100.')


class ScoreForm(FlaskForm):
    course = SelectField('Course', choices=sorted(choices), validators=[InputRequired()])
    first_semester_score = FloatField('First Semester Score', validators=[DataRequired(), validate_score])
    second_semester_score = FloatField('First Semester Score', validators=[DataRequired(), validate_score])
    academic_year = SelectField('Academic Year', choices=[('first', 'First'), ('second', 'Second'), ('third', 'Third'), ('fourth', 'Fourth')], validators=[InputRequired()])
    
    submit = SubmitField('Submit')


class MilScoreForm(FlaskForm):
    subject = SelectField('Subject', validators=[InputRequired()])
    first_term_score = FloatField('First Term Score', validators=[DataRequired(), validate_score])
    second_term_score = FloatField('First Term Score', validators=[DataRequired(), validate_score])
    service_year = SelectField('Academic Year', choices=[('first', 'First'), ('second', 'Second'), ('third', 'Third'), ('fourth', 'Fourth'), ('fifth', 'fifth')], validators=[InputRequired()])
    
    submit = SubmitField('Submit')

class MedicalRecordForm(FlaskForm):
    date_reported_sick = DateField('Date Reported Sick', default= datetime.date.today, validators=[DataRequired()])
    history = TextAreaField('History', validators=[DataRequired()])
    examination = TextAreaField('Examination', validators=[DataRequired()])
    diagnosis = TextAreaField('Diagnosis', validators=[DataRequired()])
    plan = TextAreaField('Plan', validators=[DataRequired()])
    prescription = TextAreaField('Prescription', validators=[DataRequired()])
    excuse_duty = SelectField('Excuse Duty', choices=[('nil', 'Nil'), ('excused boot', 'Excused Boot'), ('excused all parades', 'Excused all Parades'), ('excused marching', 'Excused Marching'), ('confinement', 'Confinement')], validators=[InputRequired()])
    excuse_duty_days = IntegerField('Days', validators=[DataRequired()])

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
    gender = RadioField('Gender', choices=[('male', 'Male'), ('female', 'Female')], validators=[DataRequired()])
    role = RadioField('Role', choices=[('admin', 'Admin'), ('staff', 'Staff')], validators=[DataRequired()])
    status = RadioField('Status', choices=[('active', 'Active'), ('inactive', 'Inactive')], validators=[DataRequired()])
    appointment = StringField('Appointment', validators=[DataRequired()])
    date_of_birth = DateField('Date of Birth', validators=[DataRequired()])
    date_tos = DateField('Date taken on strenght', validators=[DataRequired()])
    
    submit = SubmitField('Register')

class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField("Login")