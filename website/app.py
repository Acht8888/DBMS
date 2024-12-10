from flask import Flask, render_template, request, redirect, session
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Cần thiết để sử dụng session

# Cấu hình cơ sở dữ liệu Oracle
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##BTL:1234@localhost:1521/XE'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Định nghĩa bảng Users (Model)
class User(db.Model):
    __tablename__ = 'users'
    username = db.Column(db.String(100), primary_key=True)
    password = db.Column(db.String(100), nullable=False)
    role = db.Column(db.String(100), nullable=False)

    # Define relationships based on role
    student = db.relationship('Student', backref='user', uselist=False)
    teacher = db.relationship('Teacher', backref='user', uselist=False)

    def __repr__(self):
        return f'<User {self.username}, Role {self.role}>'


# Định nghĩa bảng Student (Model)
class Student(db.Model):
    __tablename__ = 'student'
    username = db.Column(db.String(50), db.ForeignKey('users.username'))
    student_id = db.Column(db.Integer, primary_key=True)
    fname = db.Column(db.String(30), nullable=False)
    lname = db.Column(db.String(30), nullable=False)
    gender = db.Column(db.String(1), nullable=False)
    dob = db.Column(db.Date, nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    phone_number = db.Column(db.String(15), unique=True, nullable=False)
    address = db.Column(db.String(255), nullable=True)
    gpa = db.Column(db.Numeric(3, 2), nullable=True)
    status = db.Column(db.String(20), nullable=False)
    enrollment_year = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return f'<Student {self.student_id} - {self.fname} {self.lname}>'

# Định nghĩa bảng Teacher (Model)
class Teacher(db.Model):
    __tablename__ = 'teacher'
    username = db.Column(db.String(50), db.ForeignKey('users.username'), nullable=False)
    teacher_id = db.Column(db.Integer, primary_key=True)
    fname = db.Column(db.String(50), nullable=False)
    lname = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.String(1), nullable=False)  # 'M' or 'F'
    dob = db.Column(db.Date, nullable=True)
    email = db.Column(db.String(100), unique=True, nullable=False)
    phone_number = db.Column(db.String(15), unique=True, nullable=False)
    address = db.Column(db.String(255), nullable=True)
    years_of_exp = db.Column(db.Integer, nullable=True)

    def __repr__(self):
        return f'<Teacher {self.teacher_id} - {self.fname} {self.lname}>' 

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Kiểm tra tài khoản trong cơ sở dữ liệu
        user = User.query.filter_by(username=username, password=password).first()

        if user:
            # Lưu username và role vào session
            session['username'] = username

            if user.role == 'teacher':
                return redirect('/teacherHome')  # Redirect đến trang dành cho Teacher
            elif user.role == 'student':
                return redirect('/studentHome')  # Redirect đến trang dành cho Student
            elif user.role == 'admin':
                return redirect('/adminHome')  # Redirect đến trang dành cho Admin
            else:
                # Nếu role không phải là 'teacher', 'student', hoặc 'admin'
                return render_template('index.html', error="Role không hợp lệ")

        else:
            # Hiển thị thông báo lỗi khi đăng nhập không thành công
            return render_template('index.html', error="Tài khoản hoặc mật khẩu không đúng")

    return render_template('index.html')

# Route trang home cho học sinh
@app.route('/studentHome')
def home():
    if 'username' in session:
        return render_template('studentHome.html', username=session['username'])
    else:
        return redirect('/')

@app.route('/studentProfile')
def profile():
    if 'username' in session:
        username = session['username']
        print("Username trong session:", username)  # Debug
        
        # Lấy tất cả các bản ghi trong bảng Student
        students = Student.query.all()
        
        # In ra các thông tin sinh viên từ bảng Student
        print("Dữ liệu trong bảng Student:")
        for student in students:
            print(f"Student ID: {student.student_id}, "
                  f"Username: {student.username}, "
                  f"Full Name: {student.fname} {student.lname}, "
                  f"Email: {student.email}, "
                  f"Phone: {student.phone_number}, "
                  f"GPA: {student.gpa}, "
                  f"Status: {student.status}, "
                  f"Enrollment Year: {student.enrollment_year}")

        # Tìm sinh viên theo username trong session
        student = Student.query.filter_by(username=username).first()
        if student:
            return render_template('studentProfile.html', student=student)
        else:
            return render_template('studentProfile.html', error="Không tìm thấy thông tin sinh viên.")
    else:
        return redirect('/')

# Route trang home cho Teacher
@app.route('/teacherHome')
def teacherHome():
    if 'username' in session:
        return render_template('teacherHome.html', username=session['username'])
    else:
        return redirect('/')
    
@app.route('/adminHome')
def adminHome():
    if 'username' in session:
        return render_template('adminHome.html', username=session['username'])
    else:
        return redirect('/')

# Route đăng xuất
@app.route('/logout')
def logout():
    session.pop('username', None)  # Xóa session của người dùng
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
