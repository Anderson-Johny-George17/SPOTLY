from django.contrib.auth.models import User
from django.db import models

# Create your models here.
from django.utils import timezone


class Police(models.Model):
    name=models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    place= models.CharField(max_length=100)
    phn_number= models.CharField(max_length=100)
    station_name = models.CharField(max_length=100)
    AUTH_USER = models.OneToOneField(User,on_delete=models.CASCADE)


class Customer(models.Model):
    name = models.CharField(max_length=100)
    age = models.CharField(max_length=2)
    email = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    phnone_number = models.CharField(max_length=100)
    vechicle=models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    AUTH_USER = models.OneToOneField(User,on_delete=models.CASCADE)

#
# class Alert(models.Model):
#     CUSTOMER = models.ForeignKey(Customer,on_delete=models.CASCADE)
#     phn_number = models.CharField(max_length=2)
#     date = models.CharField(max_length=100)
#     time = models.CharField(max_length=100)
#     message = models.CharField(max_length=100)
#     photo=models.CharField(max_length=500,default="")

class Complaint(models.Model):
    complaint=models.CharField(max_length=100)
    date=models.DateField()
    reply=models.CharField(max_length=120)
    status=models.CharField(max_length=200)
    AUTH_USER = models.ForeignKey(User,on_delete=models.CASCADE)

class feedback(models.Model):
    name = models.CharField(max_length=100)
    date = models.DateField()
    feedback = models.CharField(max_length=2000)
    CUSTOMER = models.ForeignKey(Customer,on_delete=models.CASCADE)

class Police_Complaint(models.Model):
    complaint = models.CharField(max_length=100)
    date = models.DateField()
    reply = models.CharField(max_length=120)
    status = models.CharField(max_length=200)
    CUSTOMER = models.ForeignKey(Customer,on_delete=models.CASCADE)
    POLICE = models.ForeignKey(Police,on_delete=models.CASCADE,default=True)


class Stolen_vehicle(models.Model):
    vehicle_type = models.CharField(max_length=200)
    vehicle_color = models.CharField(max_length=200)
    vehicle_image = models.CharField(max_length=200)
    latitude = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)
    CUSTOMER=models.ForeignKey(Customer,on_delete=models.CASCADE)

class Report(models.Model):
    date = models.DateField()
    status = models.CharField(max_length=200)
    Stolen_vehicle = models.ForeignKey(Stolen_vehicle, on_delete=models.CASCADE)
    latitude = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)
    CUSTOMER = models.ForeignKey(Customer, on_delete=models.CASCADE)

class Location(models.Model):
    latitude = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)
    USER = models.ForeignKey(User, on_delete=models.CASCADE)



class Alert(models.Model):
    stolen_vehicle = models.ForeignKey(
        Stolen_vehicle,
        on_delete=models.CASCADE,
        related_name="alerts",
        null=True,  # allows migration without defaults
        blank=True
    )
    status = models.CharField(max_length=50, default="pending")
    details = models.TextField(null=True, blank=True)  # JSONField replacement
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    detected_at = models.DateTimeField(auto_now_add=True)
    detected_image = models.CharField(max_length=700,default='')
    def __str__(self):
        return f"Alert {self.id} - {self.status}"