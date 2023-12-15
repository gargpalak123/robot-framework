import os
import subprocess
import uuid
import shutil
import time
import logging

def setup_logging():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        filename='test_runner.log',
        filemode='w'
    )

def run_tests():
    setup_logging()

    # Set the destination directory for final reports
    destination_directory = 'C:\\Automation result'

    # Set the working directory to where the script is located
    script_directory = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_directory)

    try:
        test_counter = 0  # Add a counter to limit the number of test runs
        max_test_runs = 3
        sleep_interval = 60  # Sleep for 60 seconds (adjust as needed)

        while test_counter < max_test_runs:
            test_counter += 1

            common_output_file = os.path.join('common_report', f'report_common_{str(uuid.uuid4())}.xml')
            doctor_output_file = os.path.join('doctor_report', f'report_doctor_{str(uuid.uuid4())}.xml')

            doctor_login_process = subprocess.Popen([
                'robot',
                '--outputdir', 'doctor_report',
                '--output', doctor_output_file,
                '--test', 'Doctor Login Test',
                'robot_tests/doctor_login_test.robot'
            ])
            doctor_login_process.wait()

            if doctor_login_process.returncode == 0:
                common_process = subprocess.Popen([
                    'robot',
                    '--outputdir', 'common_report',
                    '--output', common_output_file,
                    '--include', 'common',
                    '--exclude', 'reception', '--exclude', 'admin',
                    'robot_tests/common_tests.robot'
                ])
                common_process.wait()

                common_destination = os.path.join(destination_directory, os.path.basename(common_output_file))
                shutil.copy(common_output_file, common_destination)

                doctor_destination = os.path.join(destination_directory, os.path.basename(doctor_output_file))
                shutil.copy(doctor_output_file, doctor_destination)

                merged_report_path = os.path.join(destination_directory, 'merged_report.html')
                subprocess.run([
                    'rebot',
                    '--outputdir', destination_directory,
                    '--output', 'merged_report.html',
                    '--report', 'html',
                    common_output_file,
                    doctor_output_file
                ])

                logging.info("Tests completed successfully. Reports saved in: %s", destination_directory)
            else:
                logging.warning("Doctor login test failed. Skipping common tests.")

            time.sleep(sleep_interval)

    except Exception as e:
        logging.error("Error: %s", str(e))
        # You can log the error or perform additional error-handling actions here

if __name__ == "__main__":
    run_tests()
