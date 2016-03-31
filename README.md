# Upper Hand Developer Candidate Interview Exercises

This exercise is two-fold. The first part is pretty simple, the second part will take a little more thinking about high-level design and implementation.

## Part I
Write a Ruby program that takes a string as input and determines whether or not the string is a palindrome. The string could be a word or a phrase. The kicker... you have to write two different versions. There are quite a few ways to do this particular exercise, so if you're feeling adventurous you can adjust the tests and implement as many ways as you'd like. You'll find the shell for this program in the `palindrome` directory, and the specs in `palindrome/specs`.

## Part II
You may have been able to search for solutions to Part I of this exercise, but this part is a little more "real world." It will require you to think about the design and implementation of a real problem that we're solving at Upper Hand. The Sports Management domain is very fractured, but one part of almost any application you find in our universe is scheduling events (both single and recurring).

Your task is to write a **small** web application that allows parents to schedule recurring lessons with their kids' coaches, and allows organization administrators to schedule multi-day camps with their athletes. *Please don't be concerned about security for this application (no Devise, Sorcery, etc. is needed).* You are welcome to use any number of gems to aid in your implementation. You're welcome to use any Ruby web framework, or even a custom Rack app --- the only requirement is that we ought to be able to run your application locally and see it in action (so, if there are specific instructions for doing so, please let us know).

Some questions you may ask yourself (and will need to answer yourself):
- do users have a single role, or can they have multiple roles
- do you create and store recurring events all at once, or do you store metadata about events and "calculate" occurrences as needed
- how do you deal with conflicts (e.g. two athletes can't have a private lesson with the same coach at the same time)
 
We're purposefully not putting a lot of constraints on this part of the interview exercise, because we want to see what you come up with. But, if you have burning questions which you feel you can't answer yourself, please contact us. You shouldn't need to spend more than 10 hours on this, but if you're really driven to do so, feel free ... just be mindful of how much time it will take for us to review it.

Please use the `web-app` directory for this part of the exercise.

## Process Details
1. Fork this repository and create a PR against it for your final work, so that we can review it.
2. In your PR or in the code, please include some comments about why you did certain things. For example,
  1. What drove you to create the classes you did?
  2. How did you decide the behaviors of your objects?
  3. If you employed a pattern of some type why did you do it?
  4. If you think you have an algorithm or choice of data structure that needs explanation please do so.
