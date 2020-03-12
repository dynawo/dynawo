import os
import sys
import re
from optparse import OptionParser

try:
    nrt_dir = os.environ["DYNAWO_NRT_SCRIPT_DIR"]
    sys.path.append(nrt_dir)
    from nrt import TestCase
    sys.path.remove(nrt_dir)
except:
    print ("Failed to import non-regression test script")
    sys.exit(1)

data_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "data")

def collectXsl(directory, types):
    xsl_to_apply = {}
    for type in types:
        xsl_to_apply[type] = []
    for file in os.listdir(directory):
        for type in types:
            if file.endswith("."+type+".xsl"):
                xsl_to_apply[type].append(os.path.join(directory, file))

    for type in types:
        xsl_to_apply[type].sort()
    return  xsl_to_apply

def applyXsl(file, xsl_file):
    print("Applying " + xsl_file + " to " + file)
    cmd = "xsltproc -o " + file +" " + xsl_file+ " " + file
    os.system(cmd)

def updateTestCase(testcase, xsl_to_apply):
    for type in xsl_to_apply:
        files = xsl_to_apply[type]
        if type == "jobs":
            for file in files:
                applyXsl(testcase.jobs_file_, file)
        else:
            for job in testcase.jobs_:
                if type == "dyd":
                    for file in xsl_to_apply["dyd"]:
                        for dyd_file in job.dyd_files_:
                            applyXsl(dyd_file, file)
                if type == "crv":
                    for file in xsl_to_apply["crv"]:
                        for curves_file in job.curves_files_:
                            applyXsl(curves_file, file)
                if type == "par":
                    for file in xsl_to_apply["par"]:
                        for par_file in job.par_files_:
                            applyXsl(par_file, file)



def main():
    usage=u""" Usage: %prog

    Script to update Dynawo inputs to latest format
    """

    options = {}

    options[('-n', '--name')] = {'dest': 'directory_names', 'action':'append',
                                    'help': 'name filter to only run some non-regression tests'}

    options[('-p', '--pattern')] = {'dest': 'directory_patterns', 'action' : 'append',
                                    'help': 'regular expression filter to only run some non-regression tests'}

    options[('-t', '--types')] = {'dest': 'types', 'action' : 'append',
                                    'help': 'type of files to update (jobs, dyd, par, crv)'}


    options[('-j', '--jobs')] = {'dest': 'jobs_file', 'default' : '',
                                    'help': 'jobs file of the test to apply the update'}

    parser = OptionParser(usage)
    for param, option in options.items():
        parser.add_option(*param, **option)
    (options, args) = parser.parse_args()

    log_message = "Applying xsl"

    with_directory_name = False
    directory_names = []
    if (options.directory_names is not None) and (len(options.directory_names) > 0):
        with_directory_name = True
        directory_names = options.directory_names
        log_message += " with"

        for dir_name in directory_names:
            log_message += " '" + dir_name + "'"

        log_message += " name filter"

    directory_patterns = []
    if (options.directory_patterns is not None) and  (len(options.directory_patterns) > 0):
        directory_patterns = options.directory_patterns
        if with_directory_name:
            log_message += " and"
        else:
            log_message += " with"

        for pattern in directory_patterns:
            log_message += " '" + pattern + "'"

        log_message += " pattern filter"

    jobs_file = ""
    if (options.jobs_file is not None) and  (len(options.jobs_file) > 0):
        jobs_file = options.jobs_file

    types = ""
    possible_types=["jobs","dyd","crv","par"]
    if (options.types is not None) and  (len(options.types) > 0):
        types = options.types
        for type in types:
            if type not in possible_types:
                print("type should be one of jobs, dyd, crv, par (found " + type + ")")
                exit(1)
    else:
        types = possible_types

    print (log_message)

    xsl_to_apply = collectXsl(os.path.dirname(os.path.realpath(__file__)),types)
    # Loop on testcases
    if jobs_file == "":
        numCase = 0
        for case_dir in os.listdir(data_dir):
            case_path = os.path.join(data_dir, case_dir)
            if os.path.isdir(case_path) == True and \
                case_dir != ".svn" : # In order to check that we are dealing with a repository and not a file, .svn repository is filtered

                # Get needed info to build object TestCase
                sys.path.append(case_path)
                try:
                    import cases
                    sys.path.remove(case_path) # Remove from path because all files share the same name

                    for case_name, case_description, job_file, estimated_computation_time, return_code_type, expected_return_codes in cases.test_cases:

                        relative_job_dir = os.path.relpath (os.path.dirname (job_file), data_dir)
                        keep_job = True

                        if (len (directory_names) > 0):
                            for dir_name in directory_names:
                                if (dir_name not in relative_job_dir):
                                    keep_job = False
                                    break

                        if keep_job and (len (directory_patterns) > 0):
                            for pattern in directory_patterns:
                                if  (re.search(pattern, relative_job_dir) is None):
                                    keep_job = False
                                    break

                        if keep_job :
                            case = "case_" + str(numCase)
                            numCase += 1
                            current_test = TestCase(case, case_name, case_description, job_file, estimated_computation_time, return_code_type, expected_return_codes)
                            updateTestCase(current_test, xsl_to_apply)

                    del sys.modules['cases'] # Delete load module in order to load another module with the same name
                except:
                    pass
    else:
        current_test = TestCase("case", "customCase", "", jobs_file, "0", "", "")
        updateTestCase(current_test, xsl_to_apply)


if __name__ == "__main__":
    main()
