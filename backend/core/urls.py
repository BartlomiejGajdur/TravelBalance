from django.contrib import admin
from django.urls import path, include
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from api import urls as api_urls
from api.webhooks import stripe_webhook


schema_view = get_schema_view(
    openapi.Info(
        title="Wanderer API",
        default_version="v1",
        description="",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email=""),
        license=openapi.License(name=""),
    ),
    public=True,
)


urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/v1/", include(api_urls)),
    path("payment/stripe_webhook/", stripe_webhook, name="stripe-webhook"),
    path(
        "api/v1/swagger/",
        schema_view.with_ui("swagger", cache_timeout=0),
        name="schema-swagger-ui",
    ),
    path(
        "api/v1/documentation/",
        schema_view.with_ui("redoc", cache_timeout=0),
        name="schema-redoc",
    ),
    path(
        "api/v1/documentation/swagger.json",
        schema_view.without_ui(cache_timeout=0),
        name="schema-json",
    ),
]
