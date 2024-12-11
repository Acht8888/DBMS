from flask import Flask, render_template, request, redirect, session, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from datetime import datetime

app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Necessary for session and flash

# Database Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##BTL:1234@localhost:1521/XE'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Constants
PER_PAGE = 5  # Number of items per page for pagination

# Models
class Users(db.Model):
    __tablename__ = 'users'
    username = db.Column(db.String(50), primary_key=True)
    password = db.Column(db.String(100), nullable=False)
    user_role = db.Column(db.String(20), nullable=False)

class Student(db.Model):
    __tablename__ = 'student'
    username = db.Column(db.String(50), primary_key=True)
    student_id = db.Column(db.Integer, primary_key=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    gender = db.Column(db.String(1), nullable=False)
    dob = db.Column(db.Date)
    email = db.Column(db.String(100), nullable=False, unique=True)
    phone_number = db.Column(db.String(15), nullable=False, unique=True)
    address = db.Column(db.String(255))
    gpa = db.Column(db.Numeric(3, 2))
    status = db.Column(db.String(20))
    enrollment_year = db.Column(db.Integer)


class HealthRecord(db.Model):
    __tablename__ = 'healthrecord'
    student_id = db.Column(db.Integer, primary_key=True)
    record_id = db.Column(db.Integer, primary_key=True)
    medical_note = db.Column(db.String(500))
    allergy = db.Column(db.String(255))


class Teacher(db.Model):
    __tablename__ = 'teacher'
    teacher_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), nullable=False)
    fname = db.Column(db.String(50), nullable=False)
    lname = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.String(1), nullable=False)
    dob = db.Column(db.Date)
    email = db.Column(db.String(100), nullable=False, unique=True)
    phone_number = db.Column(db.String(15), nullable=False, unique=True)
    address = db.Column(db.String(255))
    years_of_exp = db.Column(db.Integer, nullable=False)


class Course(db.Model):
    __tablename__ = 'course'
    course_id = db.Column(db.Integer, primary_key=True)
    course_name = db.Column(db.String(100), nullable=False, unique=True)
    course_description = db.Column(db.String(255))


# Helper Functions
def getPaginatedItems(query, page):
    """Helper function to paginate query results."""
    try:
        page = int(page)
        if page < 1:
            raise ValueError
    except (ValueError, TypeError):
        page = 1
    return query.paginate(page=page, per_page=PER_PAGE, error_out=False)


def validateDate(date_str):
    """Validate and convert a string to a date object."""
    try:
        return datetime.strptime(date_str, '%Y-%m-%d').date()
    except (ValueError, TypeError):
        return None


def validateFloat(value):
    """Validate and convert a string to a float."""
    try:
        return float(value)
    except (ValueError, TypeError):
        return None


def validateInt(value):
    """Validate and convert a string to an integer."""
    try:
        return int(value)
    except (ValueError, TypeError):
        return None


# Routes

# Home Route (Login Page)
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        query = text("""
            SELECT username, user_role 
            FROM users 
            WHERE username = :username AND password = :password
        """)
        result = db.session.execute(query, {'username': username, 'password': password}).mappings().fetchone()

        if result:
            session['username'] = result['username']
            user_role = result['user_role']

            if user_role == 'student':
                return redirect(url_for('studentHome'))
            elif user_role == 'teacher':
                return redirect(url_for('teacherHome'))
            elif user_role == 'admin':
                return redirect(url_for('adminHome'))
        else:
            flash("Invalid username or password.", "error")
            return redirect(url_for('index'))

    return render_template('index.html')


# Logout Route
@app.route('/logout')
def logout():
    session.pop('username', None)
    # flash('You have been logged out successfully.', 'success')
    return redirect(url_for('index'))


# Admin Home
@app.route('/adminHome')
def adminHome():
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))
    return render_template('admin/adminHome.html', username=session['username'])

# ====================
# Account Management
# ====================

@app.route('/studentAccountDetail/<username>/<int:student_id>', methods=['GET'])
def studentAccountDetail(username, student_id):
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    student_user = Users.query.filter_by(username=username).first()
    student = Student.query.filter_by(username=username, student_id=student_id).first()
    if not student_user:
        flash('Student account not found.', 'error')
        return redirect(url_for('adminStudent'))

    return render_template('admin/studentAccountDetail.html', student_user=student_user, student=student)

@app.route('/changeStudentPassword', methods=['POST'])
def changeStudentPassword():
    username = request.form.get('username')
    new_password = request.form.get('new_password')
    confirm_password = request.form.get('confirm_password')

    if not all([username, new_password, confirm_password]):
        flash('All fields are required.', 'error')
        return redirect(url_for('studentAccountDetail', username=username, student_id=request.form.get('student_id')))

    if new_password != confirm_password:
        flash('Passwords do not match.', 'error')
        return redirect(url_for('studentAccountDetail', username=username, student_id=request.form.get('student_id')))

    user = Users.query.filter_by(username=username).first()

    if user:
        user.password = new_password

        try:
            db.session.commit()
            flash('Password updated successfully!', 'success')
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while updating the password.', 'error')
            app.logger.error(f"SQLAlchemyError while updating password: {e}")
    else:
        flash('User not found.', 'error')

    return redirect(url_for('studentAccountDetail', username=username, student_id=request.form.get('student_id')))

# ====================
# Student Management
# ====================

@app.route('/adminStudent', methods=['GET'])
def adminStudent():
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    page = request.args.get('page', 1)
    pagination = getPaginatedItems(Student.query.order_by(Student.student_id), page)
    students = pagination.items

    return render_template('admin/adminStudent.html', username=session['username'], students=students, pagination=pagination)


@app.route('/addStudent', methods=['POST'])
def addStudent():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    student_id = validateInt(request.form.get('student_id'))
    username = request.form.get('username')
    password = request.form.get('password')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')
    dob = validateDate(request.form.get('dob'))
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    gpa = validateFloat(request.form.get('gpa'))
    status = request.form.get('status')
    enrollment_year = validateInt(request.form.get('enrollment_year'))

    # Validation Checks
    if not all([student_id, username, password, fname, lname, gender, email, phone_number, gpa, enrollment_year]):
        flash('Please fill in all required fields.', 'error')
        return redirect(url_for('adminStudent'))

    if not (0 <= gpa <= 4.0):
        flash('GPA must be between 0 and 4.0.', 'error')
        return redirect(url_for('adminStudent'))

    if not dob:
        flash('Invalid date format for Date of Birth.', 'error')
        return redirect(url_for('adminStudent'))

    if enrollment_year < (dob.year + 18):
        flash(f'Enrollment year is invalid. The student must be at least 18 years old (DOB: {dob}).', 'error')
        return redirect(url_for('adminStudent'))

    # Create Student Instance
    new_student = Student(
        student_id=student_id,
        username=username,
        fname=fname,
        lname=lname,
        gender=gender,
        dob=dob,
        email=email,
        phone_number=phone_number,
        address=address,
        gpa=gpa,
        status=status,
        enrollment_year=enrollment_year
    )

    new_user = Users(
        username=username,
        password=password,
        user_role="student"
    )

    # Add to Database
    try:
        db.session.add(new_user)
        db.session.commit()
        db.session.add(new_student)
        db.session.commit()
        flash('Student added successfully!', 'success')
    except IntegrityError as ie:
        db.session.rollback()
        if 'unique constraint' in str(ie.orig).lower():
            flash('Username, Email or Phone Number already exists.', 'error')
        else:
            flash('Database Integrity Error: ' + str(ie.orig), 'error')
        app.logger.error(f"IntegrityError while adding student: {ie}")
    except SQLAlchemyError as e:
        db.session.rollback()
        flash('An error occurred while adding the student.', 'error')
        app.logger.error(f"SQLAlchemyError while adding student: {e}")
    except Exception as e:
        db.session.rollback()
        flash(f'Unexpected error: {e}', 'error')
        app.logger.error(f"Unexpected error while adding student: {e}")

    return redirect(url_for('adminStudent'))


@app.route('/deleteStudent', methods=['POST'])
def deleteStudent():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    student_id = validateInt(request.form.get('student_id'))
    username = request.form.get('username')

    if not student_id or not username:
        flash('Missing Student ID or Username.', 'error')
        return redirect(url_for('adminStudent'))

    student = Student.query.filter_by(username=username, student_id=student_id).first()
    user = Users.query.filter_by(username=username).first()

    if student:
        try:
            db.session.delete(student)
            db.session.commit()
            db.session.delete(user)
            db.session.commit()
            flash('Student deleted successfully!', 'success')
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while deleting the student.', 'error')
            app.logger.error(f"SQLAlchemyError while deleting student: {e}")
    else:
        flash('Student not found.', 'error')

    return redirect(url_for('adminStudent'))


@app.route('/editStudent', methods=['POST'])
def editStudent():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    student_id = validateInt(request.form.get('student_id'))
    username = request.form.get('username')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')
    dob = validateDate(request.form.get('dob'))
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    gpa = validateFloat(request.form.get('gpa'))
    status = request.form.get('status')
    enrollment_year = validateInt(request.form.get('enrollment_year'))

    # Validation Checks
    if not all([student_id, username, fname, lname, gender, email, phone_number, gpa, enrollment_year]):
        flash('Please fill in all required fields.', 'error')
        return redirect(url_for('adminStudent'))

    if not (0 <= gpa <= 4.0):
        flash('GPA must be between 0 and 4.0.', 'error')
        return redirect(url_for('adminStudent'))

    if not dob:
        flash('Invalid date format for Date of Birth.', 'error')
        return redirect(url_for('adminStudent'))

    if enrollment_year < (dob.year + 18):
        flash(f'Enrollment year is invalid. The student must be at least 18 years old (DOB: {dob}).', 'error')
        return redirect(url_for('adminStudent'))

    student = Student.query.filter_by(username=username, student_id=student_id).first()

    if student:
        # Update Student Details
        student.fname = fname
        student.lname = lname
        student.gender = gender
        student.dob = dob
        student.email = email
        student.phone_number = phone_number
        student.address = address
        student.gpa = gpa
        student.status = status
        student.enrollment_year = enrollment_year

        try:
            db.session.commit()
            flash('Student updated successfully!', 'success')
        except IntegrityError as ie:
            db.session.rollback()
            if 'unique constraint' in str(ie.orig).lower():
                flash('Email or Phone Number already exists.', 'error')
            else:
                flash('Database Integrity Error: ' + str(ie.orig), 'error')
            app.logger.error(f"IntegrityError while updating student: {ie}")
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while updating the student.', 'error')
            app.logger.error(f"SQLAlchemyError while updating student: {e}")
        except Exception as e:
            db.session.rollback()
            flash(f'Unexpected error: {e}', 'error')
            app.logger.error(f"Unexpected error while updating student: {e}")
    else:
        flash('Student not found.', 'error')

    return redirect(url_for('adminStudent'))


@app.route('/student/<username>/<int:student_id>', methods=['GET'])
def studentDetail(username, student_id):
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    student = Student.query.filter_by(username=username, student_id=student_id).first()

    if not student:
        flash('Student not found.', 'error')
        return redirect(url_for('adminStudent'))

    return render_template('admin/studentDetail.html', student=student)

# ====================
# Teacher Management
# ====================

@app.route('/adminTeacher', methods=['GET'])
def adminTeacher():
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    page = request.args.get('page', 1)
    pagination = getPaginatedItems(Teacher.query.order_by(Teacher.teacher_id), page)
    teachers = pagination.items

    return render_template('admin/adminTeacher.html', username=session['username'], teachers=teachers, pagination=pagination)


@app.route('/addTeacher', methods=['POST'])
def addTeacher():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    teacher_id = validateInt(request.form.get('teacher_id'))
    username = request.form.get('username')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')
    dob = validateDate(request.form.get('dob')) if request.form.get('dob') else None
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    years_of_exp = validateInt(request.form.get('years_of_exp'))

    # Validation Checks
    if not all([teacher_id, username, fname, lname, gender, email, phone_number, years_of_exp]):
        flash('Please fill in all required fields.', 'error')
        return redirect(url_for('adminTeacher'))

    if gender not in ['M', 'F']:
        flash("Invalid gender. Please select 'M' for Male or 'F' for Female.", 'error')
        return redirect(url_for('adminTeacher'))

    if years_of_exp < 0:
        flash('Years of Experience cannot be negative.', 'error')
        return redirect(url_for('adminTeacher'))

    if request.form.get('dob') and not dob:
        flash('Invalid date format for Date of Birth.', 'error')
        return redirect(url_for('adminTeacher'))

    # Create Teacher Instance
    new_teacher = Teacher(
        teacher_id=teacher_id,
        username=username,
        fname=fname,
        lname=lname,
        gender=gender,
        dob=dob,
        email=email,
        phone_number=phone_number,
        address=address,
        years_of_exp=years_of_exp
    )

    # Add to Database
    try:
        db.session.add(new_teacher)
        db.session.commit()
        flash('Teacher added successfully!', 'success')
    except IntegrityError as ie:
        db.session.rollback()
        if 'unique constraint' in str(ie.orig).lower():
            flash('Email or Phone Number already exists.', 'error')
        elif 'foreign key constraint' in str(ie.orig).lower():
            flash('Username does not exist. Please ensure the username is correct.', 'error')
        else:
            flash('Database Integrity Error: ' + str(ie.orig), 'error')
        app.logger.error(f"IntegrityError while adding teacher: {ie}")
    except SQLAlchemyError as e:
        db.session.rollback()
        flash('An error occurred while adding the teacher.', 'error')
        app.logger.error(f"SQLAlchemyError while adding teacher: {e}")
    except Exception as e:
        db.session.rollback()
        flash(f'Unexpected error: {e}', 'error')
        app.logger.error(f"Unexpected error while adding teacher: {e}")

    return redirect(url_for('adminTeacher'))


@app.route('/deleteTeacher', methods=['POST'])
def deleteTeacher():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    teacher_id = validateInt(request.form.get('teacher_id'))
    username = request.form.get('username')

    if not teacher_id or not username:
        flash('Missing Teacher ID or Username.', 'error')
        return redirect(url_for('adminTeacher'))

    teacher = Teacher.query.filter_by(username=username, teacher_id=teacher_id).first()

    if teacher:
        try:
            db.session.delete(teacher)
            db.session.commit()
            flash('Teacher deleted successfully!', 'success')
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while deleting the teacher.', 'error')
            app.logger.error(f"SQLAlchemyError while deleting teacher: {e}")
    else:
        flash('Teacher not found.', 'error')

    return redirect(url_for('adminTeacher'))


@app.route('/editTeacher', methods=['POST'])
def editTeacher():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    teacher_id = validateInt(request.form.get('teacher_id'))
    username = request.form.get('username')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')
    dob = validateDate(request.form.get('dob')) if request.form.get('dob') else None
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    years_of_exp = validateInt(request.form.get('years_of_exp'))

    # Validation Checks
    if not all([teacher_id, username, fname, lname, gender, email, phone_number, years_of_exp]):
        flash('Please fill in all required fields.', 'error')
        return redirect(url_for('adminTeacher'))

    if gender not in ['M', 'F']:
        flash("Invalid gender. Please select 'M' for Male or 'F' for Female.", 'error')
        return redirect(url_for('adminTeacher'))

    if years_of_exp < 0:
        flash('Years of Experience cannot be negative.', 'error')
        return redirect(url_for('adminTeacher'))

    if request.form.get('dob') and not dob:
        flash('Invalid date format for Date of Birth.', 'error')
        return redirect(url_for('adminTeacher'))

    teacher = Teacher.query.filter_by(username=username, teacher_id=teacher_id).first()

    if teacher:
        # Update Teacher Details
        teacher.fname = fname
        teacher.lname = lname
        teacher.gender = gender
        teacher.dob = dob
        teacher.email = email
        teacher.phone_number = phone_number
        teacher.address = address
        teacher.years_of_exp = years_of_exp

        try:
            db.session.commit()
            flash('Teacher updated successfully!', 'success')
        except IntegrityError as ie:
            db.session.rollback()
            if 'unique constraint' in str(ie.orig).lower():
                flash('Email or Phone Number already exists.', 'error')
            elif 'foreign key constraint' in str(ie.orig).lower():
                flash('Username does not exist. Please ensure the username is correct.', 'error')
            else:
                flash('Database Integrity Error: ' + str(ie.orig), 'error')
            app.logger.error(f"IntegrityError while updating teacher: {ie}")
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while updating the teacher.', 'error')
            app.logger.error(f"SQLAlchemyError while updating teacher: {e}")
        except Exception as e:
            db.session.rollback()
            flash(f'Unexpected error: {e}', 'error')
            app.logger.error(f"Unexpected error while updating teacher: {e}")
    else:
        flash('Teacher not found.', 'error')

    return redirect(url_for('adminTeacher'))


@app.route('/teacher/<username>/<int:teacher_id>', methods=['GET'])
def teacherDetail(username, teacher_id):
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    teacher = Teacher.query.filter_by(username=username, teacher_id=teacher_id).first()

    if not teacher:
        flash('Teacher not found.', 'error')
        return redirect(url_for('adminTeacher'))

    return render_template('admin/teacherDetail.html', teacher=teacher)


# ====================
# Course Management
# ====================

@app.route('/adminCourse', methods=['GET'])
def adminCourse():
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    page = request.args.get('page', 1)
    pagination = getPaginatedItems(Course.query.order_by(Course.course_id), page)
    courses = pagination.items

    return render_template('admin/adminCourse.html', username=session['username'], courses=courses, pagination=pagination)


@app.route('/addCourse', methods=['POST'])
def addCourse():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    course_id = validateInt(request.form.get('course_id'))
    course_name = request.form.get('course_name')
    course_description = request.form.get('course_description', '')

    # Validation Checks
    if not course_id or not course_name:
        flash('Course ID and Course Name are required.', 'error')
        return redirect(url_for('adminCourse'))

    # Create Course Instance
    new_course = Course(
        course_id=course_id,
        course_name=course_name,
        course_description=course_description
    )

    # Add to Database
    try:
        db.session.add(new_course)
        db.session.commit()
        flash('Course added successfully!', 'success')
    except IntegrityError as ie:
        db.session.rollback()
        if 'unique constraint' in str(ie.orig).lower():
            flash('Course Name must be unique.', 'error')
        else:
            flash('Database Integrity Error: ' + str(ie.orig), 'error')
        app.logger.error(f"IntegrityError while adding course: {ie}")
    except SQLAlchemyError as e:
        db.session.rollback()
        flash('An error occurred while adding the course.', 'error')
        app.logger.error(f"SQLAlchemyError while adding course: {e}")
    except Exception as e:
        db.session.rollback()
        flash(f'Unexpected error: {e}', 'error')
        app.logger.error(f"Unexpected error while adding course: {e}")

    return redirect(url_for('adminCourse'))


@app.route('/deleteCourse', methods=['POST'])
def deleteCourse():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    course_id = validateInt(request.form.get('course_id'))

    if not course_id:
        flash('Missing Course ID.', 'error')
        return redirect(url_for('adminCourse'))

    course = Course.query.filter_by(course_id=course_id).first()

    if course:
        try:
            db.session.delete(course)
            db.session.commit()
            flash('Course deleted successfully!', 'success')
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while deleting the course.', 'error')
            app.logger.error(f"SQLAlchemyError while deleting course: {e}")
    else:
        flash('Course not found.', 'error')

    return redirect(url_for('adminCourse'))


@app.route('/editCourse', methods=['POST'])
def editCourse():
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    course_id = validateInt(request.form.get('course_id'))
    course_name = request.form.get('course_name')
    course_description = request.form.get('course_description', '')

    # Validation Checks
    if not course_id or not course_name:
        flash('Course ID and Course Name are required.', 'error')
        return redirect(url_for('adminCourse'))

    course = Course.query.filter_by(course_id=course_id).first()

    if course:
        # Update Course Details
        course.course_name = course_name
        course.course_description = course_description

        try:
            db.session.commit()
            flash('Course updated successfully!', 'success')
        except IntegrityError as ie:
            db.session.rollback()
            if 'unique constraint' in str(ie.orig).lower():
                flash('Course Name must be unique.', 'error')
            else:
                flash('Database Integrity Error: ' + str(ie.orig), 'error')
            app.logger.error(f"IntegrityError while updating course: {ie}")
        except SQLAlchemyError as e:
            db.session.rollback()
            flash('An error occurred while updating the course.', 'error')
            app.logger.error(f"SQLAlchemyError while updating course: {e}")
        except Exception as e:
            db.session.rollback()
            flash(f'Unexpected error: {e}', 'error')
            app.logger.error(f"Unexpected error while updating course: {e}")
    else:
        flash('Course not found.', 'error')

    return redirect(url_for('adminCourse'))


# ====================
# Additional Routes
# ====================

@app.route('/teacherHome')
def teacherHome():
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))
    # Implement teacher-specific logic here
    return render_template('teacher/teacherHome.html', username=session['username'])


@app.route('/studentHome')
def studentHome():
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))
    # Implement student-specific logic here
    return render_template('student/studentHome.html', username=session['username'])


# Run the Application
if __name__ == '__main__':
    app.run(debug=True)
