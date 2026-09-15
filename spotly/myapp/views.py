# from django.contrib import messages
import smtplib
from datetime import datetime
from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import Group,User
from django.core.files.storage import FileSystemStorage
from django.http import JsonResponse
from django.shortcuts import render, redirect


# Create views here.
from myapp.models import Police, Complaint, Customer, Police_Complaint, Alert, feedback, Stolen_vehicle, Location, \
    Report


def index(request):
    return render(request,'index.html')

def login_get(request):
    return render(request,'login.html')

def home(request):
    police_count=Police.objects.all().count()
    users_count=Customer.objects.all().count()
    complaints_count=Complaint.objects.all().count()
    print("ddddddddddddd")
    last_complaint = Complaint.objects.order_by('-id').first()
    last_user = Customer.objects.order_by('-id').first()
    last_police =Police.objects.order_by('-id').first()
    print("sssssss",last_complaint)
    return render(request, 'admin_Home.html',{"police_count":police_count,"users_count":users_count,"complaints_count":complaints_count,"last_complaint":last_complaint,"last_user":last_user,"last_police":last_police})


def login_post(request):
    username = request.POST.get('username')
    password = request.POST.get('password')

    ob = authenticate(request, username=username, password=password)

    if ob is not None:
        login(request, ob)
        if ob.groups.filter(name='admin').exists():
            return redirect('/myapp/home/')
        elif ob.groups.filter(name='police').exists():
            return redirect('/myapp/police_home/')

        else:
            messages.error(request, 'You are not authorized!')
            return redirect('/myapp/login_get/')
    else:
        messages.error(request, 'Invalid username or password!')
        return redirect('/myapp/login_get/')



def reg_police_get(request):
    return render(request,'ADMIN/Add police.html')

def reg_police_post(request):
    name=request.POST['name']
    email=request.POST['email']
    place=request.POST['place']
    phn_number=request.POST['phn_number']
    station_name=request.POST['station_name']
    import random;
    password=random.randint(0000,9999)
    print(password,"password")

    # SEND EMAIL
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login("leagaladvisorteam@gmail.com", "eugnxtyylwtqwlav")

    message = f"""Subject: Police Login Credentials

    Dear {name},

    You are added as an Police Officer.

    Username: {email}
    Password: {password}

    Please change your password after login.
    """
    server.sendmail("leagaladvisorteam@gmail.com", email, message)
    server.quit()

    # confirm_password=request.POST['confirm_password']
    # if password!= confirm_password:
    #     messages.error(request,"password not match")
    #     return redirect('/myapp/reg_police_reply_post/')


    user=User.objects.create_user(username=email,password=password)

    police_group=Group.objects.get(name='police')
    user.groups.add(police_group)
    user.save()

    o=Police()
    o.AUTH_USER_id=user.id
    o.name=name
    o.email=email
    o.place=place
    o.phn_number=phn_number
    o.station_name=station_name
    o.save()
    messages.success(request,'Added succesfully')
    return redirect('/myapp/reg_police_get/')



def change_pass_get(request):
    return render(request, 'ADMIN/change_pass.html')

def change_pass_post(request):
    current_password=request.POST['current_password']
    new_password=request.POST['new_password']
    confirm_password=request.POST['confirm_password']
    user=request.user
    if not check_password(current_password,user.password):
        messages.success(request,"Invalid username or password")
        return redirect('/maypp/change_pass_get/')

    user.set_password(new_password)
    user.save()

    return redirect('/myapp/login_get/')

def view_police(request):
    o=Police.objects.all()
    return render(request,'ADMIN/view police.html',{'data':o})


def edit_police_get(request,id):
    o=Police.objects.get(id=id)
    return render(request,'ADMIN/edit police.html',{'data':o})

def edit_police_post(request):
    pid=request.POST['pid']
    name=request.POST['name']
    email=request.POST['email']
    place=request.POST['place']
    phn_number=request.POST['phn_number']
    station_name=request.POST['station_name']
    o=Police()
    o=Police.objects.get(id=pid)
    o.name=name
    o.email=email
    o.place=place
    o.phn_number=phn_number
    o.station_name=station_name
    o.save()
    messages.success(request,'Updated succesfully')
    return redirect('/myapp/view_police/')


def admin_police_delete(request,id):
    o=Police.objects.get(id=id).delete()
    messages.success(request,'deleted succesfully')
    return redirect('/myapp/view_police/',{'data':o})

def view_complaint(request):
    o=Complaint.objects.all()
    return render(request,'ADMIN/view complaint.html',{'data':o})
def admin_view_complaint(request):
    o=Complaint.objects.all()
    return render(request,'ADMIN/view complaint.html',{'data':o})


def admin_reply_get(request,rid):
    return render(request,'ADMIN/reply.html',{'rid':rid})


def admin_reply_post(request):
    reply=request.POST['reply']
    rid=request.POST['rid']

    o=Complaint.objects.get(id=rid)
    o.reply=reply
    o.status='replied'
    o.date=datetime.now()
    o.save()
    messages.success(request,"reply added")
    return redirect('/myapp/admin_view_complaint/')


def view_users_get(request):

    data=Customer.objects.all()
    return render(request,'ADMIN/view users.html',{'data':data})


def view_feedback(request):
    feedbacks = feedback.objects.all().order_by('-date')
    return render(request, 'ADMIN/view feedback.html', {'feedbacks': feedbacks})

def about_spotly(request):
    return render(request, 'about.html')

#####################
# ##############################################################################
# police


def police_home(request):
    return render(request, 'POLICE/home.html')

def police_view_complaints(request):
  o=Police_Complaint.objects.filter()
  return render(request,'POLICE/view_complaints.html',{'data':o})

def accept_user(request,id):
    o=Police_Complaint.objects.get(id=id)
    o.status='pending'
    o.save()
    messages.success(request,'Accepted sucessfully')

def reject_user(request, id):
    o = Police_Complaint.objects.get(id=id)
    o.status = 'pending'
    o.save()
    messages.success(request, 'Reject sucessfully')

#
# def alerts_get(request):
#     return render(request,'POLICE/alerts.html')
#
# def alert_post(request):
#     =request.POST['complaint']
#     o=Complaint()
#     o.complaint=complaint
#     o.date=datetime.now()
#     o.reply='pending'
#     o.status='pending'
#     o.AUTH_USER_id=request.user.id
#     o.save()
#     messages.success(request,'sent successfully')
#     return redirect('/myapp/police_sent_complaint_get/')


def police_reply_get(request,id):
    data=Police_Complaint.objects.get(id=id)
    return render(request,'POLICE/reply.html',{'data':data})

def police_reply_post(request):
    reply=request.POST['reply']
    rid=request.POST['id']

    o=Police_Complaint.objects.get(id=rid)
    o.reply=reply
    o.status='replied'
    o.date=datetime.now()
    o.save()
    messages.success(request,"reply added")
    return redirect('/myapp/police_view_complaints/')

def police_sent_complaint_get(request):
    return render(request,'POLICE/sent_complaint.html')


def police_sent_complaint_post(request):
    complaint=request.POST['complaint']
    o=Complaint()
    o.complaint=complaint
    o.date=datetime.now()
    o.reply='pending'
    o.status='pending'
    o.AUTH_USER_id=request.user.id
    o.save()
    messages.success(request,'sent successfully')
    return redirect('/myapp/police_sent_complaint_get/')



def police_change_pass_get(request):
    return render(request, 'POLICE/change_pass.html')



def police_change_pass_post(request):
    current_password=request.POST['current_password']
    new_password=request.POST['new_password']
    confirm_password=request.POST['confirm_password']
    user=request.user
    if not check_password(current_password,user.password):
        messages.success(request,"Invalid username or password")
        return redirect('/maypp/police_change_pass_get/')

    user.set_password(new_password)
    user.save()

    return redirect('/myapp/police_home/')

def police_view_stolen(request):
  o=Stolen_vehicle.objects.filter()
  return render(request,'POLICE/view_stolen vehicle.html',{'data':o})

def police_view_alerts(request):
    alerts = Alert.objects.all().order_by('-detected_at')
    return render(request, 'POLICE/alerts.html', {'alerts': alerts})




#####################################

#
# def police_view_alert(request):
#     o=Alert.objects.get(CUSTOMER__AUTH_USER_id=request.user)
#     messages.success(request,"police_view_alert.html",{'data':o})
#########################################################################


def Applogin(request):
    username=request.POST['username']
    password=request.POST['password']

    ob = authenticate(request, username=username, password=password)
    print(ob)

    if ob is not None:
        if ob.groups.filter(name='users').exists():
            return JsonResponse({'status':'ok','lid':str(ob.id)})
        else:
            return JsonResponse({'status':'error'})
    else:
        return JsonResponse({'status': 'error'})


def reg_customer(request):
    name=request.POST['name']
    email=request.POST['email']
    age = request.POST['age']
    place=request.POST['place']
    phn_number=request.POST['phn_number']
    vechicle=request.POST['vechicle']
    password = request.POST.get('password')
    user=User.objects.create_user(username=email,password=password)

    customer_group=Group.objects.get(name='users')
    user.groups.add(customer_group)
    user.save()

    o=Customer()
    o.AUTH_USER_id=user.id
    o.name=name
    o.email=email
    o.age=age
    o.place=place
    o.phnone_number=phn_number
    o.vechicle=vechicle
    o.save()
    messages.success(request,'Added succesfully')
    return JsonResponse({'status':'ok'})

def view_profile(request):
    cid=request.POST['cid']
    print(cid)
    o=Customer.objects.get(AUTH_USER_id=cid)
    return JsonResponse({'status':'ok','id':cid,'name':o.name,'age':o.age,
    'email':o.email,'place':o.place,'phnone_number':o.phnone_number,'vechicle':o.vechicle})

def edit_profile(request):
    cid=request.POST['cid']
    name=request.POST['name']
    age=request.POST['age']
    email=request.POST['email']
    place=request.POST['place']
    phnone_number=request.POST['phnone_number']
    vechicle=request.POST['vechicle']
    o=Customer.objects.get(AUTH_USER_id=cid)
    o.name=name
    o.age=age
    o.email=email
    o.place=place
    o.phnone_number=phnone_number
    o.vechicle=vechicle
    o.save()
    messages.success(request,'updated successfully')
    return JsonResponse({'status':'ok'})

def user_changepassword(request):
    current_password=request.POST['current_password']
    new_password = request.POST['new_password']
    lid=request.POST['lid']
    user=User.objects.get(id=lid)
    if not check_password(current_password,user.password):
        return JsonResponse({'status':"error"})
    user.set_password(new_password)
    user.save()
    return JsonResponse({'status':'ok'})



def sent_complaint_post(request):
    feedback_=request.POST['feedback']
    lid = request.POST['lid']
    c = Customer.objects.get(AUTH_USER=lid)
    o=feedback()
    o.name=c.name
    o.date=datetime.now()
    o.feedback = feedback_
    o.CUSTOMER_id=c.id
    o.save()
    messages.success(request,'sent successfully')
    return JsonResponse({'status':'ok'})

def viw_stolen_get(request):
    # lid=request.POST['lid']
    # o = Stolen_vehicle.objects.filter(CUSTOMER__AUTH_USER_id=lid)
    o = Stolen_vehicle.objects.all()
    data=[]
    for i in o:
        data.append({'id':i.id,'vehicle_type':i.vehicle_type,'vehicle_color':i.vehicle_color,'latitude':i.latitude,'longitude':i.longitude,'vehicle_image':str(i.vehicle_image)})
    return JsonResponse({'status': 'ok','data':data})


def delete_stolen_vechile(request):
    id = request.POST['lid']
    o = Stolen_vehicle.objects.get(CUSTOMER__AUTH_USER_id=id).delete()
    return JsonResponse({'status': 'ok'})





def report_stolen(request):
    cid=request.POST['cid']
    print(cid)
    o=Customer.objects.get(AUTH_USER_id=cid)
    return JsonResponse({'status':'ok','id':cid,'name':o.name,'age':o.age,
    'email':o.email,'place':o.place,'phnone_number':o.phnone_number,'vechicle':o.vechicle})

def report_stolen_vehilcle(request):
    cid=request.POST['customer_id']
    vehicle_type=request.POST['vehicle_type']
    vehicle_color=request.POST['vehicle_color']
    vehicle_image=request.FILES['vehicle_image']
    latitude=request.POST['latitude']
    longitude=request.POST['longitude']

    fs = FileSystemStorage()
    date = datetime.now().strftime('%Y%m%d-%H%M%S')+".jpg"
    fs.save(date,vehicle_image)
    path = fs.url(date)

    o=Stolen_vehicle()
    o.vehicle_type= vehicle_type
    o.vehicle_color= vehicle_color
    o.vehicle_image=path
    o.latitude= latitude
    o.longitude= longitude
    o.CUSTOMER = Customer.objects.get(AUTH_USER_id=cid)

    o.save()
    messages.success(request,'updated successfully')
    return JsonResponse({'status':'ok'})



def setlocation(request):
    lati = request.POST['lati']
    longi = request.POST['longi']
    lid = request.POST['lid']
    l =Location.objects.get(USER_id = lid)
    if l is not None:
        l.latitude = lati
        l.longitude = longi
        l.save()
        print('this')
        return JsonResponse({'status':'ok'})

    l =Location()
    l.latitude = lati
    l.longitude = longi
    l.USER_id = lid
    l.save()
    return  JsonResponse({'status':'ok'})

def found_stolen_vehicle(request):

    Stolen_vehicle = request.POST['stolen_v_id']
    latitude = request.POST['lati']
    longitude = request.POST['longi']
    CUSTOMER = request.POST['lid']

    r = Report()
    r.date = datetime.today()
    r.status = 'found'
    r.Stolen_vehicle_id = Stolen_vehicle
    r.CUSTOMER = Customer.objects.get(AUTH_USER_id=CUSTOMER)
    r.latitude = latitude
    r.longitude = longitude
    r.save()


    return  JsonResponse({'status':'ok'})

def view_police_stations(request):
    data = []
    qs = Police.objects.all()
    for p in qs:
        data.append({
            "id": p.id,
            "station_name": p.station_name,
            "place": p.place,
            "phone": p.phn_number,
        })

    return JsonResponse({"status": "ok", "data": data})
def send_complaint(request):
    police_id = request.POST['police_id']
    complaint = request.POST['complaint']
    lid = request.POST['lid']

    customer = Customer.objects.get(AUTH_USER__id=lid)
    police = Police.objects.get(id=police_id)

    Police_Complaint.objects.create(
        CUSTOMER=customer,
        POLICE=police,
        complaint=complaint,
        date=datetime.now().date(),
        reply="pending",
        status="pending"
    )

    return JsonResponse({"status": "ok"})

def view_my_complaints(request):
    lid = request.GET.get('lid')

    customer = Customer.objects.get(AUTH_USER__id=lid)
    complaints = Police_Complaint.objects.filter(CUSTOMER=customer).order_by('-date')

    data = []
    for c in complaints:
        data.append({
            "station": c.POLICE.station_name,
            "place": c.POLICE.place,
            "complaint": c.complaint,
            "reply": c.reply if c.reply else "No reply yet",
            "status": c.status if c.status else "Pending",
            "date": c.date.strftime("%d-%m-%Y"),
        })

    return JsonResponse({"status": "ok", "data": data})


# def view_alert(request):
#     lid=request.POST['lid']
#
#     data = []
#     qs = Alert.objects.filter(stolen_vehicle__CUSTOMER__AUTH_USER_id=lid)
#     for p in qs:
#         data.append({
#             "id": p.id,
#             "status": p.status,
#             "details": p.details,
#             "latitude": p.latitude,
#             "longitude": p.longitude,
#             "detected_at": p.detected_at,
#             "stolen_vehicle_id": p.stolen_vehicle_id,
#         })
#
#     return JsonResponse({"status": "ok", "data": data})
#
# def view_alert(request):
#     lid = request.POST.get('lid', None)
#
#     print(lid)
#     if not lid:
#         return JsonResponse({"status": "error", "message": "lid is required"})
#
#     data = []
#
#     # Get all alerts for this user
#     qs = Alert.objects.filter(stolen_vehicle__CUSTOMER__AUTH_USER_id=lid)
#     print(qs)
#
#     for alert in qs:
#         print('ggggggggggggggggggg')
#
#
#         data.append({
#             "id": alert.id,
#             "status": alert.status,
#             "details": alert.details,
#             "latitude": alert.latitude,
#             "longitude": alert.longitude,
#             "detected_at": alert.detected_at,
#             "stolen_vehicle_id": alert.stolen_vehicle_id,
#         })
#
#     print(data)
#     return JsonResponse({"status": "ok", "data": data})



def view_alert(request):
    lid = request.POST.get('lid', None)

    if not lid:
        return JsonResponse({"status": "error", "message": "lid is required"})

    data = []

    qs = Alert.objects.filter(stolen_vehicle__CUSTOMER__AUTH_USER_id=lid)

    for alert in qs:
        detected_image_url = ''
        if alert.detected_image:
            detected_image_url = alert.detected_image

        data.append({
            "id": alert.id,
            "status": alert.status,
            "details": alert.details,
            "latitude": alert.latitude,
            "longitude": alert.longitude,
            "detected_at": alert.detected_at,
            "detected_image": detected_image_url,
            "stolen_vehicle_id": alert.stolen_vehicle_id,
        })

    return JsonResponse({"status": "ok", "data": data})
