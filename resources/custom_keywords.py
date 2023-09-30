# custom_keywords.py

from robot.api.deco import keyword
from SeleniumLibrary import SeleniumLibrary

# Create a custom library that extends SeleniumLibrary
class CustomKeywords(SeleniumLibrary):

    @keyword("Common Login")
    def common_login(self, username, password, role, expected_dashboard_url):
        """
        Common login keyword.

        :param username: The username to log in with.
        :param password: The password to log in with.
        :param role: The expected role after login.
        :param expected_dashboard_url: The expected URL of the dashboard after login.
        """
        # Navigate to the login page
        self.go_to("https://procliniq.in/login")

        # Replace with your login form locators and logic
        self.input_text("id:email", username)
        self.input_text("id:password", password)
        self.click_button("css=.h2 > b")

        # Implement your login validation logic here

        # Check the role and redirect URL
        current_url = self.get_location()
        if current_url == expected_dashboard_url:
            self.log(f"Successfully logged in as {role}. Redirected to {current_url}")
        else:
            self.fail(f"Login failed. Expected role: {role}, Actual role: {current_url}")

    @keyword("Common Check Doctor Dashboard")
    def common_check_doctor_dashboard(self, expected_dashboard_url):
        """
        Common keyword to check the doctor's dashboard.

        :param expected_dashboard_url: The expected URL of the doctor's dashboard.
        """
        # Check if the current URL matches the expected dashboard URL
        current_url = self.get_location()
        if current_url == expected_dashboard_url:
            self.log(f"Doctor's dashboard URL is correct: {current_url}")
        else:
            self.fail(f"Doctor's dashboard URL is incorrect. Expected: {expected_dashboard_url}, Actual: {current_url}")

    # Implement other keywords as needed
    def log(self, param):
        pass
