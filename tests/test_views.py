import pytest
from django.urls import reverse


@pytest.mark.django_db
def test_login_page_loads(client):
    response = client.get(reverse('login'))
    assert response.status_code == 200


@pytest.mark.django_db
def test_dashboard_redirects_unauthenticated(client):
    response = client.get(reverse('dashboard'))
    assert response.status_code == 302


@pytest.mark.django_db
def test_login_with_invalid_credentials(client):
    response = client.post(reverse('login'), {'username': 'wrong', 'password': 'wrong'})
    assert response.status_code == 200
    assert b'Invalid credentials' in response.content
