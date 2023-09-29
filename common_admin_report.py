import os
import subprocess
import webbrowser


def run_tests():
    # Run common tests and generate a report
    subprocess.run(
        ['robot', '--outputdir', 'common_report', '--output', 'common_report.xml', 'robot_tests/common_tests.robot'])

    # Run admin-specific tests and generate a report
    subprocess.run(
        ['robot', '--outputdir', 'admin_report', '--output', 'admin_report.xml', 'robot_tests/admin_tests.robot'])

    # Merge reports
    subprocess.run(['rebot', '--outputdir', 'merged_report', '--output', 'merged_report.html', 'common_report.xml',
                    'admin_report.xml'])

    # Open the merged report in a web browser
    report_url = 'file://' + os.path.abspath('merged_report/merged_report.html')
    webbrowser.open(report_url)


if __name__ == "__main__":
    run_tests()
