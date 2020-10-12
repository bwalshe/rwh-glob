# Globber

This is an exercise from Chapter 8 of Real World Haskell. They supply functions
to check if file paths match a glob pattern, but whihc can cause errors if the 
glob pattern is malformed. The exercise was to rewrite the functions to use 
the `Either a b` monad to handle these errors. I added a main function and 
created a Stack project for good measure.
