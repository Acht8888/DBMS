from flask import Flask, render_template, request, redirect, session, flash, url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text  # Import text để sử dụng với SQL thuần túy
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from datetime import datetime
import logging

app = Flask(__name__)
app.debug = True
app.secret_key = 'your_secret_key'  # Cần thiết để sử dụng session

# Cấu hình cơ sở dữ liệu Oracle
app.config['SQLALCHEMY_DATABASE_URI'] = 'oracle+cx_oracle://C##Phong1:1234@127.0.0.1:1521/XE'
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
