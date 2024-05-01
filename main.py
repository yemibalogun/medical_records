from flask import render_template, redirect, url_for, send_file, request, jsonify, session, flash
from forms import EditForm, SearchForm, AddCadetForm, ScoreForm, MilScoreForm, MedicalRecordForm
from config import app, db, session
from werkzeug.utils import secure_filename
from models import  Cadet, RegularCourse, Department, Course, Gender, Battalion, Service, ServiceSubject, Score, ServiceScore, Medical
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import declarative_base, relationship, aliased
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy import or_
from flask_bootstrap import Bootstrap
from flask_migrate import Migrate
from concurrent.futures import ThreadPoolExecutor
from PIL import Image
import csv, io, os, time, json
from datetime import datetime 
from utils import regular_courses, filtered_subjects, get_total_first_term_score, get_total_second_term_score, log_score_change, calculate_gpa_cpga


year = datetime.now().year
migrate = Migrate(app, db)
Bootstrap(app)

# Pass Stuff to NavBar
@app.context_processor
def base():
    form = SearchForm()
    course = regular_courses() # Assuming this returns a dictionary
      
    return {
        'form_dict': dict(form=form),
        'course_dict': course,
        }

# Create a session
session = db.session

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
                'bn': cadet.bn.bn.capitalize(),
                'service': cadet.service.service_type.capitalize(),
                'gender': cadet.gender.gender_type,
                'religion': cadet.religion,
                'state': cadet.state,
                'lga': cadet.lga,
                'enlistment_date': cadet.date_of_enlistment,
                'dob': cadet.date_of_birth,
                'department': cadet.department.department_name.title(),
                'course': cadet.regular_course.course_no,
                'student_info_url':  url_for('student_info',  id=cadet.id)
            }

            results.append(cadet_dict)
        # Serialize the list of dictionaries to JSON format
        cadets_json = json.dumps(results)

        return cadets_json
            
    else:
        # Return an empty array if no results found
        return jsonify([]) 

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
        ).all()
        
    return render_template("search.html", search_form=search_form, rows=name_search)

@app.route("/")
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

@app.route("/course/<int:id>/<int:bn_id>", methods=["GET"])  
def select_course_bn(id, bn_id):
    search_form = SearchForm()
    page = request.args.get("page", 1, type=int)
    per_page = 20

    course_cadets = session.query(Cadet).filter(Cadet.regular_id == id, Cadet.bn_id == bn_id).all()
    course_no = session.query(RegularCourse).filter(RegularCourse.id == id).first()
    battalion = session.query(Battalion).filter(Battalion.id == bn_id).first()
    other_bn = session.query(Battalion).filter(Battalion.id != bn_id).all()
    
    start = (page - 1) * per_page
    end = start + per_page
    paginated_cadets = course_cadets[start:end]
    
    course = session.query(RegularCourse).all()
    course_dict = {}

    for course_object in course:
        key = course_object.id
        cse_count = session.query(Cadet).filter(Cadet.regular_id == key).count() 
        course_dict[key] = [course_object.course_no, cse_count]   

    course_cadets_count = session.query(Cadet).filter(Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    
    army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    army_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.service_id == 1, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    army_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.service_id == 1, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    
    navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    navy_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.service_id == 2, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    navy_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.service_id == 2, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    
    airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    airforce_male_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.service_id == 3, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    airforce_female_cdts_count = session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.service_id == 3, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    
    return render_template("bn.html",
                           search_form=search_form, 
                           cadets=paginated_cadets,
                           battalion=battalion,
                           other_bn=other_bn,
                           page=page,
                           per_page=per_page,
                           total=len(course_cadets),
                           rows=course_cadets, 
                           bn_id=bn_id,
                           course=id,
                           course_no=course_no,
                           course_dict=course_dict,
                           course_cadets_count=course_cadets_count,
                           army_cdts_count=army_cdts_count,
                           navy_cdts_count=navy_cdts_count, 
                           airforce_cdts_count=airforce_cdts_count,
                           male_cdts_count=male_cdts_count,
                           female_cdts_count=female_cdts_count,
                           army_male_cdts_count=army_male_cdts_count,
                           army_female_cdts_count=army_female_cdts_count,
                           navy_male_cdts_count=navy_male_cdts_count,
                           navy_female_cdts_count=navy_female_cdts_count,
                           airforce_male_cdts_count=airforce_male_cdts_count,
                           airforce_female_cdts_count=airforce_female_cdts_count,
                           year=year
                           )

@app.route("/course/<int:id>/<int:bn_id>/<int:service_id>", methods=["GET"])  
def select_course_bn_service(id, bn_id, service_id):
    search_form = SearchForm()
    page = request.args.get("page", 1, type=int)
    per_page = 20

    course_cadets = session.query(Cadet).filter(Cadet.regular_id == id, Cadet.bn_id == bn_id, Cadet.service_id == service_id).all()
    course_no = session.query(RegularCourse).filter(RegularCourse.id == id).first()
    battalion = session.query(Battalion).filter(Battalion.id == bn_id).first()
    service = session.query(Service).filter(Service.id == service_id).first()
    other_bn = session.query(Battalion).filter(Battalion.id != bn_id).all()
    
    start = (page - 1) * per_page
    end = start + per_page
    paginated_cadets = course_cadets[start:end]
    
    course = session.query(RegularCourse).all()
    course_dict = {}

    for course_object in course:
        key = course_object.id
        cse_count = session.query(Cadet).filter(Cadet.regular_id == key).count() 
        course_dict[key] = [course_object.course_no, cse_count]   

    course_cadets_count = session.query(Cadet).filter(Cadet.regular_id == id, Cadet.bn_id == bn_id, Cadet.service_id == service_id).count()
    army_cdts_count = session.query(Cadet).filter(Cadet.service_id == 1, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    navy_cdts_count = session.query(Cadet).filter(Cadet.service_id == 2, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()
    airforce_cdts_count = session.query(Cadet).filter(Cadet.service_id == 3, Cadet.regular_id == id, Cadet.bn_id == bn_id).count()

    return render_template("service.html",
                           search_form=search_form, 
                           cadets=paginated_cadets,
                           battalion=battalion,
                           service=service,
                           other_bn=other_bn,
                           page=page,
                           per_page=per_page,
                           total=len(course_cadets),
                           rows=course_cadets, 
                           bn_id=bn_id,
                           course=id,
                           course_no=course_no,
                           course_dict=course_dict,
                           course_cadets_count=course_cadets_count,
                           army_cdts_count=army_cdts_count,
                           navy_cdts_count=navy_cdts_count, 
                           airforce_cdts_count=airforce_cdts_count,
                           year=year
                           )

@app.route("/edit/<int:id>", methods=["GET", "POST"])
def edit_cadet(id):
    search_form=SearchForm()
    edit_form=EditForm()
    
    selected_cadet = session.query(Cadet).filter_by(id=id).first()
    # form = AddCadetForm(obj=selected_cadet)
    if edit_form.validate_on_submit():
        edit_form.populate_obj(selected_cadet)
        
        # Handlng date fields
        # You might need to convert the date format based on your form and database structure
        selected_cadet.doe = edit_form.doe.data.strftime('%Y-%m-%d')
        selected_cadet.dob = edit_form.dob.data.strftime('%Y-%m-%d')
        
        # Handling radio buttons 
        selected_cadet.religion_id = edit_form.religion.data
        selected_cadet.gender_id = edit_form.gender.data

        session.commit()
        return redirect(url_for('home'))
    
    # Process the form to populate form fields with selected_Cadet data
    edit_form.process(obj=selected_cadet)

    return render_template("edit.html", row=selected_cadet, edit_form=edit_form, year=year, search_form=search_form)

@app.route("/dashboard/<int:id>", methods=["GET","POST"])
def student_info(id):
    search_form = SearchForm()
    gpa, cgpa = calculate_gpa_cpga(id)
    print(gpa, cgpa)
    
    cadet_scores = session.query(ServiceScore).filter(ServiceScore.cadet_id==id).all()
    major_scores = session.query(ServiceScore).join(ServiceSubject).filter(ServiceScore.cadet_id==id, ServiceScore.service_subject_id==ServiceSubject.id, ServiceSubject.status=='major').all()
    
    minor_scores = session.query(ServiceScore).join(ServiceSubject).filter(ServiceScore.cadet_id==id, ServiceScore.service_subject_id==ServiceSubject.id, ServiceSubject.status=='minor').all()
    
    major_scores_processed = []
    for score in major_scores:
        major_subject_title = score.service_subject.subject_title
        major_total_score = (score.first_term_score + score.second_term_score)/2
        major_scores_processed.append([major_subject_title, major_total_score])

    minor_scores_processed = []
    for score in minor_scores:
        minor_subject_title = score.service_subject.subject_title
        minor_total_score = (score.first_term_score + score.second_term_score)/2
        minor_scores_processed.append([minor_subject_title, minor_total_score])
    
    try:
        selected_cadet = session.query(Cadet).join(Battalion).filter(Cadet.id == id, Cadet.bn_id == Battalion.id).first()
        
        dob_str = selected_cadet.date_of_birth
        doe_str = selected_cadet.date_of_enlistment

        dob_obj = datetime.strptime(dob_str, '%Y-%m-%d')
        doe_obj = datetime.strptime(doe_str, '%Y-%m-%d')
        dob_year = dob_obj.year
        current_year = datetime.now().year
        cadet_age = current_year - dob_year
        print(cadet_age)
        
        formatted_dob = dob_obj.strftime('%d %B %Y').lstrip('0').replace(' 0', ' ')
        formatted_doe = doe_obj.strftime('%d %B %Y').lstrip('0').replace(' 0', ' ')
        
    except NoResultFound:
        return "Cadet not found", 404
    except ValueError as e:
        return f"Error: {e}", 500
    
    return render_template("dashboard.html",
                               search_form=search_form,
                               selected_cadet=selected_cadet,
                               rows=cadet_scores,
                               major_scores=major_scores_processed,
                               minor_scores=minor_scores_processed,
                               cadet_age=cadet_age,
                               formatted_dob=formatted_dob,
                               formatted_doe=formatted_doe
                               )

@app.route('/cadet/results/<int:id>', methods=['GET','POST'])
def add_academic_score(id):
    search_form = SearchForm()
    academic_score_form = ScoreForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20

    cadet_scores = session.query(Score).filter(Score.cadet_id==id).all()
    selected_cadet = session.query(Cadet).filter(Cadet.id==id).first()
    if academic_score_form.validate_on_submit():
        course_code = (academic_score_form.course.data).lower()
        first_semester_score = academic_score_form.first_semester_score.data
        second_semester_score = academic_score_form.second_semester_score.data

        selected_record =  session.query(Course).filter(Course.course_code==course_code).first()
        selected_course_id = selected_record.id
        academic_year = academic_score_form.academic_year.data
        

        # Create a new AcademicScore object and add it to the database
        new_score = Score(
            first_semester_score=first_semester_score,
            second_semester_score=second_semester_score,
            academic_year=academic_year,
            course_id=selected_course_id,
            cadet_id=selected_cadet.id,
        )
        session.add(new_score)
        session.commit()
        flash(f"{selected_record.course_code.upper()} was added successfully.")
        return redirect(url_for('add_academic_score', id=id))
    return render_template('add_academic_score.html',
                           search_form=search_form,
                           cadet=selected_cadet,
                           rows=cadet_scores,
                           id=id,
                           academic_score_form=academic_score_form,
                           year=year,
                           page=page,
                           per_page=per_page
                           )



@app.route('/cadet/military/<int:id>', methods=['GET','POST'])
def add_military_score(id):
    search_form = SearchForm()
    military_score_form = MilScoreForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    selected_cadet = session.query(Cadet).filter(Cadet.id==id).first()
    cadet_scores = session.query(ServiceScore).filter(ServiceScore.cadet_id==id).all()

    subject_title = (military_score_form.subject.data)
    first_term_score = military_score_form.first_term_score.data
    second_term_score = military_score_form.second_term_score.data
    service_subject = session.query(ServiceSubject).filter(ServiceSubject.subject_title==subject_title).first()
       
    service_year = military_score_form.service_year.data 
    # Filter choices based on arm of service (assuming 'arm_of_service' is a variable)
    filtered_choices = [(choice_value, choice_label) for choice_value, choice_label in filtered_subjects(id)]
        
    # Assign the filtered choices to the form's subject field
    military_score_form.subject.choices = sorted(filtered_choices)
    
    # Get total first_term_scores and use the round function to approximate
    total_first_term_score = round(get_total_first_term_score(id) or 0, 2)
    total_second_term_score = round(get_total_second_term_score(id)or 0, 2)

    if military_score_form.validate_on_submit():
        # Create a new ServiceScore object and add it to the database
        new_service_score = ServiceScore(
            first_term_score=first_term_score,
            second_term_score=second_term_score,
            service_year=service_year,
            service_subject_id=service_subject.id,
            cadet_id=selected_cadet.id,
        )

        session.add(new_service_score)
        session.commit()
        flash(f"{service_subject.subject_title.title()} was added successfully.")
        log_score_change(new_service_score, timestamp=None, filename='score_log.txt')
        return redirect(url_for('add_military_score', id=id))
    
    return render_template('add_military_score.html',
                           search_form=search_form,
                           cadet=selected_cadet,
                           rows=cadet_scores,
                           id=id,
                           military_score_form=military_score_form,
                           total_first_term_score=total_first_term_score,
                           total_second_term_score=total_second_term_score,
                           year=year,
                           page=page,
                           per_page=per_page
                           )


@app.route('/cadet/medical/<int:id>', methods=['GET','POST'])
def add_medical_record(id):
    search_form = SearchForm()
    medical_record_form = MedicalRecordForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    selected_cadet = session.query(Cadet).filter(Cadet.id==id).first()
    cadet_medical_records = session.query(Medical).filter(Medical.cadet_id==id).all()
    print(cadet_medical_records)

    diagnosis = medical_record_form.diagnosis.data
    excuse_duty_type = medical_record_form.excuse_duty_type.data 
    excuse_duty_days = medical_record_form.excuse_duty_days.data
    admitted = medical_record_form.admitted.data
    discharged = medical_record_form.discharged.data
    
    if medical_record_form.validate_on_submit():
        # Create a new MedicalRecord object and add it to the database
        new_medical_record = Medical(
            diagnosis=diagnosis,
            excuse_duty_type=excuse_duty_type,
            excuse_duty_days=excuse_duty_days,
            admitted=admitted,
            discharged=discharged,
            cadet_id=id,
        )

        session.add(new_medical_record)
        session.commit()
        flash(f"Medical record was added successfully.")
        return redirect(url_for('add_medical_record', id=id))
    
    return render_template('add_medical_record.html',
                           search_form=search_form,
                           cadet=selected_cadet,
                           rows=cadet_medical_records,
                           id=id,
                           medical_record_form=medical_record_form,
                           year=year,
                           page=page,
                           per_page=per_page
                           )

@app.route('/remove_course/<int:id>/<int:cadet_id>', methods=['GET'])
def remove_course(id, cadet_id):
    # Remove a Course from the database.
    search_form=SearchForm()
    academic_score_form = ScoreForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    # Begin a new session
    with db.session.begin():
        # Retrieve the score to be deleted from the database
        course_to_delete = session.query(Score).filter(Score.id==id).first()
        # Query the cadet and scores 
    
        selected_cadet = session.query(Cadet).filter(Cadet.id==cadet_id).first()
        cadet_scores = session.query(Score).filter(Score.cadet_id==cadet_id).all()
    
        if course_to_delete:
            # Delete the cadet from the database
            db.session.delete(course_to_delete)
            db.session.commit()
            flash('Course deleted successfully.')
        else:
            flash('Course not found')
            # Redirect to a page after deleton
            return redirect(url_for('add_academic_score', id=cadet_id))
    
    # Render the template with updated data
    return render_template('add_academic_score.html', 
                           id=selected_cadet.id, 
                           search_form=search_form,
                           rows=cadet_scores, 
                           cadet=selected_cadet,
                           academic_score_form=academic_score_form,
                           year=year,
                           page=page,
                           per_page=per_page
                           )


@app.route('/remove_subject/<int:id>/<int:cadet_id>', methods=['GET'])
def remove_service_subject(id, cadet_id):
    # Remove a Course from the database.
    search_form=SearchForm()
    military_score_form = MilScoreForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    # Begin a new session
    with db.session.begin():
        # Retrieve the score to be deleted from the database
        subject_to_delete = session.query(ServiceScore).filter(ServiceScore.id==id).first()
        # Query the cadet and scores 
    
        selected_cadet = session.query(Cadet).filter(Cadet.id==cadet_id).first()
        cadet_scores = session.query(Score).filter(Score.cadet_id==cadet_id).all()
    
        if subject_to_delete:
            # Delete the cadet from the database
            db.session.delete(subject_to_delete)
            db.session.commit()
            flash('Subject deleted successfully.')
        else:
            flash('Subject not found')
        # Redirect to a page after deleton
            return redirect(url_for('add_military_score', id=cadet_id))
        
    # Render the template with updated data
    return render_template('add_military_score.html', 
                           id=selected_cadet.id, 
                           search_form=search_form,
                           rows=cadet_scores, 
                           cadet=selected_cadet,
                           military_score_form=military_score_form,
                           year=year,
                           page=page,
                           per_page=per_page
                           )


@app.route('/remove_medical/<int:id>/<int:cadet_id>', methods=['GET'])
def remove_medical_record(id, cadet_id):
    # Remove a Course from the database.
    search_form=SearchForm()
    medical_record_form = MedicalRecordForm()

    page = request.args.get("page", 1, type=int)
    per_page = 20
    # Begin a new session
    with db.session.begin():
        # Retrieve the score to be deleted from the database
        record_to_delete = session.query(Medical).filter(Medical.id==id).first()
        # Query the cadet and scores 
    
        selected_cadet = session.query(Cadet).filter(Cadet.id==cadet_id).first()
        cadet_medical_record = session.query(Medical).filter(Medical.cadet_id==cadet_id).all()
    
        if record_to_delete:
            # Delete the cadet from the database
            db.session.delete(record_to_delete)
            db.session.commit()
            flash('Medical record deleted successfully.')
        else:
            flash('Record not found')
        # Redirect to a page after deleton
            return redirect(url_for('add_medical_record', id=cadet_id))
        
    # Render the template with updated data
    return render_template('add_medical_record.html', 
                           id=selected_cadet.id, 
                           search_form=search_form,
                           rows=cadet_medical_record, 
                           cadet=selected_cadet,
                           medical_record_form=medical_record_form,
                           year=year,
                           page=page,
                           per_page=per_page
                           )


@app.route('/upload/<int:id>', methods=['GET', 'POST'])
def upload(id):
    cadet = Cadet.query.get(id)
    form = EditForm(obj=cadet)
    if form.validate_on_submit():
        cadet.image = form.image.data
        
        return render_template('edit.html', cadet=cadet)

@app.route('/static/images/<filename>')
def uploaded_file(filename):
    return send_file(f'./static/images/{filename}', as_attachment=True)

@app.route("/add_cadet", methods=['GET', 'POST'])
def add_cadet():
    add_cadet_form = AddCadetForm()
    search_form = SearchForm()
    
    if add_cadet_form.validate_on_submit():
        cadet_no = add_cadet_form.cadet_no.data
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
        regular_course_instance = RegularCourse.query.filter_by(course_no=regular_course_name)
        
        # Check the regular_course table to see if regular_course_name is in database
        existing_regular_course = RegularCourse.query.filter_by(course_no=regular_course_name).first()
        
        # If the regular course exists, use the existing instance
        if existing_regular_course:
            regular_course_instance = existing_regular_course
        else:
            # Otherwise, create a new RegularCourse instance and add it to the database
            regular_course = RegularCourse(course_no=regular_course_name)
            session.add(regular_course)
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
    
    # with open("cadets_nom.csv", 'r') as file:
    #     csv_reader = csv.reader(file)

    #     # Use ThreadPoolExecutor to insert records concurrently
    #     with ThreadPoolExecutor(max_workers=5) as executor:
    #         executor.map(insert_cadet, csv_reader)     


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
    
@app.route("/allcourse")
def add_course():
    try:
        with open("courses.csv", 'r') as file:
            csv_reader = csv.reader(file)
            for row in csv_reader:
                course_id = int(row[0])
                course_code = row[1]
                course_title = row[2]
                units = int(row[3])
                status = row[4]
                department_id = int(row[5])

                new_course = Course(
                    id=course_id,
                    course_code=course_code,
                    course_title=course_title,
                    units=units,
                    status=status,
                    department_id=department_id
                )
                    
                session.add(new_course)
                session.commit()

        return redirect(url_for('home'))
    except FileNotFoundError:
        return "csv file not found"
    except Exception as e:
        db.session.rollback()
        return f"An error occurred: {e}"


@app.route("/all_military_subject")
def add_service_subject():
    try:
        with open("service_subjects.csv", 'r') as file:
            csv_reader = csv.reader(file)
            for row in csv_reader:
                subject_id = int(row[0])
                status = row[1]
                service_id = int(row[2])
                subject_code = row[3]
                subject_title = row[4].lower()

                new_subject = ServiceSubject(
                    id=subject_id,
                    status=status,
                    service_id=service_id,
                    subject_code=subject_code,
                    subject_title=subject_title
                )
                    
                session.add(new_subject)
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
        

@app.route("/delete_cadet/<int:id>", methods=['GET','POST'])
def delete_cadet(id):
    search_form=SearchForm()
    # Retrieve the cadet to be deleted from the database
    cadet_to_delete = session.query(Cadet).filter_by(id=id).first()
    
    if request.method == "POST":
        # Delete the cadet from the database
        db.session.delete(cadet_to_delete)
        db.session.commit()
        # Redirect to a page after deleton
        return redirect(url_for('home'))
    
    # Render a confirmation page before deletion
    return render_template("confirm_delete.html", cadet=cadet_to_delete, cadet_id=cadet_to_delete.id, search_form=search_form)

if __name__=="__main__":
    app.run(debug=True)