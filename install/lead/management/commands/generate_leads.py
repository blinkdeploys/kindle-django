from django.core.management.base import BaseCommand
from lead.models import KindleLead
from faker import Faker
import random


class Command(BaseCommand):
    help = "Generate fake KindleLead leads for testing/marketing outreach"

    def add_arguments(self, parser):
        parser.add_argument(
            '--count',
            type=int,
            default=100,
            help="Number of leads to generate (default: 100)"
        )

    def truncate(self, value, max_length):
        if value is None:
            return None
        return value[:max_length]

    def handle(self, *args, **options):
        fake = Faker()
        count = options['count']

        for _ in range(count):
            client = KindleLead.objects.create(
                first_name=self.truncate(fake.first_name(), 50),
                last_name=self.truncate(fake.last_name(), 50),
                email=self.truncate(fake.unique.email(), 254),  # Django default max for EmailField
                phone=self.truncate(fake.phone_number(), 20),
                company_name=self.truncate(fake.company(), 100),
                notes=fake.text(max_nb_chars=200),
                website=self.truncate(fake.url(), 200),
                slug=self.truncate(fake.slug(), 50),
                num_employees=random.randint(1, 500),
                annual_revenue=random.randint(10_000, 5_000_000),
                rating=round(random.uniform(1.0, 5.0), 2),
                credit_score=round(random.uniform(300, 850), 2),
                is_active=random.choice([True, False]),
                status=random.choice(["lead", "prospect", "client"]),
                date_of_birth=fake.date_of_birth(minimum_age=21, maximum_age=65),
                last_contact_time=fake.time(),
                tags=[self.truncate(fake.word(), 30) for _ in range(random.randint(1, 4))],
                metadata={
                    "campaign": self.truncate(fake.bs(), 100),
                    "industry": self.truncate(fake.company_suffix(), 50),
                    "region": self.truncate(fake.country(), 50)
                },
                ip_address=fake.ipv4_public(),
                location=self.truncate(fake.city(), 255),
            )
            self.stdout.write(self.style.SUCCESS(f"Created lead: {client}"))

        self.stdout.write(self.style.SUCCESS(f"\nSuccessfully created {count} fake leads!"))

