from flask import Flask, render_template, request, redirect, session, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from datetime import datetime

app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Necessary for session and flash

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##BTL:1234@localhost:1521/XE'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

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

# Route trang đăng nhập
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Using SQL query with text() and mappings()
        result = db.session.execute(
            text("SELECT username, user_role FROM users WHERE username = :username AND password = :password"),
            {'username': username, 'password': password}
        ).mappings().fetchone()

        if result:
            # Successful login
            session['username'] = result['username']
            
            # Check role and redirect
            if result['user_role'] == 'student':
                return redirect('/home')
            elif result['user_role'] == 'teacher':
                return redirect('/teacherHome')
            elif result['user_role'] == 'admin':
                return redirect('/adminHome')

        else:
            # Failed login
            flash("Tài khoản hoặc mật khẩu không đúng", "error")
            return redirect('/')
    
    return render_template('index.html')

# ... [Other routes remain unchanged] ...

# Route trang adminHome
@app.route('/adminHome')
def adminHome():
    if 'username' in session:
        return render_template('admin/adminHome.html', username=session['username'])
    else:
        return redirect('/')

# Updated Route to Manage Students with Flash Messages
@app.route('/adminStudent', methods=['GET'])
def adminStudent():
    # Get the 'page' query parameter; default to 1 if not provided or invalid
    try:
        page = int(request.args.get('page', 1))
        if page < 1:
            raise ValueError
    except ValueError:
        page = 1

    per_page = 5  # Number of students per page

    # Paginate the query
    pagination = Student.query.order_by(Student.student_id).paginate(page=page, per_page=per_page, error_out=False)
    students = pagination.items

    return render_template('admin/adminStudent.html', students=students, pagination=pagination)

# New Route to handle adding students
@app.route('/addStudent', methods=['POST'])
def addStudent():
    # Get form data
    student_id = request.form.get('student_id')
    username = request.form.get('username')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')  # Assuming gender is either 'M' or 'F'
    
    # Convert dob from string to date
    try:
        dob = datetime.strptime(request.form['dob'], '%Y-%m-%d').date()  # Assuming dob is in YYYY-MM-DD format
    except ValueError:
        flash('Invalid date format for Date of Birth.', 'error')
        return redirect('/adminStudent')
    
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    
    # Convert GPA to decimal
    try:
        gpa = float(request.form.get('gpa'))
    except (ValueError, TypeError):
        flash('GPA must be a number.', 'error')
        return redirect('/adminStudent')
    
    # Ensure status is one of the allowed values
    status = request.form.get('status')  # Should be 'active', 'inactive', 'graduated', or 'suspended'
    
    # Convert enrollment year to integer
    try:
        enrollment_year = int(request.form.get('enrollment_year'))
    except (ValueError, TypeError):
        flash('Enrollment Year must be an integer.', 'error')
        return redirect('/adminStudent')

    # Validation: Ensure GPA is within the valid range
    if not (0 <= gpa <= 4.0):
        flash('Invalid GPA, must be between 0 and 4.0.', 'error')
        return redirect('/adminStudent')
    
    # Validation: Ensure the enrollment year is at least dob + 18
    if enrollment_year < (dob.year + 18):
        flash(f'Invalid enrollment year. The student must be at least 18 years old (DOB: {dob}).', 'error')
        return redirect('/adminStudent')

    print("Adding student with data:", student_id, username, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)

    # Create a new student object
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

    # Add the new student to the database
    try:
        db.session.add(new_student)
        db.session.commit()
        flash('Student added successfully!', 'success')
    except Exception as e:
        db.session.rollback()  # Rollback if an error occurs
        # Log the exception (optional)
        print(f"Error adding student: {e}")
        flash(f'Error occurred while adding the student: {e}', 'error')

    return redirect('/adminStudent')

# Route to handle student deletion
@app.route('/deleteStudent', methods=['POST'])
def deleteStudent():
    # Retrieve data from the form
    student_id = request.form.get('student_id')
    username = request.form.get('username')
    
    if not student_id or not username:
        flash('Missing student ID or username.', 'error')
        return redirect('/adminStudent')
    
    # Convert student_id to integer
    try:
        student_id = int(student_id)
    except ValueError:
        flash('Invalid student ID format.', 'error')
        return redirect('/adminStudent')
    
    # Query the student
    student = Student.query.filter_by(username=username, student_id=student_id).first()
    
    if student:
        try:
            db.session.delete(student)
            db.session.commit()
            flash('Student deleted successfully!', 'success')
        except Exception as e:
            db.session.rollback()
            # Log the exception (optional)
            print(f"Error deleting student: {e}")
            flash('An error occurred while deleting the student.', 'error')
    else:
        flash('Student not found.', 'error')
    
    return redirect('/adminStudent')

# Route to handle editing student information
@app.route('/editStudent', methods=['POST'])
def editStudent():
    # Get form data
    student_id = request.form.get('student_id')
    username = request.form.get('username')
    fname = request.form.get('fname')
    lname = request.form.get('lname')
    gender = request.form.get('gender')
    
    # Convert dob from string to date
    try:
        dob = datetime.strptime(request.form['dob'], '%Y-%m-%d').date()
    except ValueError:
        flash('Invalid date format for Date of Birth.', 'error')
        return redirect('/adminStudent')
    
    email = request.form.get('email')
    phone_number = request.form.get('phone_number')
    address = request.form.get('address')
    
    # Convert GPA to float
    try:
        gpa = float(request.form.get('gpa'))
    except (ValueError, TypeError):
        flash('GPA must be a number.', 'error')
        return redirect('/adminStudent')
    
    # Ensure status is one of the allowed values
    status = request.form.get('status')  # Should be 'active', 'inactive', 'graduated', or 'suspended'
    
    # Convert enrollment year to integer
    try:
        enrollment_year = int(request.form.get('enrollment_year'))
    except (ValueError, TypeError):
        flash('Enrollment Year must be an integer.', 'error')
        return redirect('/adminStudent')

    # Validation: Ensure GPA is within the valid range
    if not (0 <= gpa <= 4.0):
        flash('Invalid GPA, must be between 0 and 4.0.', 'error')
        return redirect('/adminStudent')
    
    # Validation: Ensure the enrollment year is at least dob + 18
    if enrollment_year < (dob.year + 18):
        flash(f'Invalid enrollment year. The student must be at least 18 years old (DOB: {dob}).', 'error')
        return redirect('/adminStudent')

    print("Editing student with data:", student_id, username, fname, lname, gender, dob, email, phone_number, address, gpa, status, enrollment_year)

    # Fetch the student from the database
    student = Student.query.filter_by(username=username, student_id=student_id).first()

    if student:
        # Update student details
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
        except Exception as e:
            db.session.rollback()
            print(f"Error updating student: {e}")
            flash(f'Error occurred while updating the student: {e}', 'error')
    else:
        flash('Student not found.', 'error')

    return redirect('/adminStudent')

# Route đăng xuất
@app.route('/logout')
def logout():
    session.pop('username', None)  # Remove user's session
    flash('You have been logged out successfully.', 'success')
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
