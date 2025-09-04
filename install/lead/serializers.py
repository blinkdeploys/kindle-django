from rest_framework import serializers
from .models import KindleLead


class KindleLeadSerializer(serializers.ModelSerializer):
    class Meta:
        model = KindleLead
        fields = '__all__'
