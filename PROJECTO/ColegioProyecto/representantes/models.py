from django.db import models

class Representante(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido = models.CharField(max_length=100)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    email = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        db_table = "representante"   # nombre de tu tabla en MySQL

    def __str__(self):
        return f"{self.nombre} {self.apellido}"


# Create your models here.
