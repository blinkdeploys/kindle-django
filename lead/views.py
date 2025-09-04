from rest_framework import viewsets
from .models import KindleLead
from .serializers import KindleLeadSerializer
from django.shortcuts import render


# API viewset
class KindleLeadViewSet(viewsets.ModelViewSet):
    queryset = KindleLead.objects.all().order_by('-created_at')
    serializer_class = KindleLeadSerializer


# HTML view
def kindle_lead_list(request):
    leads = KindleLead.objects.all().order_by('-created_at')
    return render(request, 'lead/kindle_lead_list.html', {'leads': leads})

