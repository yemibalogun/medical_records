from models import Cadet, RegularCourse, Staff
from config import app, db
import time
from models import Cadet


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

def roles():
    roles = db.session.query(Staff.role).all()
    unique_roles = list(set(role for (role,) in roles))  # Use a set to ensure uniqueness and then convert back to list
    role_dict = {index: role for index, role in enumerate(unique_roles)}
    
    return role_dict
