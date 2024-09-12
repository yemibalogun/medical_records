from flask import render_template, redirect, url_for, request, jsonify, session, flash
from flask_login import login_user, LoginManager, login_required, current_user, logout_user 
from flask_bcrypt import Bcrypt
from forms import EditForm, SearchForm, AddCadetForm,  MedicalRecordForm, StaffRegisterForm, LoginForm, CheckInForm, EditMedicalRecordForm
from config import app, db
from models import Cadet, RegularCourse, Department, Gender, Battalion, Service, Medical, Staff, Visit
from sqlalchemy.orm import joinedload, Session
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy.exc import IntegrityError
from sqlalchemy import or_, func, event, distinct
from flask_bootstrap import Bootstrap
from flask_migrate import Migrate
from flask_socketio import SocketIO
from flask_apscheduler import APScheduler
import csv, os, json
from datetime import datetime, date
from utils import regular_courses, roles
from state_lga import state_lga_data

    
year = datetime.now().year
migrate = Migrate(app, db)
Bootstrap(app)
bcrypt = Bcrypt(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message_category = 'info'
socketio = SocketIO(app)
scheduler = APScheduler()
scheduler.init_app(app)

class Config:
    SCHEDULER_API_ENABLED = True

app.config.from_object(Config())

@scheduler.task('cron', id='reset_admission_count', day=1, month=10)
def reset_admission_count():
    with app.app_context():
        cadets = Cadet.query.all()
        for cadet in cadets:
            cadet.admission_count = 0
            cadet.update_board_status()
        db.session.commit()
        print(f"Reset admission count for all cadets on {datetime.now()}")

scheduler.start()

@event.listens_for(Session, 'after_commit')
def after_commit_update_board_status(session):
    updated_cadets = set()
    for obj in session.dirty:
        if isinstance(obj, Medical):
            cadet = obj.cadet
            if cadet:
                print(f"Updating board status for Cadet {cadet.id}")
                cadet.update_board_status()
                updated_cadets.add(cadet)

    if updated_cadets:
        with session.no_autoflush:
            for cadet in updated_cadets:
                session.add(cadet)
            session.commit()

# Get the current working directory
current_directory = os.getcwd()

# Define the upload folder path within the current working directory
upload_folder_path = os.path.join(current_directory, 'profile_pics')

# Set the Flask app's upload folder configuration
app.config['UPLOAD_FOLDER'] = upload_folder_path
app.config['ALLOWED_EXTENSIONS'] = {'png', 'jpg', 'jpeg', 'gif'}

# Check if the upload folder exists and create it if it doesn't
if not os.path.exists(upload_folder_path):
    os.makedirs(upload_folder_path)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']


# Pass Stuff to NavBar
@app.context_processor
def base():
    form = SearchForm()
    course = regular_courses() # Assuming this returns a dictionary
    role = roles()  
    return {
        'form_dict': dict(form=form),
        'course_dict': course,
        'role_dict': role
        }

# Create a session
session = db.session

@login_manager.user_loader
def load_user(staff_id):
    staff = session.get(Staff, int(staff_id))
    session.close() # Close the session after use
    return staff

@app.route('/autocomplete', methods=['GET'])
def autocomplete():
    query = request.args.get('query', '').upper()

    # Perform a query on the Cadet table based on the search query
    cadets = session.query(Cadet).filter(
            or_(
                Cadet.first_name.ilike(f'%{query}%'),
                Cadet.middle_name.ilike(f'%{query}%'),
                Cadet.last_name.ilike(f'%{query}%'),
                Cadet.cadet_no.ilike(f'%{query}%')
            )
        ).all()
    # app.logger.debug(f"Cadets found: {cadets}")  # Logging the cadets found for debugging
    if cadets:
        # Convert each tuple to a dictionary and add to a new list
        results = []
        for index, cadet in enumerate(cadets, start=1):
            cadet_dict = {
                'serial': index,
                'cadet_no': cadet.cadet_no,
                'first_name': cadet.first_name,
                'middle_name': cadet.middle_name,
                'last_name': cadet.last_name,
                'bn': cadet.bn.bn.capitalize() if cadet.bn else '',
                'service': cadet.service.service_type.capitalize() if cadet.service else '',
                'gender': cadet.gender.gender_type if cadet.gender else '',
                'religion': cadet.religion,
                'state': cadet.state,
                'lga': cadet.lga,
                'enlistment_date': None,
                'dob': None,
                'department': cadet.department.department_name.title() if cadet.department else '',
                'course': cadet.regular_course.course_no if cadet.regular_course else '',
                'student_info_url':  url_for('student_info',  id=cadet.id)
            }
            
            # Handle date fields
            try: 
                if isinstance(cadet.date_of_enlistment, datetime):
                    cadet_dict['enlistment_date'] = cadet.date_of_enlistment.isoformat()
                elif isinstance(cadet.date_of_enlistment, str):
                    cadet_dict['enlistment_date'] = datetime.strptime(cadet.date_of_enlistment, '%Y-%m-%d').isoformat()
            except (ValueError, TypeError):
                cadet_dict['enlistment_date'] = None
            
            try:
                if isinstance(cadet.date_of_birth, datetime):
                    cadet_dict['dob'] = cadet.date_of_birth.isoformat()
                elif isinstance(cadet.date_of_birth, str):
                    cadet_dict['dob'] = datetime.strptime(cadet.date_of_birth, '%Y-%m-%d').isoformat()
            except (ValueError, TypeError):
                cadet_dict['dob'] = None
            
            results.append(cadet_dict)
        cadets_json = json.dumps(results)
        return cadets_json
    else:
        # Return an empty array if no results found
        return jsonify([]) 

@app.route('/get_lgas')
def get_lgas():
    state = request.args.get('state')  # Get the selected state from the query string
    if state:
        state = state.strip().replace('_', ' ').title()  # Replace underscores with spaces and capitalize
        lgas = state_lga_data.get(state, [])  # Fetch LGAs for the given state
        return jsonify(lgas)
    else:
        return jsonify([])  # Return an empty list if no state found

# Create Search Function
@app.route('/search', methods=["GET", "POST"])
def search():
    search_form = SearchForm()  # Assuming you have a SearchForm defined
    name_search = []  # Initialize an empty list for name search results
    
    if search_form.validate_on_submit():
        searched = search_form.searched.data.strip().lower()
        
        # Query the database for matching results
        name_search = session.query(Cadet).filter(
            or_(
                Cadet.first_name.ilike(f'%{searched}%'),
                Cadet.middle_name.ilike(f'%{searched}%'),
                Cadet.last_name.ilike(f'%{searched}%'),
                Cadet.cadet_no.ilike(f'%{searched}%')
            )
        ).options(joinedload(Cadet.service), 
        joinedload(Cadet.bn), 
        joinedload(Cadet.regular_course),
        joinedload(Cadet.department)
        ).all()
        
    return render_template("search.html", search_form=search_form, rows=name_search)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    search_form = SearchForm()
    login_form = LoginForm()

    if login_form.validate_on_submit():

        email=login_form.email.data
        password=login_form.password.data
        
        staff = Staff.query.filter_by(email=email).first()
        if not staff:
            flash('Incorrect credentials!', 'warning')
            return redirect(url_for('login'))
        elif not bcrypt.check_password_hash(staff.password, password):
                flash('Incorrect credentials!, please try again.', 'warning')
                return redirect(url_for('login'))
        else:
            # Update status to 'active'
            new_status = request.form.get('status')
            if new_status not in ['active', 'inactive']:
                flash('Invalid status.', 'warning')
                return redirect(url_for('login'))
        
            staff.status = new_status
            db.session.commit()
            login_user(staff)
            
            flash('You have been logged in successfully!', 'success')
            next_page = request.args.get('next')

            if next_page:
                return redirect(next_page)
            else:
                if staff.role == "doctor":
                    return redirect(url_for('doctor_dashboard'))
                elif staff.role == "front_desk":
                    return redirect(url_for('front_desk_dashboard'))
                elif staff.role == 'nurse':
                    return redirect(url_for('nurse_dashboard'))
                else:
                    return redirect(url_for('home'))
                
    return render_template("login.html", login_form=login_form, search_form=search_form)

@app.route('/logout')
@login_required
def logout():
    try:
        # Update status to 'inactive'
        new_status = request.args.get('status', 'inactive')
        print(new_status)
        current_user.status = new_status
        db.session.commit()
        print(f"Status after commit: {current_user.status}")

        logout_user()
        flash("You have been logged out!", 'success')
    except Exception as e:
        db.session.rollback()
        print(f"Error during logout: {e}")
        flash("An error occurred during logout.", 'error')
    finally:
        db.session.close()

    return redirect(url_for('login'))


@app.route("/")
@login_required
def home():
    search_form = SearchForm()
    cadets = session.query(Cadet).all()          
        
    course = session.query(RegularCourse).all()
    course_dict = {}

    for course_object in course:
        key = course_object.id
        cse_count = session.query(Cadet).filter(Cadet.regular_id == key).count() 
        course_dict[key] = [course_object.course_no, cse_count]   
    
    academy_count = len(cadets)
    
    return render_template("course.html", academy_count=academy_count, course_dict=course_dict, search_form=search_form)

@app.route("/course/<int:id>", methods=["GET"])  
@login_required
def select_course(id):
    search_form = SearchForm()
    page = request.args.get("page", 1, type=int)
    per_page = 20

    course_cadets = session.query(Cadet).filter(Cadet.regular_id == id).all()
    course_no = session.query(RegularCourse).filter(RegularCourse.id == id).first()

    start = (page - 1) * per_page
    end = start + per_page
    paginated_cadets = course_cadets[start:end]
    
    course = session.query(RegularCourse).all()
    course_dict = {}

    for course_object in course:
        key = course_object.id
        cse_count = session.query(Cadet).filter(Cadet.regular_id == key).count() 
        course_dict[key] = [course_object.course_no, cse_count]  

    course_cadets_count = session.query(Cadet).filter(Cadet.regular_id == id).count()
    mog_cdts_count = session.query(Cadet).filter(Cadet.bn_id == 1, Cadet.regular_id == id).count()
    dal_cdts_count = session.query(Cadet).filter(Cadet.bn_id == 2, Cadet.regular_id == id).count()
    aby_cdts_count = session.query(Cadet).filter(Cadet.bn_id == 3, Cadet.regular_id == id).count()
    bur_cdts_count = session.query(Cadet).filter(Cadet.bn_id == 4, Cadet.regular_id == id).count()
    
    army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.regular_id == id).count()
    mog_army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.bn_id == 1, Cadet.regular_id == id).count()
    dal_army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.bn_id == 2, Cadet.regular_id == id).count()
    aby_army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.bn_id == 3, Cadet.regular_id == id).count()
    bur_army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.bn_id == 4, Cadet.regular_id == id).count()
    
    navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.regular_id == id).count()
    mog_navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.bn_id == 1, Cadet.regular_id == id).count()
    dal_navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.bn_id == 2, Cadet.regular_id == id).count()
    aby_navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.bn_id == 3, Cadet.regular_id == id).count()
    bur_navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.bn_id == 4, Cadet.regular_id == id).count()
    
    airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.regular_id == id).count()
    mog_airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.bn_id == 1, Cadet.regular_id == id).count()
    dal_airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.bn_id == 2, Cadet.regular_id == id).count()
    aby_airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.bn_id == 3, Cadet.regular_id == id).count()
    bur_airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.bn_id == 4, Cadet.regular_id == id).count()
    
    male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.regular_id == id).count()
    mog_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.bn_id == 1, Cadet.regular_id == id).count()
    dal_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.bn_id == 2, Cadet.regular_id == id).count()
    aby_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.bn_id == 3, Cadet.regular_id == id).count()
    bur_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.bn_id == 4, Cadet.regular_id == id).count()
    
    female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.regular_id == id).count()
    mog_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.bn_id == 1, Cadet.regular_id == id).count()
    dal_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.bn_id == 2, Cadet.regular_id == id).count()
    aby_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.bn_id == 3, Cadet.regular_id == id).count()
    bur_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.bn_id == 4, Cadet.regular_id == id).count()
    
    return render_template("course-list.html",
                           search_form=search_form, 
                           cadets=paginated_cadets,
                           page=page,
                           per_page=per_page,
                           total=len(course_cadets),
                           rows=course_cadets, 
                           course=id,
                           course_no=course_no,
                           course_dict=course_dict,
                           course_cadets_count=course_cadets_count, 
                           mog_cdts_count=mog_cdts_count, 
                           dal_cdts_count=dal_cdts_count, 
                           aby_cdts_count=aby_cdts_count, 
                           bur_cdts_count=bur_cdts_count, 
                           army_cdts_count=army_cdts_count, 
                           mog_army_cdts_count=mog_army_cdts_count, 
                           dal_army_cdts_count=dal_army_cdts_count, 
                           aby_army_cdts_count=aby_army_cdts_count, 
                           bur_army_cdts_count=bur_army_cdts_count, 
                           navy_cdts_count=navy_cdts_count, 
                           mog_navy_cdts_count=mog_navy_cdts_count, 
                           dal_navy_cdts_count=dal_navy_cdts_count, 
                           aby_navy_cdts_count=aby_navy_cdts_count, 
                           bur_navy_cdts_count=bur_navy_cdts_count, 
                           airforce_cdts_count=airforce_cdts_count, 
                           mog_airforce_cdts_count=mog_airforce_cdts_count, 
                           dal_airforce_cdts_count=dal_airforce_cdts_count, 
                           aby_airforce_cdts_count=aby_airforce_cdts_count, 
                           bur_airforce_cdts_count=bur_airforce_cdts_count, 
                           male_cdts_count=male_cdts_count, 
                           mog_male_cdts_count=mog_male_cdts_count, 
                           dal_male_cdts_count=dal_male_cdts_count, 
                           aby_male_cdts_count=aby_male_cdts_count, 
                           bur_male_cdts_count=bur_male_cdts_count, 
                           female_cdts_count=female_cdts_count,
                           mog_female_cdts_count=mog_female_cdts_count,
                           dal_female_cdts_count=dal_female_cdts_count,
                           aby_female_cdts_count=aby_female_cdts_count,
                           bur_female_cdts_count=bur_female_cdts_count,
                           year=year
                           )

@app.route("/edit/<int:id>", methods=["GET", "POST"])
@login_required
def edit_cadet(id):
    search_form=SearchForm()
    edit_form=EditForm()
    
    selected_cadet = session.query(Cadet).filter_by(id=id).first()

    if request.method == 'POST':
        if edit_form.validate_on_submit():
            # Populate simple fields directly from the form
            selected_cadet.cadet_no = edit_form.cadet_no.data
            selected_cadet.first_name = edit_form.first_name.data
            selected_cadet.middle_name = edit_form.middle_name.data
            selected_cadet.last_name = edit_form.last_name.data
            selected_cadet.state = edit_form.state.data
            selected_cadet.lga = edit_form.lga.data
            selected_cadet.doe = edit_form.doe.data
            selected_cadet.dob = edit_form.dob.data
            selected_cadet.religion = edit_form.religion.data

            # Fetch the related instances
            selected_cadet.department = db.session.query(Department).filter_by(department_name=edit_form.department.data).first()
            selected_cadet.bn = db.session.query(Battalion).filter_by(bn=edit_form.bn.data).first()
            selected_cadet.service = db.session.query(Service).filter_by(service_type=edit_form.service.data).first()
            selected_cadet.gender = db.session.query(Gender).filter_by(gender_type=edit_form.gender.data).first()

            # Handle RegularCourse
            regular_course = db.session.query(RegularCourse).filter_by(course_no=edit_form.regular_course.data).first()
            if not regular_course:
                # If regular_course is None, create a new RegularCourse instance
                regular_course = RegularCourse(course_no=edit_form.regular_course.data)
                db.session.add(regular_course)
                db.session.commit()  # Commit to get the ID for the new regular_course
            
            selected_cadet.regular_course = regular_course
            session.commit()
            flash("Cadet record updated successfully!", 'success')
            return redirect(url_for('home'))
    
        else:
            flash('Form validation failed. Please check your inputs.', 'error')
        
    # Process the form to populate form fields with selected_record data
    if request.method == 'GET':
        edit_form.process(obj=selected_cadet)

    return render_template("edit.html", 
                           row=selected_cadet, 
                           edit_form=edit_form, 
                           year=year, 
                           search_form=search_form
                           )

@app.route("/dashboard/<int:id>", methods=["GET","POST"])
@login_required
def student_info(id):
    search_form = SearchForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    
    if current_user.role not in ['doctor', 'cadets_brigade']:
        flash("Access denied!", 'danger')
        return redirect(url_for('home'))
    
    today = date.today()
    
    cadet_medical_records = session.query(Medical).filter(Medical.cadet_id==id).all()
    admitted_cadets = session.query(Cadet).filter(Cadet.admission_date==today).all()
    admitted_cadets_count = session.query(Cadet).filter(Cadet.admission_date==today).count()
    sick_report = session.query(Visit).filter(Visit.check_in_time==today).distinct().all()
    sick_report_count = session.query(Visit).filter(Visit.check_in_time==today).count()
    cadet_records = session.query(Cadet).filter(Cadet.id==id).first()

    # course_cadets = session.query(Cadet).filter(Cadet.regular_id == id).all()
    
    days_confined = session.query(func.sum(Medical.excuse_duty_days)).filter(
        Medical.cadet_id==id, 
        Medical.excuse_duty=="confinement"
        ).scalar()
    
    try:
        selected_cadet = session.query(Cadet).join(Battalion).filter(Cadet.id==id, Cadet.bn_id==Battalion.id).first()
        days_admitted=selected_cadet.admission_count
        
        dob_obj = selected_cadet.date_of_birth
        doe_obj = selected_cadet.date_of_enlistment
        
        # Convert if they are strings
        if isinstance(dob_obj, str):
            dob_obj = datetime.strptime(dob_obj, '%Y-%m-%d')  # Adjust format if needed
        if isinstance(doe_obj, str):
            doe_obj = datetime.strptime(doe_obj, '%Y-%m-%d')  # Adjust format if needed


        dob_year = dob_obj.year
        current_year = datetime.now().year
        cadet_age = current_year - dob_year
        
        formatted_dob = dob_obj.strftime('%d %B %Y').lstrip('0').replace(' 0', ' ')
        formatted_doe = doe_obj.strftime('%d %B %Y').lstrip('0').replace(' 0', ' ')
        formatted_date = today.strftime("%d %b %y")
        
    except NoResultFound:
        return "Cadet not found", 404
    except ValueError as e:
        return f"Error: {e}", 500
    if days_confined is None:
        days_confined = 0

    training_days = 365 - days_confined + days_admitted
    return render_template("dashboard.html",
                               search_form=search_form,
                               selected_cadet=selected_cadet,
                               rows=cadet_medical_records,
                               days_admitted=days_admitted,
                               days_confined=days_confined,
                               admitted_cadets=admitted_cadets,
                               admitted_cadets_count=admitted_cadets_count,
                               sick_report=sick_report,
                               sick_report_count=sick_report_count,
                               today=formatted_date,
                               training_days=training_days,
                               cadet_records=cadet_records,
                               cadet_age=cadet_age,
                               formatted_dob=formatted_dob,
                               formatted_doe=formatted_doe,
                               page=page,
                               year=year,
                               per_page=per_page
                               )

@app.route("/edit_medical_record/<int:id>/<int:cadet_id>", methods=["GET", "POST"])
@login_required
def edit_medical_record(id, cadet_id):
    search_form = SearchForm()
    edit_medical_record_form = EditMedicalRecordForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    
    selected_record = session.query(Medical).filter_by(id=id).first()
    selected_cadet = session.query(Cadet).filter(Cadet.id==cadet_id).first()
    
    if request.method == 'POST':
        if edit_medical_record_form.validate_on_submit():
            # Update record with form data
            edit_medical_record_form.populate_obj(selected_record)

            # You might need to convert the date format based on your form and database structure
            selected_record.date_reported_sick = edit_medical_record_form.date_reported_sick.data.strftime('%Y-%m-%d')
            selected_record.history = edit_medical_record_form.history.data
            selected_record.examination = edit_medical_record_form.examination.data
            selected_record.diagnosis = edit_medical_record_form.diagnosis.data
            selected_record.plan = edit_medical_record_form.plan.data
            selected_record.prescription = edit_medical_record_form.prescription.data
            selected_record.prescription_status = edit_medical_record_form.prescription_status.data
            selected_record.excuse_duty = edit_medical_record_form.excuse_duty.data
            selected_record.excuse_duty_days = edit_medical_record_form.excuse_duty_days.data
            selected_record.admission_count = edit_medical_record_form.admission_count.data

            session.commit()
            flash("Medical record updated successfully!", 'success')
            return redirect(url_for('student_info', id=cadet_id))
    
        else:
            flash('Form validation failed. Please check your inputs.', 'error')
        
    # Process the form to populate form fields with selected_record data
    if request.method == 'GET':
        edit_medical_record_form.process(obj=selected_record)

    return render_template("edit_medical_record.html", 
                           row=selected_record, 
                           cadet=selected_cadet, 
                           edit_medical_record_form=edit_medical_record_form, 
                           year=year,
                           page=page,
                           per_page=per_page, 
                           search_form=search_form
                           )

@app.route('/api/sick_reports', methods=['GET'])
def get_sick_reports():
    # Query the database to count sick reports per month
    reports = session.query(
        func.date_trunc('month', Visit.check_in_time).label('month'),
        func.count(Visit.id).label('count')
    ).group_by('month').order_by('month').all()
    
    # Format the results into a list of dictionaries
    data = [{'month': report.month.strftime('%Y-%m'), 'count': report.count} for report in reports]
    
    return jsonify(data)


@app.route('/register_staff', methods=['GET', 'POST'])
def register_staff():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    search_form = SearchForm()
    staff_register_form = StaffRegisterForm()

    if staff_register_form.validate_on_submit():
        email = staff_register_form.email.data
        password = staff_register_form.password.data
        if Staff.query.filter_by(email=email).first():
            flash(f"You've already registered with that email, Login instead!")
            return redirect(url_for('login'))
        else:
            hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
     
            gender = staff_register_form.gender.data
            gender_instance = Gender.query.filter_by(gender_type=gender).first()
            
            new_staff = Staff(
                firstname=(staff_register_form.firstname.data).title(),
                middlename=staff_register_form.middlename.data.title(),
                lastname=staff_register_form.lastname.data.title(),
                email=staff_register_form.email.data,
                password=hashed_password,
                phone=staff_register_form.phone.data,
                address=staff_register_form.address.data.title(),
                gender = gender_instance,
                role=staff_register_form.role.data,
                status='active',
                appointment=staff_register_form.appointment.data,
                date_of_birth=staff_register_form.date_of_birth.data,
                date_tos=staff_register_form.date_tos.data,
                )
            session.add(new_staff)
            session.commit()
        
            # This next line will authenticate the user with Flask-Login
            login_user(new_staff)
            flash('Your account has been created!', 'success')
            next_page = request.args.get('next')

            if next_page:
                return redirect(next_page)
            else:
                if new_staff.role == "doctor":
                    return redirect(url_for('doctor_dashboard'))
                elif new_staff.role == "front_desk":
                    return redirect(url_for('front_desk_dashboard'))
                else:
                    return redirect(url_for('home'))

    return render_template('staff_registration.html', search_form=search_form, staff_register_form=staff_register_form)

@app.route('/check_in', methods=['GET', 'POST'])
@login_required
def front_desk_dashboard():
    search_form = SearchForm()
    check_in_form = CheckInForm()

    # Query all doctors to pass to the form
    doctors = Staff.query.filter_by(role='doctor').all()
    check_in_form = CheckInForm(doctors=doctors)

    if check_in_form.validate_on_submit():
        cadet_id = (check_in_form.cadet_id.data).upper()
        check_in_time = check_in_form.check_in_time.data
        reason = check_in_form.reason.data.title()
        doctor_id = check_in_form.doctor_id.data
        status = check_in_form.status.data

        selected_cadet = db.session.query(Cadet).filter_by(cadet_no=cadet_id).first()
        today = date.today()
        print(today)
        if selected_cadet is None:
            flash("Patient records not in database", 'info')
            return redirect(url_for('add_cadet'))

        reported_sick_cadet = db.session.query(Visit).filter(Visit.check_in_time==today, Visit.cadet_id==selected_cadet.id, Visit.status=='waiting').first()

        if reported_sick_cadet:
            flash(f'{selected_cadet.first_name} has already been checked in', 'info')
            return redirect(url_for('front_desk_dashboard'))
        # Create a new Visit record
        visit = Visit(
            cadet_id=selected_cadet.id,
            check_in_time=check_in_time,
            reason=reason,
            doctor_id=doctor_id,
            status=status
        )
        # Add the new visit to the database
        db.session.add(visit)
        db.session.commit()

        # Emit an event for new check-in
        socketio.emit('new_check_in', {
            'id': visit.id,
            'cadet_id': visit.cadet_id,
            'check_in_time': visit.check_in_time.strftime("%Y-%m-%d %H:%M:%S"),
            'status': visit.status,
            'reason': visit.reason
        })
        
        flash('Patient checked in successfully!', 'success')
        return redirect(url_for('front_desk_dashboard'))
    
    return render_template('check_in.html', 
                           check_in_form=check_in_form,
                           search_form=search_form
                           )

@app.route('/doctor_dashboard')
@login_required
def doctor_dashboard():
    page = request.args.get("page", 1, type=int)
    per_page = 20
    search_form = SearchForm()
    if current_user.role != 'doctor':
        flash("Access denied!", 'danger')
        return redirect(url_for('login'))
    try:
        waiting_patients = Visit.query.filter_by(status='waiting').order_by(Visit.check_in_time).all()
        waiting_patients_count = Visit.query.filter_by(status='waiting').order_by(Visit.check_in_time).count()
    except IntegrityError as e:  # Handle specific exceptions
        flash(f'Error updating dashboard: {str(e)}', 'danger')
    return render_template('doctor_dashboard.html', 
                           waiting_patients=waiting_patients, 
                           waiting_patients_count=waiting_patients_count,
                           current_user=current_user, 
                           search_form=search_form,
                           year=year,
                           page=page,
                           per_page=per_page,
                           )

@app.route('/pharmacy_dashboard')
@login_required
def pharmacist_dashboard():
    page = request.args.get("page", 1, type=int)
    per_page = 20
    search_form = SearchForm()
    today = date.today()
    formatted_date = today.strftime("%d %b %y")
    if current_user.role != 'pharmacist':
        flash("Access denied!", 'danger')
        return redirect(url_for('login'))
    try:
        waiting_patients = Medical.query.filter_by(prescription_status='waiting').order_by(Medical.date_reported_sick).all()
    except IntegrityError as e:  # Handle specific exceptions
        flash(f'Error updating dashboard: {str(e)}', 'danger')
    return render_template('pharmacy_dashboard.html', 
                           waiting_patients=waiting_patients, 
                           current_user=current_user, 
                           search_form=search_form,
                           today=formatted_date,
                           year=year,
                           page=page,
                           per_page=per_page,
                           )


@app.route('/cadets_brigade')
@login_required
def cadets_brigade_dashboard():
    page = request.args.get("page", 1, type=int)
    per_page = 20
    search_form = SearchForm()
    today = date.today()
    if current_user.role != 'cadets_brigade':
        flash("Access denied!", 'danger')
        return redirect(url_for('login'))
    
    logged_in = session.query(Staff).filter(Staff.status=='active').all()
    admitted_cadets = session.query(Cadet).filter(Cadet.admission_date==today).all()
    admitted_cadets_count = session.query(Cadet).filter(Cadet.admission_date==today).count()
    sick_report = session.query(Visit).filter(Visit.check_in_time==today).distinct().all()
    sick_report_count = session.query(Visit).filter(Visit.check_in_time==today).count()
    formatted_date = today.strftime("%d %b %y")

    return render_template('cadets_brigade_dashboard.html', 
                           admitted_cadets=admitted_cadets,
                           admitted_cadets_count=admitted_cadets_count,
                           sick_report=sick_report,
                           sick_report_count=sick_report_count,
                           today=formatted_date,
                           current_user=current_user,
                           logged_in=logged_in, 
                           search_form=search_form,
                           year=year,
                           page=page,
                           per_page=per_page,
                           )


@app.route('/update_visit_status/<int:visit_id>', methods=['POST'])
@login_required
def update_visit_status(visit_id):
    visit = Visit.query.get_or_404(visit_id)
    if current_user.role != 'doctor':
        flash('You are not authorized to perform this action.', 'danger')
        return redirect(url_for('doctor_dashboard'))

    new_status = request.form.get('status')
    if new_status not in ['waiting', 'in progress', 'completed']:
        flash('Invalid status update.', 'warning')
        return redirect(url_for('doctor_dashboard'))
    
    visit.status = new_status

    try:
        db.session.commit()  # Commit transaction explicitly
        socketio.emit('update_visit_status', {'id': visit.id, 'status': new_status})
        flash('Patient status updated successfully.', 'success')
    except IntegrityError as e:  # Handle specific exceptions
        db.session.rollback()  # Rollback transaction on error
        flash(f'Error updating status: {str(e)}', 'danger')

    return redirect(url_for('doctor_dashboard'))


@app.route('/update_prescription_status/<int:id>', methods=['POST'])
@login_required
def update_prescription_status(id):
    prescription = Medical.query.get_or_404(id)
    if current_user.role != 'pharmacist':
        flash('You are not authorized to perform this action.', 'danger')
        return redirect(url_for('home'))

    new_status = request.form.get('prescription_status')
    if new_status not in ['waiting', 'in progress', 'completed']:
        flash('Invalid status update.', 'warning')
        return redirect(url_for('pharmacist_dashboard'))
    
    prescription.prescription_status = new_status

    try:
        db.session.commit()  # Commit transaction explicitly
        socketio.emit('update_prescription_status', {'id': prescription.id, 'status': new_status})
        flash('Patient status updated successfully.', 'success')
    except IntegrityError as e:  # Handle specific exceptions
        db.session.rollback()  # Rollback transaction on error
        flash(f'Error updating status: {str(e)}', 'danger')

    return redirect(url_for('pharmacist_dashboard'))


@app.route('/cadet/medical/<int:id>', methods=['GET', 'POST'])
@login_required
def add_medical_record(id):
    search_form = SearchForm()
    medical_record_form = MedicalRecordForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    selected_cadet = session.query(Cadet).filter(Cadet.id == id).first()
    cadet_medical_records = session.query(Medical).filter(Medical.cadet_id == id).all()

    if medical_record_form.validate_on_submit():
        history = medical_record_form.history.data
        examination = medical_record_form.examination.data
        diagnosis = medical_record_form.diagnosis.data
        plan = medical_record_form.plan.data
        prescription = medical_record_form.prescription.data
        excuse_duty = medical_record_form.excuse_duty.data
        excuse_duty_days = medical_record_form.excuse_duty_days.data
        admission_count_value = int(medical_record_form.admission_count.data)

        # Ensure date_reported_sick is a proper date object
        date_reported_sick = medical_record_form.date_reported_sick.data
        if isinstance(date_reported_sick, datetime):
            date_reported_sick = date_reported_sick.date()

        # Check for duplicate record
        existing_record = db.session.query(Medical).filter_by(
            date_reported_sick=date_reported_sick,
            history=history,
            examination=examination,
            diagnosis=diagnosis,
            plan=plan,
            prescription=prescription,
            excuse_duty=excuse_duty,
            excuse_duty_days=excuse_duty_days,
            cadet_id=id
        ).first()

        if existing_record:
            flash('A similar medical record already exists.', 'error')
        else:
            # Check if the cadet has already been admitted on the same day
            same_day_admission = db.session.query(Medical).filter(
                Medical.cadet_id == id,
                func.date(Medical.date_reported_sick) == date_reported_sick
            ).first()

            # Create a new MedicalRecord object and add it to the database
            new_medical_record = Medical(
                date_reported_sick=date_reported_sick,
                history=history,
                examination=examination,
                diagnosis=diagnosis,
                plan=plan,
                prescription=prescription,
                excuse_duty=excuse_duty,
                excuse_duty_days=excuse_duty_days,
                admission_count=admission_count_value,
                cadet_id=id,
            )

            # If the cadet has not been admitted on the same day, increment admission count
            if not same_day_admission:
                selected_cadet.admission_count += 1
                selected_cadet.admission_date = datetime.now().date()
                new_medical_record.admission_count = selected_cadet.admission_count

            session.add(new_medical_record)
            session.add(selected_cadet)  # Ensure cadet updates are included
            session.commit()
            flash('Medical record was added successfully.', 'success')
            return redirect(url_for('add_medical_record', id=id))
        
    return render_template('add_medical_record.html',
                           cadet=selected_cadet,
                           rows=cadet_medical_records,
                           id=id, 
                           medical_record_form=medical_record_form,
                           year=year,
                           page=page,
                           per_page=per_page,
                           search_form=search_form
                           )
        

@app.route('/admit_cadet', methods=['GET', 'POST'])
@login_required
def nurse_dashboard():
    search_form = SearchForm()  # Assuming you have a SearchForm defined

    if request.method == 'POST':
        selected_cadets_json = request.json.get('selectedCadets')
        if selected_cadets_json is None:
            flash("Error: No data received or invalid JSON format.")
            return redirect(url_for('nurse_dashboard'))

        # Convert each string in cadet_list to a list of strings separated by spaces
        selected_cadets_list = [cadet_string.split(" ") for cadet_string in selected_cadets_json]
        # Process the selected cadets JSON data as needed
        # For example, you can parse the JSON and access individual cadet details
        for cadet in selected_cadets_list:
            admitted_cadet = session.query(Cadet).filter(Cadet.cadet_no == cadet[1]).first()
            if admitted_cadet:
                # Check if the cadet has already been admitted today
                if admitted_cadet.admission_date == date.today():
                    flash(f"Cadet NDA/ {cadet[1]} has already been admitted today.", "info")
                else:
                    admitted_cadet.admission_count += 1
                    admitted_cadet.admission_date = date.today()  # Set admission date
                    session.commit()
                    flash(f"Cadet {cadet[1]} has been admitted successfully.", "success")
            else:
                flash(f"Error: Cadet {cadet[1]} not found in the database.", "error")

        # Redirect to the same page after processing all cadets
        return redirect(url_for('admitted_cadets'))

    # Handle GET request to render the template
    return render_template('add_admitted.html', search_form=search_form)


@app.route('/admitted_cadets')
def admitted_cadets():
    search_form = SearchForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    today_date = date.today()
    admitted_cadets = db.session.query(Cadet).filter(Cadet.admission_date==today_date).options(
        joinedload(Cadet.service), 
        joinedload(Cadet.bn), 
        joinedload(Cadet.regular_course)
        ).all()
    today_date = str(today_date)

    today_date_obj = datetime.strptime(today_date, '%Y-%m-%d')
    formatted_today_date = today_date_obj.strftime('%d %B %Y').lstrip('0').replace(' 0', ' ')
    
    return render_template('admitted_cadets.html', 
                           search_form=search_form, 
                           rows=admitted_cadets,
                           year=year,
                           page=page,
                           per_page=per_page,
                           today=formatted_today_date
                           )

@app.route('/remove_medical/<int:id>/<int:cadet_id>', methods=['GET'])
def remove_medical_record(id, cadet_id):
    # Remove a Course from the database.
    search_form=SearchForm()
    medical_record_form = MedicalRecordForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20

    # Query the cadet and medical record 
    selected_cadet = session.query(Cadet).filter(Cadet.id==cadet_id).first()
    cadet_medical_record = session.query(Medical).filter(Medical.cadet_id==cadet_id).all()
    
    # Retrieve the score to be deleted from the database
    record_to_delete = session.query(Medical).filter(Medical.id==id).first()
    
    if record_to_delete:
        # Delete the record from the database
        session.delete(record_to_delete)
        session.commit()
        flash('Medical record deleted successfully.')
    else:
        flash('Record not found')

    # Redirect to a page after deleton
    return redirect(url_for('add_medical_record', 
                            id=cadet_id,
                            search_form=search_form, 
                            year=year,
                            page=page,
                            per_page=per_page,
                            medical_record_form=medical_record_form,
                            selected_cadet=selected_cadet,
                            cadet_medical_record=cadet_medical_record
                            ))
   
@app.route("/add_cadet", methods=['GET', 'POST'])
def add_cadet():
    add_cadet_form = AddCadetForm()
    search_form = SearchForm()
    
    # Get the selected state from the form submission
    selected_state = add_cadet_form.state.data # Convert state name to lowercase
    
    # Dynamically populate the LGA choices based on the selected state
    if selected_state:
        selected_state = selected_state.capitalize()
        # Fetch the LGAs based on the selected state from your `state_lga_data`
        lgas = state_lga_data.get(selected_state, [])
        
        add_cadet_form.lga.choices = [(lga, lga) for lga in lgas]

    if add_cadet_form.validate_on_submit():
        cadet_no = (add_cadet_form.cadet_no.data).upper()
        first_name = add_cadet_form.first_name.data
        middle_name = add_cadet_form.middle_name.data
        last_name = add_cadet_form.last_name.data
        religion = add_cadet_form.religion.data
        state = add_cadet_form.state.data
        lga = add_cadet_form.lga.data
        bn = add_cadet_form.bn.data
        doe = add_cadet_form.doe.data
        dob = add_cadet_form.dob.data
        department = add_cadet_form.department.data
        bn = add_cadet_form.bn.data
        gender = add_cadet_form.gender.data
        service = add_cadet_form.service.data
        regular_course_name = add_cadet_form.regular_course.data
        
        # Check if a cadet with the same cadet_no already exists.
        existing_cadet = session.query(Cadet).filter_by(cadet_no=cadet_no).first()

        if existing_cadet:
            # Handle the case where a cadet with the same cadet_no already exists
            # For example, you can return an error message or redirect the user back to the form
            flash("A cadet with this cadet number already exists.", "error")
            return redirect(url_for('add_cadet'))
        
        department_instance = Department.query.filter_by(department_name=department).first()
        bn_instance = Battalion.query.filter_by(bn=bn).first()
        gender_instance = Gender.query.filter_by(gender_type=gender).first()
        service_instance = Service.query.filter_by(service_type=service).first()
        
        # Check the regular_course table to see if regular_course_name is in database
        regular_course_instance = RegularCourse.query.filter_by(course_no=regular_course_name).first()
        
        # If the regular course exists, use the existing instance
        if not regular_course_instance:
            regular_course_instance = RegularCourse(course_no=regular_course_name)
            session.add(regular_course_instance)
            session.commit()
        
        # Create a new instance and enter into the database   
        new_cadet = Cadet(
            cadet_no=cadet_no, 
            first_name=first_name, 
            middle_name=middle_name,
            last_name=last_name, 
            religion=religion, 
            state=state, 
            lga=lga,
            bn=bn_instance, 
            date_of_enlistment=doe, 
            date_of_birth=dob, 
            department=department_instance, 
            gender=gender_instance,
            service=service_instance, 
            regular_course=regular_course_instance
            )
        session.add(new_cadet)
        session.commit()
        flash("Cadet added successfully.", "success")
        return redirect(url_for('add_cadet'))
    return render_template('add_cadet.html', add_cadet_form=add_cadet_form, search_form=search_form, year=year)

@app.route("/department")
def add_department():
    try:
        with open("departments.csv", 'r') as file:
            csv_reader = csv.reader(file)
            for row in csv_reader:
                department_id = int(row[0])
                department_name = row[1]
                faculty_id = int(row[2])

                new_department = Department(
                    id=department_id,
                    department_name=department_name,
                    faculty_id=faculty_id
                )
                    
                session.add(new_department)
                session.commit()

        return redirect(url_for('home'))
    except FileNotFoundError:
        return "csv file not found"
    except Exception as e:
        db.session.rollback()
        return f"An error occurred: {e}"

    
@app.route("/addallcadets")
def add_all_cadets():
    try:
        with open("cadets_nom.csv", 'r') as file:
            csv_reader = csv.reader(file)
            for row in csv_reader:
                cadet_id = int(row[0])
                cadet_no = row[1]
                first_name = row[2]
                middle_name = row[3]
                last_name = row[4]
                religion = row[5]
                state = row[6]
                lga = row[7]
                date_of_enlistment = row[8]
                date_of_birth = row[9]
                department_id = int(row[10])
                bn_id = int(row[11])
                gender_id = int(row[12])
                service_id = int(row[13])
                regular_id = int(row[14])

                new_cadet = Cadet(
                    id=cadet_id,
                    cadet_no=cadet_no,
                    first_name=first_name,
                    middle_name=middle_name,
                    last_name=last_name,
                    religion=religion,
                    state=state,
                    lga=lga,
                    date_of_enlistment=date_of_enlistment,
                    date_of_birth=date_of_birth,
                    department_id=department_id,
                    bn_id=bn_id,
                    gender_id=gender_id,
                    service_id=service_id,
                    regular_id=regular_id
                )
                    
                session.add(new_cadet)
                session.commit()

        return redirect(url_for('home'))
    except FileNotFoundError:
        return "csv file not found"
    except Exception as e:
        db.session.rollback()
        return f"An error occurred: {e}"
        

# @app.route("/delete_cadet/<int:id>", methods=['GET','POST'])
# def delete_cadet(id):
#     search_form=SearchForm()
#     # Retrieve the cadet to be deleted from the database
#     cadet_to_delete = session.query(Cadet).filter_by(id=id).first()
    
#     if request.method == "POST":
#         # Delete the cadet from the database
#         db.session.delete(cadet_to_delete)
#         db.session.commit()
#         # Redirect to a page after deleton
#         return redirect(url_for('home'))
    
#     # Render a confirmation page before deletion
#     return render_template("confirm_delete.html", cadet=cadet_to_delete, cadet_id=cadet_to_delete.id, search_form=search_form)

if __name__=="__main__":
    app.run(debug=True, port=5000)