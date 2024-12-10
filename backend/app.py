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
@app.route('/adminStudent', methods=['GET', 'POST'])
def adminStudent():
    if request.method == 'POST':
        # Get form data
        student_id = int(request.form['student_id'])  # Convert student_id to integer
        username = request.form['username']
        fname = request.form['fname']
        lname = request.form['lname']
        gender = request.form['gender']  # Assuming gender is either 'M' or 'F'
        
        # Convert dob from string to date
        try:
            dob = datetime.strptime(request.form['dob'], '%Y-%m-%d').date()  # Assuming dob is in YYYY-MM-DD format
        except ValueError:
            flash('Invalid date format for Date of Birth.', 'error')
            return redirect('/adminStudent')
        
        email = request.form['email']
        phone_number = request.form['phone_number']
        address = request.form['address']
        
        # Convert GPA to decimal
        try:
            gpa = float(request.form['gpa'])
        except ValueError:
            flash('GPA must be a number.', 'error')
            return redirect('/adminStudent')
        
        # Ensure status is one of the allowed values
        status = request.form['status']  # Should be 'active', 'inactive', 'graduated', or 'suspended'
        
        # Convert enrollment year to integer
        try:
            enrollment_year = int(request.form['enrollment_year'])
        except ValueError:
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

    # If GET request, display the list of students
    students = Student.query.all()
    return render_template('admin/adminStudent.html', students=students)

# Route đăng xuất
@app.route('/logout')
def logout():
    session.pop('username', None)  # Remove user's session
    flash('You have been logged out successfully.', 'success')
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
