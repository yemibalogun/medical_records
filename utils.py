from models import Cadet, RegularCourse, ServiceScore
from config import app, db
from sqlalchemy.sql import func
from sqlalchemy.orm import Session
import time
from datetime import datetime
import os
from models import ServiceSubject, Score, Cadet


MAX_RETRIES = 3
RETRY_DELAY = 1 #seconds

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def insert_cadet(row):
    retries = 0
    while retries < MAX_RETRIES:
            try:
                with app.app_context():   # Ensure working within the application context
                    new_record = Cadet(
                        id = row[0],
                        cadet_no = row[1],
                        first_name = row[2],
                        middle_name = row[3],
                        last_name = row[4],
                        religion = row[5],
                        state = row[6],
                        lga = row[7],
                        date_of_enlistment = row[8],
                        date_of_birth = row[9],
                        department_id = row[10],
                        bn_id = row[11],
                        gender_id = row[12],
                        service_id = row[13],
                        regular_id = row[14]
                    )   
                    db.session.add(new_record)
                    db.session.commit()
                break   # Exit the loop if successful
            except Exception as e:
                print(f"An error occurred: {e}")
                db.session.rollback()
                retries += 1
                time.sleep(RETRY_DELAY)
    else:
        print("Max retries reached. Failed to insert record.")
                
                
def course_details(regular_id):
            course_num = db.session.query(RegularCourse).filter(RegularCourse.id==regular_id).first()
            
            cse_count = db.session.query(Cadet).filter(Cadet.regular_id == regular_id).count() 
            army_str = db.session.query(Cadet).filter(Cadet.service_id == 1, Cadet.regular_id == f"{regular_id}").count()
            navy_str = db.session.query(Cadet).filter(Cadet.service_id == 2, Cadet.regular_id == f"{regular_id}").count()
            airforce_str = db.session.query(Cadet).filter(Cadet.service_id == 3, Cadet.regular_id == f"{regular_id}").count()
            male_str = db.session.query(Cadet).filter(Cadet.gender_id == 1, Cadet.regular_id == f"{regular_id}").count()
            female_str = db.session.query(Cadet).filter(Cadet.gender_id == 2, Cadet.regular_id == f"{regular_id}").count()

            result_dict = {
                'course': course_num,
                'course_total': cse_count,
                'army': army_str,
                'navy': navy_str,
                'airforce': airforce_str,
                'male': male_str,
                'female': female_str
                }
            return result_dict
        
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# Function to get regular course details available in database
def regular_courses():
    course = db.session.query(RegularCourse).all()
    course_dict = {}

    for course_object in course:
        key = course_object.id
            
        course_dict[key] = [course_object.course_no]  
    return course_dict

# Function to filter service subjects to
def filtered_subjects(id):
        results=[]
        selected_cadet = db.session.query(Cadet).filter(Cadet.id==id).first()
        selected_cadet_service_id = selected_cadet.service_id
        service_subjects = db.session.query(ServiceSubject).filter(ServiceSubject.service_id==selected_cadet_service_id).all()
        for subject in service_subjects:
            tuple_item=(subject.subject_title, subject.subject_title.title())
            results.append(tuple_item)
        
        return results

# Function to get total first term service scores

def get_total_first_term_score(cadet_id):
     # Query the ServiceScore table and calculate the sum of first term scores for the given cadet ID
     total_first_term_score = db.session.query(func.sum(ServiceScore.first_term_score)).filter(ServiceScore.cadet_id==cadet_id).scalar()

     return total_first_term_score

def get_total_second_term_score(cadet_id):
     
     # Query the ServiceScore table and calculate the sum of first term scores for the given cadet ID
     total_second_term_score = db.session.query(func.sum(ServiceScore.second_term_score)).filter(ServiceScore.cadet_id==cadet_id).scalar()

     return total_second_term_score


def get_cadet_performance():
     # Query to calculate total scores for each cadet and order the results by total score
    query = (db.session.query(Cadet.id, Cadet.name, func.sum(ServiceScore.first_term_score).label('total_score'))
     .join(ServiceScore, ServiceScore.cadet_id==Cadet.id)
     .group_by(Cadet.id, Cadet.name)
     .order_by(func.sum(ServiceScore.first_term_score).desc())
)
    # Execute the query and fetch all results
    cadet_performance = query.all()

    return cadet_performance


def log_score_change(new_score, timestamp=None, filename='score_log.txt'):
    if timestamp is None:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    log_entry = f"{timestamp}: New score for {new_score.cadet.first_name} {new_score.cadet.middle_name} {new_score.cadet.last_name} - {new_score}\n"

    try:
        with open(filename, 'a') as file:
            file.write(log_entry)
        
        # Set file permissions to make the file read-only for others
        current_permissions = os.stat(filename).st_mode
        new_permissions = current_permissions & ~0o222  # Removes write permission for all users
        os.chmod(filename, new_permissions)
        
        # Log the new permissions
        new_permissions_str = oct(new_permissions)[-3:]  # Convert permissions to octal string format
        with open(filename, 'a') as file:
            file.write(f"{timestamp}: Changed file permissions to {new_permissions_str}\n")

    except (FileNotFoundError, PermissionError) as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")




# Function to calculat the GPA and CGPA for a cadet
def calculate_gpa_cpga(cadet_id):
    # Retrieve all scores for the cadet with the given ID
    cadet_scores = db.session.query(Score).filter(Score.cadet_id == cadet_id).all()

    total_grade_points = 0
    total_units = 0

    # Define the grade points and score ranges
    grade_points = {'A': 5, 'B': 4, 'C': 3, 'D': 2, 'E': 1, 'F': 0}
    score_ranges = {'A': (70, 100), 'B': (60, 69), 'C': (50, 59), 'D': (45, 49), 'E': (40, 44), 'F': (0, 39)}

    for score in cadet_scores:
        # Determine the grade for each course based on the score
        grade = ''
        for key, value in score_ranges.items():
            if value[0] <= (score.first_semester_score + score.second_semester_score) / 2 <= value[1]:
                grade = key
                break

        if grade:
            # Calculate total grade points based on grade and course units
            total_grade_points += grade_points[grade] * score.course.units
            # Calculate total units
            total_units += score.course.units

    # Calculate GPA
    if total_units > 0:
        gpa = total_grade_points / total_units
    else:
        gpa = 0

    # Calculate CGPA (assuming previous CGPA is stored in the Cadet model)
    cadet = db.session.query(Cadet).get(cadet_id)
    cgpa = cadet.cgpa if cadet.cgpa else 0  # Use existing CGPA if available, otherwise start with 0

    # Total Quality Points
    tqp = (cgpa * cadet.total_units + gpa * total_units)
    # Calculate new CGPA using the formula: new_cgpa = (old_cgpa * total_previous_units + gpa * total_current_units) / (total_previous_units + total_current_units)
    if tqp == 0:
         new_cgpa = 0
    else:
         new_cgpa = tqp / (cadet.total_units + total_units)

    return gpa, new_cgpa


# # Function to calc CGPA
# def calc_cgpa():
#     grade_point= {
#         'A': '5',
#         'B': '4',
#         'C': '3',
#         'D': '2',
#         'E': '1',
#         'F': '0'
#         }
#     grade_point_average =

