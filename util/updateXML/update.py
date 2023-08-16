from content.sources.Job.Jobs import Jobs

def main():
    jobs = Jobs()  # create a representation of a Job XML file
    jobs.update()  # method to call update functions in every update scripts of the directory


if __name__ == '__main__':
    main()
