import pytest
import socket
import requests

def is_mongodb_running(host, port):
    """Check if MongoDB is running on the specified host and port."""
    try:
        with socket.create_connection((host, port), timeout=5):
            return True
    except (socket.timeout, ConnectionRefusedError):
        return False

@pytest.mark.parametrize("host, port", [("localhost", 27017)])
def test_mongodb_container_running(host, port):
    """Test if MongoDB container is running."""
    assert is_mongodb_running(host, port), f"MongoDB is not running on {host}:{port}"

def test_test_get():
    """Test if the test_get API works."""
    url = "http://localhost:5000/test_get"
    response = requests.get(url)
    assert response.status_code == 200, "test_get API did not return status 200"
    assert isinstance(response.json(), list), "test_get API did not return a list"

def test_test_post():
    """Test if the test_post API works."""
    url = "http://localhost:5000/test_post"
    new_item = {"new_item": "111"}
    response = requests.post(url, json=new_item)
    assert response.status_code == 200, "test_post API did not return status 200"
    assert any(item['value'] == "111" for item in response.json()), "test_post API did not insert the new item"