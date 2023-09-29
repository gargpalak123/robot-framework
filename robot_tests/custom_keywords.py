from robot.libraries.BuiltIn import BuiltIn
from SeleniumLibrary import SeleniumLibrary


class CustomKeywords:

    def __init__(self):
        self.selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')

    def add_patient_with_data(self, patient_data):
        # Implement logic to add a patient using patient_data dictionary
        pass

    def book_appointment_with_data(self, appointment_data):
        # Implement logic to book an appointment using appointment_data dictionary
        pass
