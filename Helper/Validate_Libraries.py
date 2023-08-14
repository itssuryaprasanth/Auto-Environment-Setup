import subprocess
from bs4 import BeautifulSoup
import re


def validate_libraries():
    config_path = '../Config.xml'
    config_list = []
    with open(config_path) as config_file:
        xml_data = BeautifulSoup(config_file.read(), 'html.parser')
    libraries_tag = xml_data.find_all("Libraries")
    for _single_package in str(libraries_tag).split('>'):
        if _single_package.__contains__('<Package'):
            try:
                _package_name = re.search(".*Name=\W([A-z]+\W?[A-z]+\W?[A-z|0-9]+)", _single_package).group(1)
                _version = re.search(".*Version=\W(\d.\d.*)\W/", _single_package).group(1)
                config_list.append(_package_name + '==' + _version)
            except AttributeError:
                continue

    installed_pip_packages = subprocess.run(["powershell", "-Command", "pip freeze"], capture_output=True)
    shell_regex = str(installed_pip_packages.stdout).replace('\n', '')
    for _single_package in config_list:
        if _single_package not in shell_regex:
            raise EnvironmentError(f"{_single_package} IS NOT MATCHING AS EXPECTED OR NOT INSTALLED PROPERLY")


validate_libraries()
