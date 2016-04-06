# Upper Hand Developer Candidate Interview Exercises

This exercise is two-fold. The first part is pretty simple, the second part will take a little more thinking about high-level design and implementation.

## Part I
Write a Ruby program that takes a string as input and determines whether or not the string is a palindrome. The string could be a word or a phrase. The kicker... you have to write two different versions. There are quite a few ways to do this particular exercise, so if you're feeling adventurous you can adjust the tests and implement as many ways as you'd like. You'll find the shell for this program in the `palindrome` directory, and the specs in `palindrome/specs`.

## Part II
You may have been able to search for solutions to Part I of this exercise, but this part is a little more "real world." It will require you to think about the design and implementation of a real problem that we're solving at Upper Hand. The Sports Management domain is very fractured, but one part of almost any application you find in our universe is scheduling events (both single and recurring).

You may use your language of choice for this part of the exercise. Your task is to write a script that will test for schedule conflicts as users attempt to schedule lessons with instructors. Each line of the `input.csv` file can be thought of as a single API request for scheduling a lesson. You should process this file in order, assuming that each line comes into our application sequentially.

There are several types of conflicts that could occur. For example, a user may try to schedule a lesson during the same time he or she has another lesson (_student not available_). Or, a user may try to schedule a lesson during a time that the instructor is not available (_instructor not available_). Your script should output the conflicts in the schedule in the following format (if you cannot discern the reason for the conflict, you should output _other_):

    <blank line>
    Request ID: ...
    Reason for Conflict: [student not available|instructor not available|other]
    <blank line>

If there are multiple reasons for conflict please write them all out separated by a comma (e.g. "Reason for Conflict: student not available,instructor not available")

You'll find the input files in the `schedule` directory. Please use that directory to house the code for this part of the exercise.

#### Notes on Training Types

The `input.csv` and `instructor_availability.csv` files refer to two different types of lessons: _Group Lesson_ and _Private Lesson_. Refer to the rules below for each lesson type.

**Group Lesson**

Group lessons have a duration and are **only** allowed to be scheduled in **single blocks** (e.g. you cannot schedule a 1-hour group lesson for 2 hours, which would be considered 2 blocks of time). Each instructor has a maximum participant restriction, after which the group lesson should be considered not available.


**Private Lesson**

Private lessons have a duration and are allowed to be scheduled in multiple blocks at one time (e.g. a 1/2 hour lesson duration can be scheduled by the same person for 2 hours, comprising 4 blocks of time).

#### Notes on Input Files

- Instructors are referenced by name in the `With` column of the `input.csv` file and are not case-sensitive.
- Both CSV files have 4 columns dealing with the time of lessons: Start Date and End Date, and Start Time and End Time. The _Date_ columns represent the valid days on which lessons can occur, while the _Time_ columns represent valid time ranges within those dates. For purposes of this exercise, any day of the week is considered valid within those date ranges (Sunday through Saturday).

## Process Details
1. Fork this repository and create a PR against it for your final work, so that we can review it.
2. In your PR or in the code, please include some comments about why you did certain things. For example,
  1. What drove you to create the classes you did (if any)?
  2. How did you decide the behaviors of your objects?
  3. If you employed a pattern of some type why drove you to that decision?
  4. If you think you have an algorithm, or choice of data structure, that needs explanation please add some comments.
3. For the second part, please include instructions for running your script, especially if there are dependencies (e.g. `pip install ...`, `gem install ...`, `mvn ...`).
