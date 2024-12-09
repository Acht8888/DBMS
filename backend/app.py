from flask import Flask, render_template, request, redirect, session
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Cần thiết để sử dụng session

# Cấu hình cơ sở dữ liệu Oracle
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##HUYLAB:p123@192.168.56.1:1521/XE'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
# Định nghĩa bảng Users (Model)
class User(db.Model):
    __tablename__ = 'users'
    username = db.Column(db.String(50), primary_key=True)
    password = db.Column(db.String(100), nullable=False)
    student = db.relationship('Student', backref='user', uselist=False)

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
        return f'<Student {self.username}>'    

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Kiểm tra tài khoản trong cơ sở dữ liệu
        user = User.query.filter_by(username=username, password=password).first()

        if user:
            # Nếu đăng nhập thành công, lưu username vào session
            session['username'] = username
            return redirect('/home')

        else:
            # Hiển thị thông báo lỗi khi đăng nhập không thành công
            return render_template('index.html', error="Tài khoản hoặc mật khẩu không đúng")

    return render_template('index.html')

# Route trang home cho học sinh
@app.route('/home')
def home():
    if 'username' in session:
        return render_template('home.html', username=session['username'])
    else:
        return redirect('/')

@app.route('/profile')
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
            return render_template('profile.html', student=student)
        else:
            return render_template('profile.html', error="Không tìm thấy thông tin sinh viên.")
    else:
        return redirect('/')

# Route đăng xuất
@app.route('/logout')
def logout():
    session.pop('username', None)  # Xóa session của người dùng
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
