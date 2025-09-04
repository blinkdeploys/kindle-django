from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import KindleLeadViewSet, kindle_lead_list


router = DefaultRouter()
router.register(r'leads', KindleLeadViewSet)


urlpatterns = [
    path('api/', include(router.urls)),  # API endpoints
    path('', kindle_lead_list, name='kindle_lead_list'),  # HTML view
]

