from flask import Flask, render_template, request, redirect, session
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text  # Import text để sử dụng với SQL thuần túy

import logging

app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Cần thiết để sử dụng session

# Cấu hình cơ sở dữ liệu Oracle
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##Phong1:1234@localhost:1521/XE'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Route trang đăng nhập
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Sử dụng truy vấn SQL với text() và mappings()
        result = db.session.execute(
            text("SELECT username, user_role FROM users WHERE username = :username AND password = :password"),
            {'username': username, 'password': password}
        ).mappings().fetchone()

        if result:
            # Đăng nhập thành công
            session['username'] = result['username']
            
            # Kiểm tra role và chuyển hướng
            if result['user_role'] == 'student':
                return redirect('/home')
            elif result['user_role'] == 'teacher':
                return redirect('/teacherHome')
            elif result['user_role'] == 'admin':
                return redirect('/adminHome')

        else:
            # Đăng nhập thất bại
            return render_template('index.html', error="Tài khoản hoặc mật khẩu không đúng")

    return render_template('index.html')

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
        
        print("Courses: ", courses)

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

        # Lấy danh sách các khóa học mà sinh viên đã tham gia
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
            ORDER BY 
                c.course_name, m.upload_date DESC
        """)
    )
        materials = materials_query.fetchall()

        # Truyền dữ liệu sang template
        return render_template('studymaterial.html', student=student, materials=materials)

    else:
        return redirect('/')








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
        courses = db.session.execute(
            text("SELECT * FROM Course")
        ).mappings().fetchall()
        if courses:
            return render_template('teacher_course.html', username=session['username'], courses=courses)
        else:
            return render_template('teacher_course.html', error="Không tìm thấy khóa học.")
    else:
        return redirect('/')

@app.route('/teacher_class')
def teacher_class():
    if 'username' in session:
        # Lấy tất cả các bản ghi trong bảng Class
        classes = db.session.execute(
            text("SELECT * FROM Class")
        ).mappings().fetchall()
        if classes:
            return render_template('teacher_class.html', username=session['username'], classes=classes)
        else:
            return render_template('teacher_class.html', error="Không tìm thấy lớp học.")
    else:
        return redirect('/')






# Route trang home cho admin
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
