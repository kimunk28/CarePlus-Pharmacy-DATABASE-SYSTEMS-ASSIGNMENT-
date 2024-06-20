from flask import Flask,render_template,request,session,redirect,url_for,flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash
from flask_login import login_user,logout_user,login_manager,LoginManager
from flask_login import login_required,current_user
# from flask_mail import Mail
import json



# MY db connection
local_server= True
app = Flask(__name__)
app.secret_key='hmsprojects'


# this is for getting unique user access
login_manager=LoginManager(app)
login_manager.login_view='login'

# SMTP MAIL SERVER SETTINGS

# app.config.update(
#     MAIL_SERVER='smtp.gmail.com',
#     MAIL_PORT='465',
#     MAIL_USE_SSL=True,
#     MAIL_USERNAME="add your gmail-id",
#     MAIL_PASSWORD="add your gmail-password"
# )
# mail = Mail(app)


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))




# app.config['SQLALCHEMY_DATABASE_URL']='mysql://username:password@localhost/databas_table_name'
app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/hms'
db=SQLAlchemy(app)



# here we will create db models that is tables
class Test(db.Model):
    id=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(100))
    email=db.Column(db.String(100))

class User(UserMixin,db.Model):
    id=db.Column(db.Integer,primary_key=True)
    username=db.Column(db.String(50))
    usertype=db.Column(db.String(50))
    email=db.Column(db.String(50),unique=True)
    password=db.Column(db.String(1000))

class Patients(db.Model):
    SSN=db.Column(db.Integer,primary_key=True)
    last_name=db.Column(db.String(50))
    first_name=db.Column(db.String(50))
    city=db.Column(db.String(50))
    address=db.Column(db.String(50))
    birth_date=db.Column(db.String(50))
    primary_doctorSSN=db.Column(db.String(50),nullable=False)
   

class Doctors(db.Model):
    SSN=db.Column(db.Integer,primary_key=True)
    first_name=db.Column(db.String(50))
    last_name=db.Column(db.String(50))
    speciality=db.Column(db.String(50))
    years_of_experience=db.Column(db.String(50))

class Trigr(db.Model):
    tid=db.Column(db.Integer,primary_key=True)
    pid=db.Column(db.Integer)
    email=db.Column(db.String(50))
    name=db.Column(db.String(50))
    action=db.Column(db.String(50))
    timestamp=db.Column(db.String(50))






@app.route('/')
def index():
    return render_template('index.html')
    


@app.route('/doctors',methods=['POST','GET'])
def doctors():

    if request.method=="POST":

        
        first_name=request.form.get('first_name')
        last_name=request.form.get('last_name')
        speciality=request.form.get('speciality')
        years_of_experience=request.form.get('years_of_experience')

       
        query=Doctors(first_name=first_name,last_name=last_name,speciality=speciality,years_of_experience=years_of_experience)
        db.session.add(query)
        db.session.commit()
        flash("Information is Stored","primary")

    return render_template('doctor.html')



@app.route('/patients',methods=['POST','GET'])
@login_required
def patient():
   
    doct=Doctors.query.all()

    if request.method=="POST":
        last_name=request.form.get('last_name')
        first_name=request.form.get('first_name')
        city=request.form.get('city')
        address=request.form.get('address')
        
        birth_date=request.form.get('birth_date')
        
        speciality=request.form.get('speciality')
       
        query=Patients(last_name=last_name,first_name=first_name,city=city,address=address,birth_date=birth_date,speciality=speciality)
        db.session.add(query)
        db.session.commit()
        
       
        flash("Booking Confirmed","info")


    return render_template('patient.html',doct=doct)


@app.route('/bookings')
@login_required
def bookings(): 
    em=current_user.email
    if current_user.usertype=="Doctor":
    
        query=Patients.query.all()
        return render_template('booking.html',query=query)
    else:
       
        query=Patients.query.filter_by(SSN=em)
        print(query)
        return render_template('booking.html',query=query)
    


@app.route("/edit/<string:SSN>",methods=['POST','GET'])
@login_required
def edit(SSN):    
    if request.method=="POST":
        last_name=request.form.get('last_name')
        first_name=request.form.get('first_name')
        city=request.form.get('city')
        address=request.form.get('address')
        
        birth_date=request.form.get('birth_date')
        primary_doctorSSN=request.form.get('primary_doctorSSN')
        
        
       
        post=Patients.query.filter_by(SSN=SSN).first()
        post.last_name=last_name
        post.first_name= first_name
        post.city=city
        post.address=address
        
        post.birth_date=birth_date
        post.primary_doctorSSN=primary_doctorSSN
       
        
        db.session.commit()

        flash("Slot is Updates","success")
        return redirect('/bookings')
        
    posts=Patients.query.filter_by(SSN=SSN).first()
    return render_template('edit.html',posts=posts)


@app.route("/delete/<string:SSN>",methods=['POST','GET'])
@login_required
def delete(SSN):
  
    query=Patients.query.filter_by(SSN=SSN).first()
    db.session.delete(query)
    db.session.commit()
    flash("Slot Deleted Successful","danger")
    return redirect('/bookings')






@app.route('/signup',methods=['POST','GET'])
def signup():
    if request.method == "POST":
        username=request.form.get('username')
        usertype=request.form.get('usertype')
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()
        # encpassword=generate_password_hash(password)
        if user:
            flash("Email Already Exist","warning")
            return render_template('/signup.html')

        myquery=User(username=username,usertype=usertype,email=email,password=password)
        db.session.add(myquery)
        db.session.commit()
        flash("Signup Succes Please Login","success")
        return render_template('login.html')

          

    return render_template('signup.html')

@app.route('/login',methods=['POST','GET'])
def login():
    if request.method == "POST":
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()

        if user and user.password == password:
            login_user(user)
            flash("Login Success","primary")
            return redirect(url_for('index'))
        else:
            flash("invalid credentials","danger")
            return render_template('login.html')    





    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout SuccessFul","warning")
    return redirect(url_for('login'))



@app.route('/test')
def test():
    try:
        Test.query.all()
        return 'My database is Connected'
    except:
        return 'My db is not Connected'
    

@app.route('/details')
@login_required
def details():
    posts=Trigr.query.all()
  
    return render_template('trigers.html',posts=posts)


@app.route('/search',methods=['POST','GET'])
@login_required
def search():
    if request.method=="POST":
        query=request.form.get('search')
        dept=Doctors.query.filter_by(dept=query).first()
        name=Doctors.query.filter_by(doctorname=query).first()
        if name:

            flash("Doctor is Available","info")
        else:

            flash("Doctor is Not Available","danger")
    return render_template('index.html')






app.run(debug=True)    

