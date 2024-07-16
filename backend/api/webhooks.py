import stripe
from django.http import HttpResponse
from django.conf import settings
from django.core.handlers.wsgi import WSGIRequest
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST


@require_POST
@csrf_exempt
def stripe_webhook(request: WSGIRequest) -> HttpResponse:
    print("start webhook")
    payload = request.body
    sig_header = request.META["HTTP_STRIPE_SIGNATURE"]
    event = None
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, settings.STRIPE_ENDPOINT_SECRET
        )
    except ValueError:
        return HttpResponse(status=400)
    except stripe.errors.SignatureVerificationError:
        return HttpResponse(status=400)

    payment_intent = event.data.object
    if event.type == "payment_intent.created":
        print("payment created")
    if event.type == "payment_intent.succeeded":
        print("payment succeeded")
        event_payment_succeeded(payment_intent)
    if event.type == "payment_intent.payment_failed":
        print("payment failed")
    if event.type == "payment_intent.canceled":
        print("payment canceled")

    return HttpResponse(status=200)


def event_payment_succeeded(
    payment_intent: stripe._payment_intent.PaymentIntent,
) -> None:
    print(payment_intent)
    # need implement - add user to subscribers group
