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
            admin_output_file = os.path.join('reception_report', f'report_reception_{str(uuid.uuid4())}.xml')

            # Run doctor login test
            reception_login_process = subprocess.Popen([
                'robot',
                '--outputdir', 'reception_report',
                '--output', reception_output_file,
                '--test', 'reception Login Test',
                'robot_tests/reception_login_tests.robot'
            ])

            # Wait for the doctor login test to complete but do not halt script execution
            reception_login_process.wait()

            # Check if doctor login test passed before proceeding with common tests
            if reception_login_process.returncode == 0:
                # Run common tests with specific tags and exclude reception and admin keywords
                common_process = subprocess.Popen([
                    'robot',
                    '--outputdir', 'common_report',
                    '--output', common_output_file,
                    '--include', 'common',
                    '--exclude', 'doctor', '--exclude', 'admin',
                    'robot_tests/common_tests.robot'
                ])

                # Wait for the common test suite to complete but do not halt script execution
                common_process.wait()

                # Copy common report to the destination directory
                common_destination = os.path.join(destination_directory, os.path.basename(common_output_file))
                shutil.copy(common_output_file, common_destination)

                # Copy doctor report to the destination directory
                reception_destination = os.path.join(destination_directory, os.path.basename(reception_output_file))
                shutil.copy(reception_output_file, reception_destination)

                # Merge reports
                merged_report_path = os.path.join(destination_directory, 'merged_report.html')
                subprocess.run([
                    'rebot',
                    '--outputdir', destination_directory,
                    '--output', 'merged_report.html',
                    '--report', 'html',
                    common_output_file,
                    reception_output_file
                ])

                print("Tests completed successfully. Reports saved in:", destination_directory)

            else:
                print("reception login test failed. Skipping common tests.")

            # Sleep for some time before running the tests again
            time.sleep(60)  # Sleep for 60 seconds (adjust as needed)

    except Exception as e:
        print("Error:", str(e))
        # You can log the error or perform additional error-handling actions here

if __name__ == "__main__":
    run_tests()
