import os
import subprocess
import uuid
import shutil
import time


def run_tests():
    # Set the destination directory for final reports
    destination_directory = 'C:\\Automation result'

    # Set the working directory to where the script is located
    script_directory = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_directory)

    try:
        while True:
            # Generate unique output file names for common and doctor-specific reports
            common_output_file = os.path.join('common_report', f'report_common_{str(uuid.uuid4())}.xml')
            doctor_output_file = os.path.join('doctor_report', f'report_doctor_{str(uuid.uuid4())}.xml')

            # Run common tests with specific tags and exclude reception and admin keywords
            common_process = subprocess.Popen([
                'robot',
                '--outputdir', 'common_report',
                '--output', common_output_file,
                '--include', 'common',
                '--exclude', 'reception', '--exclude', 'admin',
                'robot_tests/common_tests.robot'
            ])

            # Wait for the common test suite to complete but do not halt script execution
            common_process.wait()

            # Run doctor-specific tests and generate an XML report
            subprocess.run([
                'robot',
                '--outputdir', 'doctor_report',
                '--output', doctor_output_file,
                '--include', 'doctor',
                'robot_tests/doctor_tests.robot'
            ])

            # Copy common report to the destination directory
            common_destination = os.path.join(destination_directory, os.path.basename(common_output_file))
            shutil.copy(common_output_file, common_destination)

            # Copy doctor report to the destination directory
            doctor_destination = os.path.join(destination_directory, os.path.basename(doctor_output_file))
            shutil.copy(doctor_output_file, doctor_destination)

            # Merge reports
            merged_report_path = os.path.join(destination_directory, 'merged_report.html')
            subprocess.run([
                'rebot',
                '--outputdir', destination_directory,
                '--output', 'merged_report.html',
                '--report', 'html',
                common_output_file,
                doctor_output_file
            ])

            print("Tests completed successfully. Reports saved in:", destination_directory)

            # Sleep for some time before running the tests again
            time.sleep(60)  # Sleep for 60 seconds (adjust as needed)

    except Exception as e:
        print("Error:", str(e))
        # You can log the error or perform additional error-handling actions here


if __name__ == "__main__":
    run_tests()

# import os
# import subprocess
# import uuid
# import shutil
#
# def run_tests():
#     # Set the destination directory for final reports
#     destination_directory = 'C:\\Automation result'
#
#     # Set the working directory to where the script is located
#     script_directory = os.path.dirname(os.path.abspath(__file__))
#     os.chdir(script_directory)
#
#     try:
#         # Generate unique output file names for common and doctor-specific reports
#         common_output_file = os.path.join('common_report', f'report_common_{str(uuid.uuid4())}.xml')
#         doctor_output_file = os.path.join('doctor_report', f'report_doctor_{str(uuid.uuid4())}.xml')
#
#         # Run common tests with specific tags and exclude reception and admin keywords
#         common_process = subprocess.Popen([
#             'robot',
#             '--outputdir', 'common_report',
#             '--output', common_output_file,
#             '--include', 'common',
#             '--exitonfailure',
#             '--exclude', 'reception', '--exclude', 'admin',
#             'robot_tests/common_tests.robot'
#         ])
#
#         # Wait for the common test suite to complete but do not halt script execution
#         common_process.wait()
#
#         # Run doctor-specific tests and generate an XML report
#         subprocess.run([
#             'robot',
#             '--outputdir', 'doctor_report',
#             '--output', doctor_output_file,
#             '--include', 'doctor',
#             '--exitonfailure',
#             'robot_tests/doctor_tests.robot'
#         ])
#
#         # Copy common report to the destination directory
#         common_destination = os.path.join(destination_directory, os.path.basename(common_output_file))
#         shutil.copy(common_output_file, common_destination)
#
#         # Copy doctor report to the destination directory
#         doctor_destination = os.path.join(destination_directory, os.path.basename(doctor_output_file))
#         shutil.copy(doctor_output_file, doctor_destination)
#
#         # Merge reports
#         merged_report_path = os.path.join(destination_directory, 'merged_report.xml')
#         subprocess.run([
#             'rebot',
#             '--outputdir', destination_directory,
#             '--output', 'merged_report.xml',
#             common_output_file,
#             doctor_output_file
#         ])
#
#         print("Tests completed successfully. Reports saved in:", destination_directory)
#
#     except Exception as e:
#         print("Error:", str(e))
#         # You can log the error or perform additional error-handling actions here
#
# if __name__ == "__main__":
#     run_tests()
