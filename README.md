Interview task :)
===============================

If something is not clear or you need help - just ask :smile:. Nobody knows everything!

1. Read the task
2. Create a project
3. Please implement the project according to your own best standards, possibly
   - Tests, tdd
   - Code guidelines
   - Structure / architecture
   - Refactoring
   - Conventions
4. For the layout bootstrap or plain design is enough.
5. Make sure to commit frequently and feel free to stop working on it after 2-4 hours
6. Provide an overview which points you would improve if you had more time to work on the project

N.B.: Please do not make the repo publicly accessible. Send an archive of your repo to us instead.

Scenario - Product Import via File Upload
---------------------------

Story: A new kloeckner US branch needs to be onboarded, for this we got a new feature request from our product owner.

The user should be able to upload a csv to import products into the database. This data should then be shown in a list.

The upload should work multiple times and always update the corresponding products.
Bonus Feature: Products that are not in the CSV get deleted (can be enabled via checkbox)

Lines in the CSV represent steel products.

An example CSV is in the repo.
Here is some help to understand the CSV structure:

PART_NUMBER = identifier for a product
BRANCH_ID = which kloeckner branch produces the product (TUC = tucson, CIN = cincinnati)
PART_PRICE = price in USD
SHORT_DESC = short description text about the product

Have fun!
