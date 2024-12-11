from flask import Flask, render_template, request, redirect, session, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from datetime import datetime
import logging

# Initialize Flask Application
app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Necessary for session and flash

# ====================
# Database Configuration
# ====================
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##BTL:1234@localhost:1521/XE'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# ====================
# Constants
# ====================
PER_PAGE = 5  # Number of items per page for pagination

# ====================
# Models
# ====================

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


# ====================
# Helper Functions
# ====================

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


# ====================
# Routes
# ====================

# --------------------
# Authentication Routes
# --------------------

@app.route('/', methods=['GET', 'POST'])
def index():
    """Home Route (Login Page)"""
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
                return redirect(url_for('home'))
            elif user_role == 'teacher':
                return redirect(url_for('teacherHome'))
            elif user_role == 'admin':
                return redirect(url_for('adminHome'))
        else:
            flash("Invalid username or password.", "error")
            return redirect(url_for('index'))

    return render_template('index.html')


@app.route('/logout')
def logout():
    """Logout Route"""
    session.pop('username', None)
    # flash('You have been logged out successfully.', 'success')
    return redirect(url_for('index'))


# --------------------
# Admin Routes
# --------------------

@app.route('/adminHome')
def adminHome():
    """Admin Home"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))
    return render_template('admin/adminHome.html', username=session['username'])


# --------------------
# Account Management Routes
# --------------------

@app.route('/studentAccountDetail/<username>/<int:student_id>', methods=['GET'])
def studentAccountDetail(username, student_id):
    """Student Account Detail"""
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
    """Change Student Password"""
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

@app.route('/teacherAccountDetail/<username>/<int:teacher_id>', methods=['GET'])
def teacherAccountDetail(username, teacher_id):
    """Teacher Account Detail"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    teacher_user = Users.query.filter_by(username=username).first()
    teacher = Teacher.query.filter_by(username=username, teacher_id=teacher_id).first()
    if not teacher_user:
        flash('Teacher account not found.', 'error')
        return redirect(url_for('adminTeacher'))

    return render_template('admin/teacherAccountDetail.html', teacher_user=teacher_user, teacher=teacher)

@app.route('/changeTeacherPassword', methods=['POST'])
def changeTeacherPassword():
    """Change Teacher Password"""
    username = request.form.get('username')
    new_password = request.form.get('new_password')
    confirm_password = request.form.get('confirm_password')

    if not all([username, new_password, confirm_password]):
        flash('All fields are required.', 'error')
        return redirect(url_for('teacherAccountDetail', username=username, teacher_id=request.form.get('teacher_id')))

    if new_password != confirm_password:
        flash('Passwords do not match.', 'error')
        return redirect(url_for('teacherAccountDetail', username=username, teacher_id=request.form.get('teacher_id')))

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

    return redirect(url_for('teacherAccountDetail', username=username, teacher_id=request.form.get('teacher_id')))


# --------------------
# Student Management Routes
# --------------------

@app.route('/adminStudent', methods=['GET'])
def adminStudent():
    """Admin Student List"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    page = request.args.get('page', 1)
    pagination = getPaginatedItems(Student.query.order_by(Student.student_id), page)
    students = pagination.items

    return render_template('admin/adminStudent.html', username=session['username'], students=students, pagination=pagination)


@app.route('/addStudent', methods=['POST'])
def addStudent():
    """Add New Student"""
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
    """Delete Student"""
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
    """Edit Student Details"""
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
    """Student Detail View"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    student = Student.query.filter_by(username=username, student_id=student_id).first()

    if not student:
        flash('Student not found.', 'error')
        return redirect(url_for('adminStudent'))

    return render_template('admin/studentDetail.html', student=student)


# --------------------
# Teacher Management Routes
# --------------------

@app.route('/adminTeacher', methods=['GET'])
def adminTeacher():
    """Admin Teacher List"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    page = request.args.get('page', 1)
    pagination = getPaginatedItems(Teacher.query.order_by(Teacher.teacher_id), page)
    teachers = pagination.items

    return render_template('admin/adminTeacher.html', username=session['username'], teachers=teachers, pagination=pagination)


@app.route('/addTeacher', methods=['POST'])
def addTeacher():
    """Add New Teacher"""
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    # Retrieve and validate form data
    teacher_id = validateInt(request.form.get('teacher_id'))
    username = request.form.get('username')
    password = request.form.get('password')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')
    dob = validateDate(request.form.get('dob')) if request.form.get('dob') else None
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    years_of_exp = validateInt(request.form.get('years_of_exp'))

    # Validation Checks
    if not all([teacher_id, username, password, fname, lname, gender, email, phone_number, years_of_exp]):
        flash('Please fill in all required fields.', 'error')
        return redirect(url_for('adminTeacher'))

    if years_of_exp < 0:
        flash('Years of Experience cannot be negative.', 'error')
        return redirect(url_for('adminTeacher'))

    if not dob:
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

    new_user = Users(
        username=username,
        password=password,
        user_role="teacher"
    )

    # Add to Database
    try:
        db.session.add(new_user)
        db.session.commit()
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
    """Delete Teacher"""
    if 'username' not in session:
        flash('Please log in to perform this action.', 'error')
        return redirect(url_for('index'))

    teacher_id = validateInt(request.form.get('teacher_id'))
    username = request.form.get('username')

    if not teacher_id or not username:
        flash('Missing Teacher ID or Username.', 'error')
        return redirect(url_for('adminTeacher'))

    teacher = Teacher.query.filter_by(username=username, teacher_id=teacher_id).first()
    user = Users.query.filter_by(username=username).first()

    if teacher:
        try:
            db.session.delete(teacher)
            db.session.commit()
            db.session.delete(user)
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
    """Edit Teacher Details"""
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

    if years_of_exp < 0:
        flash('Years of Experience cannot be negative.', 'error')
        return redirect(url_for('adminTeacher'))

    if not dob:
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
    """Teacher Detail View"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    teacher = Teacher.query.filter_by(username=username, teacher_id=teacher_id).first()

    if not teacher:
        flash('Teacher not found.', 'error')
        return redirect(url_for('adminTeacher'))

    return render_template('admin/teacherDetail.html', teacher=teacher)


# --------------------
# Course Management Routes
# --------------------

@app.route('/adminCourse', methods=['GET'])
def adminCourse():
    """Admin Course List"""
    if 'username' not in session:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('index'))

    page = request.args.get('page', 1)
    pagination = getPaginatedItems(Course.query.order_by(Course.course_id), page)
    courses = pagination.items

    return render_template('admin/adminCourse.html', username=session['username'], courses=courses, pagination=pagination)


@app.route('/addCourse', methods=['POST'])
def addCourse():
    """Add New Course"""
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
    """Delete Course"""
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
    """Edit Course Details"""
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


# --------------------
# Student Routes
# --------------------

# Route trang home cho học sinh
@app.route('/home')
def home():
    if 'username' in session:
        return render_template('home.html', username=session['username'])
    else:
        return redirect('/')

# Route trang profile cho sinh viên
@app.route('/profile')
def profile():
    if 'username' in session:
        username = session['username']
        
        # Lấy thông tin sinh viên
        student = db.session.execute(
            text("SELECT * FROM student WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if student:
            return render_template('profile.html', student=student)
        else:
            return render_template('profile.html', error="Không tìm thấy thông tin sinh viên.")
    else:
        return redirect('/')

# Route trang healthrecord cho sinh viên
@app.route('/healthrecord')
def healthrecord_student():
    if 'username' in session:
        username = session['username']
        
        # Lấy thông tin sinh viên
        student = db.session.execute(
            text("SELECT * FROM student WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if student:
            # Lấy health record của sinh viên
            health_records = db.session.execute(
                text("SELECT * FROM healthrecord WHERE student_id = :student_id"),
                {'student_id': student['student_id']}
            ).mappings().fetchall()

            return render_template('healthrecord.html', student=student, health_records=health_records)
        else:
            return render_template('healthrecord.html', error="Không tìm thấy thông tin sinh viên.")
    else:
        return redirect('/')

@app.route('/parentinfo')
def parentinfo():
    if 'username' in session:
        # Lấy username từ session
        username = session['username']
        
        # Lấy thông tin sinh viên (student_id, fname, lname) từ bảng Student dựa vào username
        student = db.session.execute(
            text("""
                SELECT student_id, fname, lname 
                FROM student 
                WHERE username = :username
            """),
            {'username': username}
        ).mappings().fetchone()

        if not student:
            # Nếu không tìm thấy thông tin sinh viên, hiển thị thông báo lỗi
            return render_template('parentinfo.html', error="Không tìm thấy thông tin sinh viên.")

        # Truy vấn thông tin phụ huynh dựa trên student_id
        parents = db.session.execute(
            text("""
                SELECT 
                    p.parent_id, p.fname, p.lname, p.gender, p.dob, p.relationship, 
                    p.email, p.phone_number, p.address
                FROM 
                    Parent p
                JOIN 
                    HasParent hp ON p.parent_id = hp.parent_id
                WHERE 
                    hp.student_id = :student_id
            """),
            {'student_id': student['student_id']}
        ).mappings().fetchall()

        # Trả dữ liệu sinh viên và phụ huynh cho template
        return render_template('parentinfo.html', student=student, parents=parents)
    else:
        # Nếu người dùng chưa đăng nhập, chuyển hướng đến trang đăng nhập
        return redirect('/')

@app.route('/courses')
def courses():
    if 'username' in session:
        # Lấy username từ session
        username = session['username']

        # Lấy thông tin sinh viên (student_id)
        student = db.session.execute(
            text("SELECT student_id, fname, lname FROM student WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if not student:
            return render_template('courses.html', error="Không tìm thấy thông tin sinh viên.")

        # Lấy danh sách các khóa học mà sinh viên đã tham gia
        courses = db.session.execute(
            text("""
                SELECT 
                    c.course_id,
                    c.course_name,
                    c.course_description,
                    cl.class_id,
                    t.fname AS teacher_fname,
                    t.lname AS teacher_lname
                FROM 
                    Attends a
                JOIN 
                    Class cl ON a.course_id = cl.course_id AND a.class_id = cl.class_id
                JOIN 
                    Course c ON cl.course_id = c.course_id
                JOIN 
                    Teacher t ON cl.teacher_id = t.teacher_id
                WHERE 
                    a.student_id = :student_id
            """),
            {'student_id': student['student_id']}
        ).mappings().fetchall()
        

        # Truyền dữ liệu sang template
        return render_template('course.html', student=student, courses=courses)

    else:
        return redirect('/')

@app.route('/studymaterials')
def studymaterials():
    if 'username' in session:
        # Lấy username từ session
        username = session['username']

        # Lấy thông tin sinh viên (student_id)
        student = db.session.execute(
            text("SELECT student_id, fname, lname FROM student WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if not student:
            return render_template('studymaterial.html', error="Không tìm thấy thông tin sinh viên.")

        # Lấy danh sách các tài liệu học của sinh viên đó
        materials_query = db.session.execute(
            text("""
                SELECT 
                    m.material_id,
                    m.type,
                    m.title,
                    m.upload_date,
                    m.author,
                    c.course_name,
                    s.fname AS student_fname,
                    s.lname AS student_lname
                FROM 
                    Material m
                JOIN 
                    Course c ON m.course_id = c.course_id
                JOIN 
                    Attends a ON a.course_id = c.course_id
                JOIN 
                    Student s ON a.student_id = s.student_id
                WHERE 
                    s.username = :username  -- Lọc theo username của sinh viên hiện tại
                ORDER BY 
                    c.course_name, m.upload_date DESC
            """),
            {'username': username}
        )
        materials = materials_query.fetchall()

        # Truyền dữ liệu sang template
        return render_template('studymaterial.html', student=student, materials=materials)

    else:
        return redirect('/')

@app.route('/timetable')
def timetable():
    if 'username' in session:
        # Lấy username từ session
        username = session['username']

        # Lấy thông tin sinh viên từ username trong session
        student = db.session.execute(
            text("SELECT student_id, fname, lname FROM Student WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if not student:
            return render_template('timetable.html', error="Không tìm thấy thông tin sinh viên.")

        # Lấy thông tin lịch trình của sinh viên hiện tại
        timetable_query = """
        SELECT 
            C.course_name AS course_name,
            C.course_id AS course_id,
            T.day_of_week AS day_of_week,
            TO_CHAR(T.start_time, 'HH24:MI') AS start_time,
            TO_CHAR(T.end_time, 'HH24:MI') AS end_time,
            SCH.room AS room,
            SCH.building AS building
        FROM 
            Student S
            JOIN Attends A ON S.student_id = A.student_id
            JOIN Class CL ON A.course_id = CL.course_id AND A.class_id = CL.class_id
            JOIN Course C ON CL.course_id = C.course_id
            JOIN Schedules SCH ON CL.class_id = SCH.class_id AND CL.course_id = SCH.course_id
            JOIN Time T ON SCH.class_id = T.class_id AND SCH.course_id = T.course_id
            WHERE 
                S.username = :username  -- Lọc theo username của sinh viên hiện tại
        ORDER BY 
            S.student_id,
            T.day_of_week,
            T.start_time
        """

        timetable_data = db.session.execute(
            text(timetable_query),
            {'username': username}
        ).mappings().fetchall()

        # Truyền dữ liệu sang template
        return render_template('timetable.html', student=student, timetable=timetable_data)

    else:
        return redirect('/')

@app.route('/grades')
def grades():
    if 'username' in session:
        # Lấy username từ session
        username = session['username']
        
        # Lấy thông tin sinh viên từ username trong session
        student = db.session.execute(
            text("SELECT student_id, fname, lname FROM student WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        # Lấy tất cả thông tin về môn học, điểm số, kỳ thi, và sinh viên của sinh viên hiện tại
        grades_query = db.session.execute(
            text("""
                SELECT 
                    c.course_id,
                    c.course_name,
                    t.grade,
                    t.score,
                    e.exam_id,
                    e.exam_type,
                    TO_CHAR(e.exam_date, 'YYYY-MM-DD') AS exam_date,
                    s.student_id,
                    s.fname || ' ' || s.lname AS student_name
                FROM 
                    Takes t
                JOIN 
                    Exam e ON t.exam_id = e.exam_id
                JOIN 
                    Course c ON e.course_id = c.course_id
                JOIN 
                    Student s ON t.student_id = s.student_id
                WHERE 
                    s.username = :username  -- Lọc theo username của sinh viên hiện tại
                ORDER BY 
                    e.exam_date DESC
            """),
            {'username': username}
        )
        grades = grades_query.fetchall()

        # Truyền dữ liệu sang template
        return render_template('grades.html', grades=grades, student=student)

    else:
        return redirect('/')

# --------------------
# Teacher Routes
# --------------------

# Route trang home cho giáo viên
@app.route('/teacherHome')
def teacherHome():
    if 'username' in session:
        return render_template('teacherHome.html', username=session['username'])
    else:
        return redirect('/')

# Route for teacher profile
@app.route('/teacher_profile')
def teacher_Profile():
    if 'username' in session:
        username = session['username']
        logging.debug(f"Username in session: {username}")

        # Find teacher by username in session
        teacher = db.session.execute(
            text("SELECT * FROM teacher WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()
        if teacher:
            logging.debug(f"Teacher found: {teacher}")
            return render_template('teacher_profile.html', teacher=teacher)
        else:
            logging.debug("Teacher not found")
            return render_template('teacher_profile.html', error="Không tìm thấy thông tin giáo viên.")
    else:
        logging.debug("Username not in session")
        return redirect('/')    


@app.route('/teacher_course')
def teacher_course():
    if 'username' in session:
        # Lấy tất cả các bản ghi trong bảng Course
        username = session['username']
        
        courses = db.session.execute(
            text("SELECT * FROM Course")
        ).mappings().fetchall()
        if courses:
            return render_template('teacher_course.html', username=session['username'], courses=courses)
        else:
            return render_template('teacher_course.html', error="Không tìm thấy khóa học.")
    else:
        return redirect('/')

@app.route('/teacher_timetable')
def teacher_timetable():
    if 'username' in session:
        username = session['username']
        
        # Lấy thông tin giáo viên
        teacher = db.session.execute(
            text("SELECT teacher_id FROM teacher WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if not teacher:
            return render_template('teacher_timetable.html', error="Không tìm thấy thông tin giáo viên.")

        # Lấy thời khóa biểu của giáo viên
        timetable = db.session.execute(
            text(""" 
                SELECT 
                    t.teacher_id,
                    t.fname || ' ' || t.lname AS teacher_name,
                    co.course_id,
                    co.course_name,
                    c.class_id,
                    ti.room,
                    ti.building,
                    ti.day_of_week,
                    TO_CHAR(ti.start_time, 'HH24:MI:SS') AS start_time,
                    TO_CHAR(ti.end_time, 'HH24:MI:SS') AS end_time
                FROM 
                    Teacher t
                JOIN 
                    Class c ON t.teacher_id = c.teacher_id
                JOIN 
                    Course co ON c.course_id = co.course_id
                JOIN
                    Time ti ON c.course_id = ti.course_id AND c.class_id = ti.class_id
                WHERE 
                    t.teacher_id = :teacher_id
            """),
            {'teacher_id': teacher['teacher_id']}
        ).mappings().fetchall()

        return render_template('teacher_timetable.html', timetable=timetable)
    else:
        return redirect('/')

@app.route('/teacher_student')
def teacher_student():
    if 'username' in session:
        username = session['username']
        
        # Lấy thông tin giáo viên
        teacher = db.session.execute(
            text("SELECT teacher_id FROM teacher WHERE username = :username"),
            {'username': username}
        ).mappings().fetchone()

        if not teacher:
            return render_template('teacher_student.html', error="Không tìm thấy thông tin giáo viên.")

        # Lấy danh sách sinh viên mà giáo viên đang dạy
        students = db.session.execute(
            text("""
                SELECT 
                    s.student_id, s.fname, s.lname, s.gender, s.dob, s.email, 
                    s.phone_number, s.address, s.gpa, s.status, s.enrollment_year,
                    c.course_id, c.class_id, co.course_name
                FROM 
                    Student s
                JOIN 
                    Attends a ON s.student_id = a.student_id
                JOIN 
                    Class c ON a.course_id = c.course_id AND a.class_id = c.class_id
                JOIN 
                    Course co ON c.course_id = co.course_id
                WHERE 
                    c.teacher_id = :teacher_id
            """),
            {'teacher_id': teacher['teacher_id']}
        ).mappings().fetchall()

        return render_template('teacher_student.html', students=students)
    else:
        return redirect('/')


@app.route('/teacher_material', methods=['GET', 'POST'])
def teacher_material():
    if 'username' in session:
        username = session['username']

    if request.method == 'POST':
        action = request.form.get('action')
        logging.debug(f"Action: {action}")

        if action == 'add':
            # Retrieve and validate form data
            material_id = request.form.get('material_id')
            course_id = request.form.get('course_id')
            material_type = request.form.get('type')
            title = request.form.get('title')
            upload_date_str = request.form.get('upload_date')
            author = request.form.get('author')
            upload_date = datetime.strptime(upload_date_str, '%Y-%m-%d').date()

            # Add to Database
            try:
                db.session.execute(
                    text("""
                        INSERT INTO Material (material_id, course_id, type, title, upload_date, author)
                        VALUES (:material_id, :course_id, :type, :title, :upload_date, :author)
                    """),
                    {'material_id': material_id, 'course_id': course_id, 'type': material_type, 'title': title, 'upload_date': upload_date, 'author': author}
                )
                db.session.commit()
                flash('Material added successfully!', 'success')
            except IntegrityError as ie:
                db.session.rollback()
                if 'unique constraint' in str(ie.orig).lower():
                    flash('Material ID already exists.', 'error')
                else:
                    flash('Database Integrity Error: ' + str(ie.orig), 'error')
                app.logger.error(f"IntegrityError while adding material: {ie}")
            except SQLAlchemyError as e:
                db.session.rollback()
                flash('An error occurred while adding the material.', 'error')
                app.logger.error(f"SQLAlchemyError while adding material: {e}")
            except Exception as e:
                db.session.rollback()
                flash(f'Unexpected error: {e}', 'error')
                app.logger.error(f"Unexpected error while adding material: {e}")

            return redirect(url_for('teacher_material'))

        elif action == 'update':
            # Retrieve and validate form data
            material_id = request.form.get('material_id')
            course_id = request.form.get('course_id')
            material_type = request.form.get('type')
            title = request.form.get('title')
            upload_date_str = request.form.get('upload_date')
            author = request.form.get('author')

            upload_date = datetime.strptime(upload_date_str, '%Y-%m-%d').date()

            # Update Database
            try:
                db.session.execute(
                    text("""
                        UPDATE Material
                        SET course_id = :course_id, type = :type, title = :title, author = :author, upload_date = :upload_date
                        WHERE material_id = :material_id
                    """),
                    {'course_id': course_id, 'type': material_type, 'title': title, 'author': author, 'upload_date': upload_date, 'material_id': material_id}
                )
                db.session.commit()
                flash('Material updated successfully!', 'success')
            except IntegrityError as ie:
                db.session.rollback()
                flash('Database Integrity Error: ' + str(ie.orig), 'error')
                app.logger.error(f"IntegrityError while updating material: {ie}")
            except SQLAlchemyError as e:
                db.session.rollback()
                flash('An error occurred while updating the material.', 'error')
                app.logger.error(f"SQLAlchemyError while updating material: {e}")
            except Exception as e:
                db.session.rollback()
                flash(f'Unexpected error: {e}', 'error')
                app.logger.error(f"Unexpected error while updating material: {e}")

            return redirect(url_for('teacher_material'))
        
        elif action == 'delete':
            # Retrieve and validate form data
            material_id = request.form.get('material_id')

            # Delete from Database
            try:
                db.session.execute(
                    text("DELETE FROM Material WHERE material_id = :material_id"),
                    {'material_id': material_id}
                )
                db.session.commit()
                flash('Material deleted successfully!', 'success')
            except IntegrityError as ie:
                db.session.rollback()
                flash('Database Integrity Error: ' + str(ie.orig), 'error')
                app.logger.error(f"IntegrityError while deleting material: {ie}")
            except SQLAlchemyError as e:
                db.session.rollback()
                flash('An error occurred while deleting the material.', 'error')
                app.logger.error(f"SQLAlchemyError while deleting material: {e}")
            except Exception as e:
                db.session.rollback()
                flash(f'Unexpected error: {e}', 'error')
                app.logger.error(f"Unexpected error while deleting material: {e}")

            return redirect(url_for('teacher_material'))

    materials = db.session.execute(
        text("SELECT * FROM Material")
    ).mappings().fetchall()
    courses = db.session.execute(
        text("SELECT * FROM Course")
    ).mappings().fetchall()
    return render_template('teacher_material.html', username=username, materials=materials, courses=courses)

# ====================
# Run the Application
# ====================
if __name__ == '__main__':
    app.run(debug=True)
