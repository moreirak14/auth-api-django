import unittest
from django.contrib.auth import get_user_model

User = get_user_model()


class TestUserAccountUnit(unittest.TestCase):

    def test_constructor(self):
        user = User(first_name="test", last_name="monalisa", email="test@test.com")
        self.assertEqual(user.first_name, "test")
        self.assertEqual(user.last_name, "monalisa")
        self.assertEqual(user.email, "test@test.com")
