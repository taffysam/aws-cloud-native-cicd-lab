from app import calculate_shipping


def test_light_package():
    assert calculate_shipping(3) == 50


def test_medium_package():
    assert calculate_shipping(7) == 100


def test_heavy_package():
    assert calculate_shipping(15) == 150

def test_express_light_package():
    assert calculate_shipping(3, express=True) == 125


def test_express_medium_package():
    assert calculate_shipping(7, express=True) == 175


def test_express_heavy_package():
    assert calculate_shipping(15, express=True) == 225

from fastapi.testclient import TestClient
from app import app

client = TestClient(app)


def test_health_endpoint():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_shipping_endpoint():
    response = client.get("/shipping?weight=7")

    assert response.status_code == 200
    assert response.json()["shipping_cost"] == 100
    assert response.json()["express"] is False


def test_express_shipping_endpoint():
    response = client.get("/shipping?weight=7&express=true")

    assert response.status_code == 200
    assert response.json()["shipping_cost"] == 175
    assert response.json()["express"] is True


def test_invalid_weight():
    response = client.get("/shipping?weight=0")

    assert response.status_code == 422