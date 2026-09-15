
from django.urls import path

from myapp import views

urlpatterns = [
    path('index/',views.index),
    path('login_get/',views.login_get),
    path('home/',views.home),
    path('login_post/',views.login_post),
    path('reg_police_get/',views.reg_police_get),
    path('reg_police_post/',views.reg_police_post),
    path('change_pass_get/',views.change_pass_get),
    path('change_pass_post/', views.change_pass_post),
    path('edit_police_get/<id>/',views.edit_police_get),
    path('edit_police_post/', views.edit_police_post),
    path('admin_police_delete/<id>/', views.admin_police_delete),
    path('admin_reply_get/<rid>',views.admin_reply_get),
    path('admin_reply_post/',views.admin_reply_post),
    path('view_police/',views. view_police),
    path('view_complaint/',views.view_complaint),
    path('admin_view_complaint/',views.admin_view_complaint),
    path('view_users_get/',views.view_users_get),
    path('view_feedback/',views.view_feedback),
    path('about_spotly/',views.about_spotly),


    #############


    path('police_home/',views.police_home),
    path('police_change_pass_get/',views.police_change_pass_get),
    path('police_change_pass_get/', views.police_change_pass_get),
    # path('alerts_get/',views.alerts_get),
    path('police_reply_get/<id>/',views.police_reply_get),
    path('police_reply_post/',views.police_reply_post),
    path('police_sent_complaint_get/',views.police_sent_complaint_get),
    path('accept_user/', views.accept_user),
    path('reject_user/', views.reject_user),

    path('police_view_complaints/',views.police_view_complaints),
    path('police_sent_complaint_post/',views.police_sent_complaint_post),
    path('police_view_alerts/',views.police_view_alerts),
    # path('police_view_alert/',views.police_view_alert),
    path('police_view_stolen/',views.police_view_stolen),

    ####
    path('Applogin/',views.Applogin),
    path('reg_customer/', views.reg_customer),
    path('job_seeker_profile/', views.view_profile),
    path('update_job_seeker_profile/', views.edit_profile),
    path('user_changepassword/', views.user_changepassword),
    path('sent_complaint/', views.sent_complaint_post),
    path('view_my_complaints/', views.view_my_complaints),
    path('viw_stolen_get/', views.viw_stolen_get),
    path('delete_stolen_vechile/', views.delete_stolen_vechile),
    path('report_stolen_vehicle/', views.report_stolen_vehilcle),
    path('setlocation/', views.setlocation),
    path('found_stolen_vehicle/', views.found_stolen_vehicle),
    path('view_police_stations/', views.view_police_stations),
    path('send_complaint/', views.send_complaint),
    path('view_alert/', views.view_alert),


]
