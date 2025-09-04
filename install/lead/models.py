from django.db import models
from django.contrib.postgres.fields import ArrayField #, JSONField => django.db.models.JSONField

class KindleLead(models.Model):
    # --- Basic identity fields ---
    first_name = models.CharField(max_length=50)                  # VARCHAR(50)
    last_name = models.CharField(max_length=50)                   # VARCHAR(50)
    email = models.EmailField(unique=True)                        # VARCHAR with unique constraint
    phone = models.CharField(max_length=20, blank=True, null=True) # VARCHAR(20)
    company_name = models.CharField(max_length=100, blank=True, null=True)  # VARCHAR(100)

    # --- Textual fields ---
    notes = models.TextField(blank=True, null=True)               # TEXT
    website = models.URLField(blank=True, null=True)              # VARCHAR + URL validation
    slug = models.SlugField(unique=True, blank=True, null=True)   # VARCHAR (indexed, slug)

    # --- Numeric fields ---
    num_employees = models.IntegerField(default=0)                # INTEGER
    annual_revenue = models.BigIntegerField(blank=True, null=True) # BIGINT
    rating = models.FloatField(default=0.0)                       # DOUBLE PRECISION
    credit_score = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)  
    # NUMERIC(5,2)

    # --- Boolean / choice ---
    is_active = models.BooleanField(default=True)                 # BOOLEAN
    status = models.CharField(
        max_length=20,
        choices=[("lead", "Lead"), ("prospect", "Prospect"), ("client", "Client")],
        default="lead"
    )                                                             # VARCHAR + CHECK constraint

    # --- Date / time fields ---
    created_at = models.DateTimeField(auto_now_add=True)          # TIMESTAMP WITH TIME ZONE
    updated_at = models.DateTimeField(auto_now=True)              # TIMESTAMP WITH TIME ZONE
    date_of_birth = models.DateField(blank=True, null=True)       # DATE
    last_contact_time = models.TimeField(blank=True, null=True)   # TIME

    # --- Relational fields ---
    referred_by = models.ForeignKey(
        "self", on_delete=models.SET_NULL, blank=True, null=True
    )                                                             # INTEGER (FK → self)

    # --- Advanced PostgreSQL fields ---
    tags = ArrayField(
        models.CharField(max_length=30),
        blank=True,
        null=True
    )                                                             # TEXT[]
    metadata = models.JSONField(blank=True, null=True)                   # JSONB
    ip_address = models.GenericIPAddressField(blank=True, null=True) # INET
    location = models.CharField(max_length=255, blank=True, null=True) # Could integrate PostGIS

    # --- File / image ---
    profile_picture = models.ImageField(upload_to="profiles/", blank=True, null=True)  
    attachment = models.FileField(upload_to="attachments/", blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} - {self.email}"
