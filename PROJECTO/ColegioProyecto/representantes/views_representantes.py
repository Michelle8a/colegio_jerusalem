from django.shortcuts import render
from .models import Representante

def lista_representantes(request):
    representantes = Representante.objects.all()
    return render(request, 'representantes/lista.html', {'representantes': representantes})

# Create your views here.
